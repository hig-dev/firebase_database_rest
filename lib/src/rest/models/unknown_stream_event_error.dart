// coverage:ignore-file
import '../../stream/server_sent_event.dart';

class UnknownStreamEventError extends Error {
  final ServerSentEvent event;

  UnknownStreamEventError(this.event);

  @override
  String toString() => 'Received unknown server event: $event';
}
