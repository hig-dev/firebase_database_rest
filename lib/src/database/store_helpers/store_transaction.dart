import '../../rest/api_constants.dart';
import '../etag_receiver.dart';
import '../store.dart';
import '../transaction.dart';

class StoreTransaction<T> extends SingleCommitTransaction<T> {
  final FirebaseStore<T> store;

  @override
  final String key;

  @override
  final T value;

  @override
  final String eTag;

  final bool silent;
  final ETagReceiver? eTagReceiver;

  StoreTransaction({
    required this.store,
    required this.key,
    required this.value,
    required this.eTag,
    required this.silent,
    required this.eTagReceiver,
  });

  @override
  Future<T?> commitUpdateImpl(T data) async {
    final response = await store.restApi.put(
      // ignore: invalid_use_of_protected_member
      store.dataToJson(data),
      path: store.buildPath(key),
      printMode: silent ? PrintMode.silent : null,
      ifMatch: eTag,
      eTag: eTagReceiver != null,
    );
    store.applyETag(eTagReceiver, response);
    // ignore: invalid_use_of_protected_member
    return silent ? null : store.dataFromJson(response.data);
  }

  @override
  Future<void> commitDeleteImpl() async {
    final response = await store.restApi.delete(
      path: store.buildPath(key),
      printMode: PrintMode.silent,
      ifMatch: eTag,
      eTag: eTagReceiver != null,
    );
    store.applyETag(eTagReceiver, response);
  }
}
