import 'dart:async';

import 'server_sent_event.dart';

class EventStreamDecoder implements StreamTransformer<String, ServerSentEvent> {
  const EventStreamDecoder();

  @override
  Stream<ServerSentEvent> bind(Stream<String> stream) async* {
    String eventType;
    String lastEventId;
    final data = <String>[];
    await for (final line in stream) {
      if (line.isEmpty) {
        if (data.isNotEmpty) {
          yield ServerSentEvent(
            event: eventType ?? "message",
            data: data.join("\n"),
            lastEventId: lastEventId,
          );
        }
        eventType = null;
        data.clear();
      } else if (line.startsWith(":")) {
        continue;
      } else {
        final colonIndex = line.indexOf(":");
        var field = "";
        var value = "";
        if (colonIndex != -1) {
          field = line.substring(0, colonIndex);
          value = line.substring(colonIndex + 1);
          if (value.startsWith(" ")) {
            value = value.substring(1);
          }
        } else {
          field = line;
        }
        switch (field) {
          case "event":
            eventType = value.isNotEmpty ? value : null;
            break;
          case "data":
            data.add(value);
            break;
          case "id":
            lastEventId = value.isNotEmpty ? value : null;
            break;
          // case "retry":  Not implemented
          default:
            break;
        }
      }
    }

    if (data.isNotEmpty) {
      yield ServerSentEvent(
        event: eventType ?? "message",
        data: data.join("\n"),
        lastEventId: lastEventId,
      );
    }
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() =>
      StreamTransformer.castFrom<String, ServerSentEvent, RS, RT>(this);
}
