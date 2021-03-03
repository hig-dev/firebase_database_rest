import 'package:meta/meta.dart';

import '../../firebase_database_rest.dart';

/// Error that gets thrown if a [SingleCommitTransaction] has already been
/// committed.
class AlreadyComittedError extends StateError {
  /// Default constructor.
  AlreadyComittedError() : super('Transaction has already been committed');
}

/// Exception that gets thrown if the server rejects the transaction because
/// the eTag has been modified.
///
/// This is simply thrown in place of a
/// [DbException] to make transaction errors easier to detect.
class TransactionFailedException implements Exception {
  /// Default constructor
  const TransactionFailedException();

  @override
  String toString() => 'Transaction failed - '
      'Database entry was modified since the transaction was started.';
}

/// An interface for transactions on the realtime database
abstract class FirebaseTransaction<T> {
  /// The key of the entry beeing modified in the transaction
  String get key;

  /// The current value of the entry.
  ///
  /// If [value] is `null`, it means the entry does not exist yet.
  T? get value;

  /// The current eTag of the entry.
  ///
  /// Used internally to handle the transaction.
  String get eTag;

  /// Tries to commit an update of the entry to [data].
  ///
  /// If it has not been modified since the transaction was started, this will
  /// succeed and return the updated data. If it was modified, a
  /// [TransactionFailedException] will be thrown instead.
  Future<T?> commitUpdate(T data);

  /// Tries to commit the deletion of the entry.
  ///
  /// If it has not been modified since the transaction was started, this will
  /// succeedta. If it was modified, a [TransactionFailedException] will be
  /// thrown instead.
  Future<void> commitDelete();
}

/// A helper class to easily create single commit transaction.
///
/// Single commit transactions are transaction that can only be commit once
/// and become invalid after. This class helps in that it handels this case
/// and automatically throws a [AlreadyComittedError] if someone tries to commit
/// it twice.
///
/// Instead of [commitUpdate] and [commitDelete], you have to implement
/// [commitUpdateImpl] and [commitDeleteImpl]. They follow the same semantics
/// as their originals, beeing called by them after it was verified the
/// transaction was not committed yet.
abstract class SingleCommitTransaction<T> implements FirebaseTransaction<T> {
  bool _committed = false;

  /// See [commitUpdate]
  @protected
  Future<T?> commitUpdateImpl(T data);

  /// See [commitDelete]
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
