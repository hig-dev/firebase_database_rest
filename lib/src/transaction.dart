class AlreadyComittedError extends StateError {
  AlreadyComittedError() : super('Transaction has already been committed');
}

abstract class FirebaseTransaction<T> {
  String get key;
  T get value;
  String get eTag;

  Future<T> commitUpdate(T data);

  Future<void> commitDelete();
}
