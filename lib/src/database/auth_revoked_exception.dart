class AuthRevokedException implements Exception {
  @override
  String toString() =>
      'Authentication credentials have expired or have been revoked';
}
