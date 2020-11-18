abstract class FirebaseTransaction<T> {
  String get key;

  T get value;

  bool get modified;

  bool get deleted;

  void update(T value);

  void delete();

  Future<T> commit();
}
