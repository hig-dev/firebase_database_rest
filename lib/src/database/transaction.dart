import 'package:meta/meta.dart';

import '../rest/api_constants.dart';

class AlreadyComittedError extends StateError {
  AlreadyComittedError() : super('Transaction has already been committed');
}

class TransactionFailedException implements Exception {
  final String oldETag;
  final String newETag;

  TransactionFailedException({
    this.oldETag = ApiConstants.nullETag,
    this.newETag = ApiConstants.nullETag,
  });

  @override
  String toString() => 'Transaction failed - '
      'Database entry was modified since the transaction was started.';
}

abstract class FirebaseTransaction<T> {
  String get key;
  T get value;
  String get eTag;

  Future<T?> commitUpdate(T data);

  Future<void> commitDelete();
}

abstract class SingleCommitTransaction<T> implements FirebaseTransaction<T> {
  bool _committed = false;

  @protected
  Future<T?> commitUpdateImpl(T data);

  @protected
  Future<void> commitDeleteImpl();

  @nonVirtual
  @override
  Future<T?> commitUpdate(T data) {
    _assertNotCommitted();
    return commitUpdateImpl(data);
  }

  @nonVirtual
  @override
  Future<void> commitDelete() {
    _assertNotCommitted();
    return commitDeleteImpl();
  }

  void _assertNotCommitted() {
    if (_committed) {
      throw AlreadyComittedError();
    } else {
      _committed = true;
    }
  }
}
