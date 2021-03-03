// coverage:ignore-file
import '../../stream/server_sent_event.dart';

/// An exception that is thrown if the firebase server sents an unexpected SSE.
class UnknownStreamEventError extends Error {
  /// The event that has been received.
  final ServerSentEvent event;

  /// Default constructor.
  ///
  /// Created with the [event] that was received but not understood by this
  /// library.
  UnknownStreamEventError(this.event);

  @override
  String toString() => 'Received unknown server event: $event';
}
