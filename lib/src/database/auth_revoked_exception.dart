// coverage:ignore-file
import '../../firebase_database_rest.dart';

/// An exception that is thrown by [FirebaseStore] streams when the current
/// authentication must be refreshed.
class AuthRevokedException implements Exception {
  @override
  String toString() =>
      'Authentication credentials have expired or have been revoked';
}
