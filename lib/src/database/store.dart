import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart' hide JsonConverter;
import 'package:meta/meta.dart';

import '../../firebase_database_rest.dart';
import '../common/api_constants.dart';
import '../common/filter.dart';
import '../rest/models/db_response.dart';
import '../rest/models/post_response.dart';
import '../rest/rest_api.dart';
import 'etag_receiver.dart';
import 'json_converter.dart';
import 'store_event.dart';
import 'store_helpers/callback_store.dart';
import 'store_helpers/map_transform.dart';
import 'store_helpers/store_event_transformer.dart';
import 'store_helpers/store_key_event_transformer.dart';
import 'store_helpers/store_patchset.dart';
import 'store_helpers/store_transaction.dart';
import 'store_helpers/store_value_event_transformer.dart';
import 'transaction.dart';

/// A callback definition for a method that converts a [json] object to a data
/// type.
///
/// The [json] beeing passed to this method can never be `null`.
typedef DataFromJsonCallback<T> = T Function(dynamic json);

/// A callback definition for a method that converts a [data] type to a json
/// object.
///
/// The json beeing returned from this method **must never** be `null`.
typedef DataToJsonCallback<T> = dynamic Function(T data);

/// A callback definition for a method that applies a set of [updatedFields] on
/// existing [data].
///
/// This should return a copy of [data], with all fields that appear in
/// [updatedFields] updated to the respective value. Any fields that do not
/// appear in [updatedFields] should stay unchanged.
typedef PatchDataCallback<T> = T Function(
  T data,
  Map<String, dynamic> updatedFields,
);

/// A callback the generates instances of a [PatchSet] from a set of
/// [updatedFields].
typedef PatchSetFactory<T> = PatchSet<T> Function(
  Map<String, dynamic> updatedFields,
);

/// A store the provides access to a selected part of a firebase database.
///
/// This class is the core element of the library. It's a view to a part of
/// the database, specifically a defined [path] and all elements directly
/// beneath this path.
///
/// This is an abstract class, as it is typed and needs converter functions
/// to transform the data to json and back, as firebase expects a json
/// representation of whatever you want to store there. You can either extend
/// this class and implement the required methods, or you can use
/// [FirebaseStore.create] and pass callbacks to it to do the same.
abstract class FirebaseStore<T>
    with MapTransform<T>
    implements JsonConverter<T> {
  /// The underlying [RestApi] that is used to communicate with the server.
  final RestApi restApi;

  /// A raw, segmented representation of [path].
  final List<String> subPaths;

  /// The virtual root path of this store.
  String get path => _buildPath();

  /// Constructs a store from a [parent] store and a sub [path].
  ///
  /// The created store will use the same [restApi] as the parent, but append
  /// [path] to it's [subPaths], meaning it will have a deeper virtual root as
  /// it's parent.
  ///
  /// This is a protected constructor, typically used when extending this class.
  @protected
  FirebaseStore({
    required FirebaseStore<dynamic> parent,
    required String path,
  })   : restApi = parent.restApi,
        subPaths = [...parent.subPaths, path];

  /// Constructs a store from a [restApi] and a list of [subPaths].
  ///
  /// This is a direct constructor, without utilizing a parent store. However,
  /// it requires you to get access to a [RestApi] first.
  ///
  /// This is a protected constructor, typically used when extending this class.
  ///
  /// **Note:** Typically, you would use a [FirebaseDatabase] to create a "root"
  /// store instead of using this constructor.
  @protected
  FirebaseStore.api({
    required this.restApi,
    required this.subPaths,
  });

  /// Constructs a store from a [parent] store and a sub [path] with callbacks.
  ///
  /// The created store will use the same [restApi] as the parent, but append
  /// [path] to it's [subPaths], meaning it will have a deeper virtual root as
  /// it's parent.
  ///
  /// The callbacks are used to perform the serialization from and to JSON.
  /// [onDataFromJson] is used to convert a json value to [T], [onDataToJson]
  /// does the other way around. [onPatchData] is used to process patch updates
  /// from the server and update instances of [T].
  factory FirebaseStore.create({
    required FirebaseStore<dynamic> parent,
    required String path,
    required DataFromJsonCallback<T> onDataFromJson,
    required DataToJsonCallback<T> onDataToJson,
    required PatchDataCallback<T> onPatchData,
  }) = CallbackFirebaseStore;

  /// Constructs a store from a [restApi] and a list of [subPaths] with
  /// callbacks.
  ///
  /// This is a direct constructor, without utilizing a parent store. However,
  /// it requires you to get access to a [RestApi] first.
  ///
  /// The callbacks are used to perform the serialization from and to JSON.
  /// [onDataFromJson] is used to convert a json value to [T], [onDataToJson]
  /// does the other way around. [onPatchData] is used to process patch updates
  /// from the server and update instances of [T].
  ///
  /// **Note:** Typically, you would use a [FirebaseDatabase] to create a "root"
  /// store instead of using this constructor.
  factory FirebaseStore.apiCreate({
    required RestApi restApi,
    required List<String> subPaths,
    required DataFromJsonCallback<T> onDataFromJson,
    required DataToJsonCallback<T> onDataToJson,
    required PatchDataCallback<T> onPatchData,
  }) = CallbackFirebaseStore.api;

  /// Creates a callback based child store to this store.
  ///
  /// Simply a shortcut for [FirebaseStore.create], using `this` as `parent` and
  /// passing [path], [onDataFromJson], [onDataToJson], [onPatchData] to it.
  FirebaseStore<U> subStore<U>({
    required String path,
    required DataFromJsonCallback<U> onDataFromJson,
    required DataToJsonCallback<U> onDataToJson,
    required PatchDataCallback<U> onPatchData,
  }) =>
      FirebaseStore.create(
        parent: this,
        path: path,
        onDataFromJson: onDataFromJson,
        onDataToJson: onDataToJson,
        onPatchData: onPatchData,
      );

  /// Lists all keys of the store.
  ///
  /// This will return all the keys of entries that are direct children to this
  /// store.
  ///
  /// If [eTagReceiver] was specified, it will contain the current eTag of the
  /// whole store after the returned future was resolved.
  Future<List<String>> keys({ETagReceiver? eTagReceiver}) async {
    final response = await restApi.get(
      path: _buildPath(),
      shallow: eTagReceiver == null,
      eTag: eTagReceiver != null,
    );
    _applyETag(eTagReceiver, response);
    return (response.data as Map<String, dynamic>?)?.keys.toList() ?? [];
  }

  /// Read all entries from the store.
  ///
  /// If [eTagReceiver] was specified, it will contain the current eTag of the
  /// whole store after the returned future was resolved.
  Future<Map<String, T>> all({ETagReceiver? eTagReceiver}) async {
    final response = await restApi.get(
      path: _buildPath(),
      eTag: eTagReceiver != null,
    );
    _applyETag(eTagReceiver, response);
    return mapTransform(response.data, dataFromJson);
  }

  /// Read the entry with the given key from the store.
  ///
  /// If an entry exists for [key], the deserialized value will be returned. If
  /// it does not exists, `null` is returned instead.
  ///
  /// If [eTagReceiver] was specified, it will contain the current eTag of the
  /// read entry after the returned future was resolved.
  Future<T?> read(String key, {ETagReceiver? eTagReceiver}) async {
    final response = await restApi.get(
      path: _buildPath(key),
      eTag: eTagReceiver != null,
    );
    _applyETag(eTagReceiver, response);
    return response.data != null ? dataFromJson(response.data) : null;
  }

  /// Writes the given data to the store.
  ///
  /// This method will store [data] unter [key] in the store, replacing anything
  /// stored there before. On success, the written value is returned, unless
  /// [silent] is set to true. In that case, it always returns `null`.
  ///
  /// If [eTagReceiver] was specified, it will contain the current eTag of the
  /// written entry after the returned future was resolved. To only write to the
  /// store if data was not changed, pass the [eTag] of the last known value.
  ///
  /// **Note:** When using [eTag], [silent] must not be true as these two cannot
  /// be combined.
  Future<T?> write(
    String key,
    T data, {
    bool silent = false,
    String? eTag,
    ETagReceiver? eTagReceiver,
  }) async {
    assert(
      !silent || eTag == null,
      'Cannot set silent and eTag at the same time',
    );
    final response = await restApi.put(
      dataToJson(data),
      path: _buildPath(key),
      printMode: silent ? PrintMode.silent : null,
      ifMatch: eTag,
      eTag: eTagReceiver != null,
    );
    _applyETag(eTagReceiver, response);
    return !silent && response.data != null
        ? dataFromJson(response.data)
        : null;
  }

  /// Creates a new entry in the store.
  ///
  /// This method will store [data] under a random, server generated key in the
  /// store, ensuring it is always a new child and will not replace anything.
  /// On success, the key of the newly created entry is returned.
  ///
  /// If [eTagReceiver] was specified, it will contain the current eTag of the
  /// created entry after the returned future was resolved.
  Future<String> create(T data, {ETagReceiver? eTagReceiver}) async {
    final response = await restApi.post(
      dataToJson(data),
      path: _buildPath(),
      eTag: eTagReceiver != null,
    );
    _applyETag(eTagReceiver, response);
    final result = PostResponse.fromJson(response.data as Map<String, dynamic>);
    return result.name;
  }

  /// Partially updates an existing entry in the store.
  ///
  /// Updates the entry under [key]. This is a partial update that will only
  /// change the fields specified in [updateFields], all other fields of the
  /// entry stay unchanged. To delete a field, add it with `null` to
  /// [updateFields].
  ///
  /// By default, always returns `null`. However, if you specify [currentData],
  /// if the request succeeds, the [currentData] will be patched with
  /// [updateFields] and the patched entry returned, mirroring the current state
  /// on the server, given that [currentData] is the same as the previous server
  /// state.
  Future<T?> update(
    String key,
    Map<String, dynamic> updateFields, {
    T? currentData,
  }) async {
    final response = await restApi.patch(
      updateFields,
      path: _buildPath(key),
      printMode: currentData == null ? PrintMode.silent : null,
    );
    return currentData != null
        ? patchData(currentData, response.data as Map<String, dynamic>)
        : null;
  }

  /// Removes an entry from the store.
  ///
  /// Deletes the entry stored under [key] from the server.
  ///
  /// If [eTagReceiver] was specified, it will contain the current eTag of the
  /// deleted entry after the returned future was resolved. This should always
  /// be [ApiConstants.nullETag], but is available here for consistency. To only
  /// delete from the store if data was not changed, pass the [eTag] of the last
  /// known value.
  Future<void> delete(
    String key, {
    String? eTag,
    ETagReceiver? eTagReceiver,
  }) async {
    final response = await restApi.delete(
      path: _buildPath(key),
      printMode: eTag == null ? PrintMode.silent : null,
      ifMatch: eTag,
      eTag: eTagReceiver != null,
    );
    _applyETag(eTagReceiver, response);
  }

  /// Queries a subset of entries from the store.
  ///
  /// Uses the given [filter] to get a filtered view of elements of the store
  /// from the server. Check the [Filter] docs to read how you can filter.
  /// Returns all entries (with keys) that match the filter.
  Future<Map<String, T>> query(Filter filter) async {
    final response = await restApi.get(
      path: _buildPath(),
      filter: filter,
    );
    return mapTransform(response.data, dataFromJson);
  }

  /// Queries a subset of keys from the store.
  ///
  /// Uses the given [filter] to get a filtered view of elements of the store
  /// from the server. Check the [Filter] docs to read how you can filter.
  /// Returns the keys of all entries that match the filter.
  ///
  /// **Note:** This is *not* more efficient than using [query]. This sends the
  /// exact same request as [query], but omits the values of the returned data
  /// and only returns the keys. It is faster in that it skips the
  /// deserialization of values, but the network costs are the same.
  Future<List<String>> queryKeys(Filter filter) async {
    final response = await restApi.get(
      path: _buildPath(),
      filter: filter,
    );
    return (response.data as Map<String, dynamic>?)?.keys.toList() ?? [];
  }

  /// Starts a write transaction on the store.
  ///
  /// Reads the current value of [key] from the store, including the current
  /// eTag. Returns a transaction constructed from that result. You can use that
  /// transaction to update or delete the store entry, making sure it has not
  /// been modified since it was read.
  ///
  /// If [eTagReceiver] was specified, it will contain the current eTag of the
  /// updated or deleted entry after the transaction was *committed*. **Not**
  /// after this future resolves, like for other methods. To get the eTag of
  /// the read operation, use [FirebaseTransaction.eTag].
  Future<FirebaseTransaction<T>> transaction(
    String key, {
    ETagReceiver? eTagReceiver,
  }) async {
    final response = await restApi.get(
      path: _buildPath(key),
      eTag: true,
    );
    return StoreTransaction(
      store: this,
      key: key,
      value: response.data != null ? dataFromJson(response.data) : null,
      eTag: response.eTag!,
      eTagReceiver: eTagReceiver,
    );
  }

  /// Streams all changes in the store.
  ///
  /// Requests a stream from the server and returns that stream. The stream
  /// will initially report a [StoreEvent.reset] with all data in the store and
  /// then send other events, as data is modified on the server in realtime.
  Future<Stream<StoreEvent<T>>> streamAll() async {
    final stream = await restApi.stream(
      path: _buildPath(),
    );
    return stream.transform(StoreEventTransformer(
      dataFromJson: dataFromJson,
      patchSetFactory: (data) => StorePatchSet(store: this, data: data),
    ));
  }

  /// Streams all changes by keys in the store.
  ///
  /// Requests a stream from the server and returns that stream. The stream
  /// will initially report a [KeyEvent.reset] with all keys in the store and
  /// then send other events, as data is modified on the server in realtime. It
  /// will send events for created and deleted keys, but also for keys that only
  /// had their values changed (but the key stayed the same).
  Future<Stream<KeyEvent>> streamKeys() async {
    final stream = await restApi.stream(
      path: _buildPath(),
      shallow: true,
    );
    return stream.transform(const StoreKeyEventTransformer());
  }

  /// Streams changes of a single entry in the store.
  ///
  /// Creates a stream that follows the value of the entry under [key]. It will
  /// initially send [ValueEvent.update] and then send other events, as the
  /// entry is modified on the server in realtime.
  Future<Stream<ValueEvent<T>>> streamEntry(String key) async {
    final stream = await restApi.stream(
      path: _buildPath(key),
    );
    return stream.transform(StoreValueEventTransformer(
      dataFromJson: dataFromJson,
      patchSetFactory: (data) => StorePatchSet(store: this, data: data),
    ));
  }

  /// Streams all changes in the store that match the given filter.
  ///
  /// Requests a stream from the server and returns that stream. The stream
  /// will initially report a [StoreEvent.reset] with all data in the store that
  /// matches [filter] and then send other events, as data is modified on the
  /// server in realtime. It will only send events for modified data that
  /// matches [filter] as well.
  Future<Stream<StoreEvent<T>>> streamQuery(Filter filter) async {
    final stream = await restApi.stream(
      path: _buildPath(),
      filter: filter,
    );
    return stream.transform(StoreEventTransformer(
      dataFromJson: dataFromJson,
      patchSetFactory: (data) => StorePatchSet(store: this, data: data),
    ));
  }

  /// Streams all changes by keys in the store that match the given filter.
  ///
  /// Requests a stream from the server and returns that stream. The stream
  /// will initially report a [KeyEvent.reset] with all keys in the store that
  /// match [filter] and then send other events, as data is modified on the
  /// server in realtime. It will only send events for modified data that
  /// matches [filter] for created and deleted keys, but also for keys that only
  /// had their values changed (but the key stayed the same).
  Future<Stream<KeyEvent>> streamQueryKeys(Filter filter) async {
    final stream = await restApi.stream(
      path: _buildPath(),
      filter: filter,
    );
    return stream.transform(const StoreKeyEventTransformer());
  }

  /// Deletes everything in the store.
  ///
  /// Recursively deletes all values that exists in this store. After this
  /// operation, the store will be empty.
  ///
  /// If [eTagReceiver] was specified, it will contain the current eTag of the
  /// deleted store after the returned future was resolved. This should always
  /// be [ApiConstants.nullETag], but is available here for consistency. To only
  /// destroy the store if data was not changed, pass the [eTag] of the last
  /// known store state. You can obtain this eTag via [keys] or [all].
  Future<void> destroy({
    String? eTag,
    ETagReceiver? eTagReceiver,
  }) async {
    final response = await restApi.delete(
      path: _buildPath(),
      printMode: eTag == null ? PrintMode.silent : null,
      ifMatch: eTag,
      eTag: eTagReceiver != null,
    );
    _applyETag(eTagReceiver, response);
  }

  @override
  T dataFromJson(dynamic json);

  @override
  dynamic dataToJson(T data);

  @override
  T patchData(T data, Map<String, dynamic> updatedFields);

  String _buildPath([String? key]) =>
      (key != null ? [...subPaths, key] : subPaths).join('/');

  void _applyETag(ETagReceiver? eTagReceiver, DbResponse response) {
    if (eTagReceiver != null) {
      assert(
        response.eTag != null,
        'ETag-Header must not be null when an ETag has been requested',
      );
      eTagReceiver.eTag = response.eTag;
    }
  }
}
