import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';

import 'filter.dart';
import 'models/db_exception.dart';
import 'models/db_response.dart';
import 'models/stream_event.dart';
import 'models/timeout.dart';
import 'stream/event_source.dart';

enum PrintMode {
  pretty,
  silent,
}

extension PrintModeX on PrintMode {
  String get value {
    switch (this) {
      case PrintMode.pretty:
        return 'pretty';
      case PrintMode.silent:
        return 'silent';
      default:
        return null;
    }
  }
}

enum FormatMode {
  export,
}

extension FormatModeX on FormatMode {
  String get value {
    switch (this) {
      case FormatMode.export:
        return 'export';
      default:
        return null;
    }
  }
}

enum WriteSizeLimit {
  tiny,
  small,
  medium,
  large,
  unlimited,
}

extension WriteSizeLimitX on WriteSizeLimit {
  String get value {
    switch (this) {
      case WriteSizeLimit.tiny:
        return 'tiny';
      case WriteSizeLimit.small:
        return 'small';
      case WriteSizeLimit.medium:
        return 'medium';
      case WriteSizeLimit.large:
        return 'large';
      case WriteSizeLimit.unlimited:
        return 'unlimited';
      default:
        return null;
    }
  }
}

class RestApi {
  static const loggingTag = 'firebase_database_rest.RestApi';

  static const serverTimeStamp = {'.sv': 'timestamp'};
  static const statusCodeETagMismatch = 412;

  final Logger _logger;

  final Client client;
  final String database;
  final String basePath;

  String idToken;
  Timeout timeout;
  WriteSizeLimit writeSizeLimit;

  RestApi({
    @required this.client,
    @required this.database,
    this.basePath = '',
    this.idToken,
    this.timeout,
    this.writeSizeLimit,
    String loggingCategory = loggingTag,
  }) : _logger = loggingCategory != null ? Logger(loggingCategory) : null;

  Future<DbResponse> get({
    String path,
    PrintMode printMode,
    FormatMode formatMode,
    bool shallow,
    Filter filter,
    bool eTag = false,
  }) async {
    _logger?.fine('Sending get request...');
    final response = await client.get(
      _buildUri(
        path,
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
    String path,
    PrintMode printMode,
    bool eTag = false,
  }) async {
    _logger?.fine('Sending post request...');
    final response = await client.post(
      _buildUri(
        path,
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
    String path,
    PrintMode printMode,
    bool eTag = false,
    String ifMatch,
  }) async {
    _logger?.fine('Sending put request...');
    final response = await client.put(
      _buildUri(
        path,
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
    String path,
    PrintMode printMode,
  }) async {
    _logger?.fine('Sending patch request...');
    final response = await client.patch(
      _buildUri(
        path,
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
    String path,
    PrintMode printMode,
    bool eTag = false,
    String ifMatch,
  }) async {
    _logger?.fine('Sending delete request...');
    final response = await client.delete(
      _buildUri(
        path,
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
    String path,
    PrintMode printMode,
    FormatMode formatMode,
    bool shallow,
    Filter filter,
  }) async {
    _logger?.fine('Sending stream request...');
    final source = await client.stream(
      _buildUri(
        path,
        filter: filter,
        printMode: printMode,
        formatMode: formatMode,
        shallow: shallow,
      ),
      headers: _buildHeaders(eTag: true),
    );
    return _transformEventStream(source);
  }

  Uri _buildUri(
    String path, {
    Filter filter,
    PrintMode printMode,
    FormatMode formatMode,
    bool shallow,
  }) {
    final uri = Uri(
      scheme: 'https',
      host: '$database.firebaseio.com',
      path: posix.normalize(
        path != null ? '$basePath/$path.json' : '$basePath.json',
      ),
      queryParameters: <String, dynamic>{
        if (idToken != null) 'auth': idToken,
        if (timeout != null) 'timeout': timeout.serialize(),
        if (writeSizeLimit != null) 'writeSizeLimit': writeSizeLimit.value,
        if (printMode != null) 'print': printMode.value,
        if (formatMode != null) 'format': formatMode.value,
        if (shallow != null) 'shallow': shallow.toString(),
        ...?filter?.filters,
      },
    );
    _logger?.finer('> Building request URI as: ${uri.toString()}');
    return uri;
  }

  Map<String, String> _buildHeaders({
    bool hasBody = false,
    bool eTag = false,
    String ifMatch,
    String accept,
  }) {
    final headers = {
      'Accept': accept ?? 'application/json',
      if (hasBody) 'Content-Type': 'application/json',
      if (eTag) 'X-Firebase-ETag': 'true',
      if (ifMatch != null) 'if-match': ifMatch,
    };
    _logger?.finer('> Building request headers as: ${headers.toString()}');
    return headers;
  }

  DbResponse _parseResponse(
    Response response,
    bool eTag,
  ) {
    final tag = eTag ? response.headers['ETag'] : null;
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
      _logger?.fine('Received event of type: ${event.event}');
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
          _logger?.warning('Ignoring unsupported stream event: ${event.event}');
          break;
      }
    }
  }
}
