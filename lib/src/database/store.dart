import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

import '../rest/api_constants.dart';
import '../rest/models/db_response.dart';
import '../rest/models/filter.dart';
import '../rest/models/post_response.dart';
import '../rest/rest_api.dart';
import 'etag_receiver.dart';
import 'store_event.dart';
import 'store_helpers/callback_store.dart';
import 'store_helpers/store_event_transformer.dart';
import 'store_helpers/store_key_event_transformer.dart';
import 'store_helpers/store_patchset.dart';
import 'store_helpers/store_transaction.dart';
import 'store_helpers/store_value_event_transformer.dart';
import 'transaction.dart';

typedef DataFromJsonCallback<T> = T Function(dynamic json);

typedef DataToJsonCallback<T> = dynamic Function(T data);

typedef PatchDataCallback<T> = T Function(
  T data,
  Map<String, dynamic> updatedFields,
);

abstract class FirebaseStore<T> {
  final RestApi restApi;
  final List<String> subPaths;
  String get path => buildPath();

  @protected
  FirebaseStore({
    required FirebaseStore<dynamic> parent,
    required String path,
  })   : restApi = parent.restApi,
        subPaths = [...parent.subPaths, path];

  @protected
  FirebaseStore.api({
    required this.restApi,
    required this.subPaths,
  });

  factory FirebaseStore.create({
    required FirebaseStore<dynamic> parent,
    required String path,
    required DataFromJsonCallback<T> onDataFromJson,
    required DataToJsonCallback<T> onDataToJson,
    required PatchDataCallback<T> onPatchData,
  }) = CallbackFirebaseStore;

  factory FirebaseStore.apiCreate({
    required RestApi restApi,
    required List<String> subPaths,
    required DataFromJsonCallback<T> onDataFromJson,
    required DataToJsonCallback<T> onDataToJson,
    required PatchDataCallback<T> onPatchData,
  }) = CallbackFirebaseStore.api;

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

  Future<List<String>> keys({ETagReceiver? eTagReceiver}) async {
    final response = await restApi.get(
      path: buildPath(),
      shallow: true,
      eTag: eTagReceiver != null,
    );
    applyETag(eTagReceiver, response);
    return (response.data as Map<String, dynamic>?)?.keys.toList() ?? [];
  }

  Future<Map<String, T>> all({ETagReceiver? eTagReceiver}) async {
    final response = await restApi.get(
      path: buildPath(),
      eTag: eTagReceiver != null,
    );
    applyETag(eTagReceiver, response);
    return _mapTransform(response.data);
  }

  Future<T?> read(String key, {ETagReceiver? eTagReceiver}) async {
    final response = await restApi.get(
      path: buildPath(key),
      eTag: eTagReceiver != null,
    );
    applyETag(eTagReceiver, response);
    return dataFromJson(response.data);
  }

  Future<T?> write(
    String key,
    T data, {
    bool silent = false,
    String? eTag,
    ETagReceiver? eTagReceiver,
  }) async {
    final response = await restApi.put(
      dataToJson(data),
      path: buildPath(key),
      printMode: silent ? PrintMode.silent : null,
      ifMatch: eTag,
      eTag: eTagReceiver != null,
    );
    applyETag(eTagReceiver, response);
    return silent ? null : dataFromJson(response.data);
  }

  Future<String> create(T data, {ETagReceiver? eTagReceiver}) async {
    final response = await restApi.post(
      dataToJson(data),
      path: buildPath(),
      eTag: eTagReceiver != null,
    );
    applyETag(eTagReceiver, response);
    final result = PostResponse.fromJson(response.data as Map<String, dynamic>);
    return result.name;
  }

  Future<T?> update(
    String key,
    Map<String, dynamic> updateFields, {
    bool silent = false,
  }) async {
    final response = await restApi.patch(
      updateFields,
      path: buildPath(key),
      printMode: silent ? PrintMode.silent : null,
    );
    return silent ? null : dataFromJson(response.data);
  }

  Future<T?> delete(
    String key, {
    bool silent = false,
    String? eTag,
    ETagReceiver? eTagReceiver,
  }) async {
    final response = await restApi.delete(
      path: buildPath(key),
      printMode: silent ? PrintMode.silent : null,
      ifMatch: eTag,
      eTag: eTagReceiver != null,
    );
    applyETag(eTagReceiver, response);
    return silent ? null : dataFromJson(response.data);
  }

  Future<Map<String, T>> query(
    Filter filter, {
    ETagReceiver? eTagReceiver,
  }) async {
    final response = await restApi.get(
      path: buildPath(),
      filter: filter,
      eTag: eTagReceiver != null,
    );
    applyETag(eTagReceiver, response);
    return _mapTransform(response.data);
  }

  Future<List<String>> queryKeys(
    Filter filter, {
    ETagReceiver? eTagReceiver,
  }) async {
    final response = await restApi.get(
      path: buildPath(),
      filter: filter,
      shallow: true,
      eTag: eTagReceiver != null,
    );
    applyETag(eTagReceiver, response);
    return (response.data as Map<String, dynamic>?)?.keys.toList() ?? [];
  }

  Future<FirebaseTransaction<T>> transaction(
    String key, {
    bool silent = false,
    ETagReceiver? eTagReceiver,
  }) async {
    final response = await restApi.get(
      path: buildPath(key),
      eTag: true,
    );
    return StoreTransaction(
      store: this,
      key: key,
      value: dataFromJson(response.data),
      eTag: response.eTag!,
      silent: silent,
      eTagReceiver: eTagReceiver,
    );
  }

  Future<Stream<StoreEvent<T>>> streamAll() async {
    final stream = await restApi.stream(
      path: buildPath(),
    );
    return stream.transform(StoreEventTransformer(
      dataFromJson: dataFromJson,
      patchSetFactory: (data) => StorePatchSet(store: this, data: data),
    ));
  }

  Future<Stream<DataEvent<String>>> streamKeys() async {
    final stream = await restApi.stream(
      path: buildPath(),
      shallow: true,
    );
    return stream.transform(const StoreKeyEventTransformer());
  }

  Future<Stream<DataEvent<T>>> streamEntry(String key) async {
    final stream = await restApi.stream(
      path: buildPath(key),
    );
    return stream.transform(StoreValueEventTransformer(
      dataFromJson: dataFromJson,
      patchSetFactory: (data) => StorePatchSet(store: this, data: data),
    ));
  }

  Future<Stream<StoreEvent<T>>> streamQuery(Filter filter) async {
    final stream = await restApi.stream(
      path: buildPath(),
      filter: filter,
    );
    return stream.transform(StoreEventTransformer(
      dataFromJson: dataFromJson,
      patchSetFactory: (data) => StorePatchSet(store: this, data: data),
    ));
  }

  Future<Stream<DataEvent<String>>> streamQueryKeys(Filter filter) async {
    final stream = await restApi.stream(
      path: buildPath(),
      filter: filter,
      shallow: true,
    );
    return stream.transform(const StoreKeyEventTransformer());
  }

  @protected
  T dataFromJson(dynamic json); // can be null

  @protected
  dynamic dataToJson(T data); // can be null

  @protected
  T patchData(T data, Map<String, dynamic> updatedFields);

  @internal
  String buildPath([String? key]) =>
      (key != null ? [...subPaths, key] : subPaths).join('/');

  @internal
  void applyETag(ETagReceiver? eTagReceiver, DbResponse response) {
    if (eTagReceiver != null) {
      assert(
        response.eTag != null,
        'ETag-Header must not be null when an ETag has been requested',
      );
      eTagReceiver.eTag = response.eTag;
    }
  }

  Map<String, T> _mapTransform(dynamic data) =>
      (data as Map<String, dynamic>?)?.map(
        (key, dynamic value) => MapEntry(
          key,
          dataFromJson(value),
        ),
      ) ??
      {};
}
