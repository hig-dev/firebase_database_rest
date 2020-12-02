import 'rest_api.dart';

class AlreadyComittedError extends StateError {
  AlreadyComittedError() : super('Transaction has already been committed');
}

class TransactionFailedException implements Exception {
  final String oldETag;
  final String newETag;

  TransactionFailedException({
    this.oldETag = RestApi.nullETag,
    this.newETag = RestApi.nullETag,
  });

  @override
  String toString() => 'Transaction failed - '
      'Database entry was modified since the transaction was started.';
}

abstract class FirebaseTransaction<T> {
  String get key;
  T get value;
  String get eTag;

  Future<T> commitUpdate(T data);

  Future<void> commitDelete();
}
