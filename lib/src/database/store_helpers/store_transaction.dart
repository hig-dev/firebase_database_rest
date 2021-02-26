import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/api_constants.dart';
import '../../common/db_exception.dart';
import '../etag_receiver.dart';
import '../store.dart';
import '../transaction.dart';

@internal
class StoreTransaction<T> extends SingleCommitTransaction<T> {
  final FirebaseStore<T> store;

  @override
  final String key;

  @override
  final T? value;

  @override
  final String eTag;

  final ETagReceiver? eTagReceiver;

  StoreTransaction({
    required this.store,
    required this.key,
    required this.value,
    required this.eTag,
    required this.eTagReceiver,
  });

  @override
  Future<T?> commitUpdateImpl(T data) async {
    try {
      return await store.write(
        key,
        data,
        eTag: eTag,
        eTagReceiver: eTagReceiver,
      );
    } on DbException catch (e) {
      if (e.statusCode == ApiConstants.statusCodeETagMismatch) {
        throw const TransactionFailedException();
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> commitDeleteImpl() async {
    try {
      await store.delete(
        key,
        eTag: eTag,
        eTagReceiver: eTagReceiver,
      );
    } on DbException catch (e) {
      if (e.statusCode == ApiConstants.statusCodeETagMismatch) {
        throw const TransactionFailedException();
      } else {
        rethrow;
      }
    }
  }
}
