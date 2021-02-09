import 'dart:convert';

import 'package:http/http.dart';
import 'package:path/path.dart';

import 'models/api_constants.dart';
import 'models/db_exception.dart';
import 'models/db_response.dart';
import 'models/filter.dart';
import 'models/stream_event.dart';
import 'models/timeout.dart';
import 'stream/event_source.dart';

class RestApi {
  static const loggingTag = 'firebase_database_rest.RestApi';

  final Client client;
  final String database;
  final String basePath;

  String? idToken;
  Timeout? timeout;
  WriteSizeLimit? writeSizeLimit;

  RestApi({
    required this.client,
    required this.database,
    this.basePath = '',
    this.idToken,
    this.timeout,
    this.writeSizeLimit,
  });

  Future<DbResponse> get({
    String? path,
    PrintMode? printMode,
    FormatMode? formatMode,
    bool? shallow,
    Filter? filter,
    bool eTag = false,
  }) async {
    final response = await client.get(
      _buildUri(
        path: path,
        filter: filter,
        printMode: printMode,
        formatMode: formatMode,
        shallow: shallow,
      ),
      headers: _buildHeaders(
        eTag: eTag,
      ),
    );
    return _parseResponse(response, eTag);
  }

  Future<DbResponse> post(
    dynamic body, {
    String? path,
    PrintMode? printMode,
    bool eTag = false,
  }) async {
    final response = await client.post(
      _buildUri(
        path: path,
        printMode: printMode,
      ),
      body: json.encode(body),
      headers: _buildHeaders(
        hasBody: true,
        eTag: eTag,
      ),
    );
    return _parseResponse(response, eTag);
  }

  Future<DbResponse> put(
    dynamic body, {
    String? path,
    PrintMode? printMode,
    bool eTag = false,
    String? ifMatch,
  }) async {
    final response = await client.put(
      _buildUri(
        path: path,
        printMode: printMode,
      ),
      body: json.encode(body),
      headers: _buildHeaders(
        hasBody: true,
        eTag: eTag,
        ifMatch: ifMatch,
      ),
    );
    return _parseResponse(response, eTag);
  }

  Future<DbResponse> patch(
    Map<String, dynamic> updateChildren, {
    String? path,
    PrintMode? printMode,
  }) async {
    final response = await client.patch(
      _buildUri(
        path: path,
        printMode: printMode,
      ),
      body: json.encode(updateChildren),
      headers: _buildHeaders(
        hasBody: true,
      ),
    );
    return _parseResponse(response, false);
  }

  Future<DbResponse> delete({
    String? path,
    PrintMode? printMode,
    bool eTag = false,
    String? ifMatch,
  }) async {
    final response = await client.delete(
      _buildUri(
        path: path,
        printMode: printMode,
      ),
      headers: _buildHeaders(
        eTag: eTag,
        ifMatch: ifMatch,
      ),
    );
    return _parseResponse(response, eTag);
  }

  Future<Stream<StreamEvent>> stream({
    String? path,
    PrintMode? printMode,
    FormatMode? formatMode,
    bool? shallow,
    Filter? filter,
  }) async {
    final source = await client.stream(
      _buildUri(
        path: path,
        filter: filter,
        printMode: printMode,
        formatMode: formatMode,
        shallow: shallow,
      ),
      headers: _buildHeaders(),
    );
    return _transformEventStream(source);
  }

  Uri _buildUri({
    String? path,
    Filter? filter,
    PrintMode? printMode,
    FormatMode? formatMode,
    bool? shallow,
  }) {
    final uri = Uri(
      scheme: 'https',
      host: '$database.firebaseio.com',
      path: posix.normalize(
        path != null ? '$basePath/$path.json' : '$basePath.json',
      ),
      queryParameters: <String, dynamic>{
        if (idToken != null) 'auth': idToken!,
        if (timeout != null) 'timeout': timeout!.serialize(),
        if (writeSizeLimit != null) 'writeSizeLimit': writeSizeLimit!.value,
        if (printMode != null) 'print': printMode.value,
        if (formatMode != null) 'format': formatMode.value,
        if (shallow != null) 'shallow': shallow.toString(),
        ...?filter?.filters,
      },
    );
    return uri;
  }

  Map<String, String> _buildHeaders({
    bool hasBody = false,
    bool eTag = false,
    String? ifMatch,
    String? accept,
  }) {
    final headers = {
      'Accept': accept ?? 'application/json',
      if (hasBody) 'Content-Type': 'application/json',
      if (eTag) 'X-Firebase-ETag': 'true',
      if (ifMatch != null) 'if-match': ifMatch,
    };
    return headers;
  }

  DbResponse _parseResponse(
    Response response,
    bool eTag,
  ) {
    final tag = eTag ? response.headers['etag'] : null;
    if (response.statusCode >= 300) {
      throw DbException.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      ).copyWith(statusCode: response.statusCode);
    } else if (response.statusCode == 204) {
      return DbResponse(
        data: null,
        eTag: tag,
      );
    } else {
      return DbResponse(
        data: json.decode(response.body),
        eTag: tag,
      );
    }
  }

  Stream<StreamEvent> _transformEventStream(EventSource source) async* {
    await for (final event in source) {
      switch (event.event) {
        case 'put':
          yield StreamEventPut.fromJson(
            json.decode(event.data) as Map<String, dynamic>,
          );
          break;
        case 'patch':
          yield StreamEventPatch.fromJson(
            json.decode(event.data) as Map<String, dynamic>,
          );
          break;
        case 'keep-alive':
          break; // no-op
        case 'cancel':
          throw DbException(error: event.data);
        case 'auth_revoked':
          yield const StreamEvent.authRevoked();
          break;
        default:
          yield StreamEvent.unknown(
            event: event.event,
            data: event.data,
          );
          break;
      }
    }
  }
}
