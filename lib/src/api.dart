import 'dart:convert';

import 'package:eventsource/eventsource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

import 'filter.dart';
import 'models/db_error.dart';
import 'models/db_response.dart';
import 'models/stream_event.dart';
import 'models/timeout.dart';

enum PrintMode {
  normal,
  pretty,
  silent,
}

enum WriteSizeLimit {
  tiny,
  small,
  medium,
  large,
  unlimited,
}

class FirebaseRealtimeDatabaseApi {
  static const dynamic serverTimeStamp = {".sv": "timestamp"};

  final Client _client;
  final String _database;
  final Logger _logger;
  final List<String> _path;
  final String _idToken;
  final Timeout _timeout;
  final WriteSizeLimit _writeSizeLimit;

  FirebaseRealtimeDatabaseApi({
    @required Client client,
    @required String database,
    @required Logger logger,
    String idToken,
    List<String> path = const <String>[],
    Timeout timeout = const Timeout.min(15),
    WriteSizeLimit writeSizeLimit = WriteSizeLimit.unlimited,
  })  : _client = client,
        _database = database,
        _logger = logger,
        _idToken = idToken,
        _path = path,
        _timeout = timeout,
        _writeSizeLimit = writeSizeLimit;

  Future<DbResponse> get({
    List<String> path,
    PrintMode mode = PrintMode.normal,
    bool shallow = false,
    Filter filter,
    bool eTag = false,
  }) async {
    _logger.fine("Sending get request...");
    final response = await _client.get(
      _buildUri(
        path,
        filter: filter,
        mode: mode,
        shallow: shallow,
      ),
      headers: _buildHeaders(
        eTag: eTag,
      ),
    );
    return _parseResponse(response, eTag);
  }

  Future<DbResponse> post(
    Map<String, dynamic> body, {
    List<String> path,
    PrintMode mode = PrintMode.normal,
    bool eTag = false,
  }) async {
    _logger.fine("Sending post request...");
    final response = await _client.post(
      _buildUri(
        path,
        mode: mode,
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
    Map<String, dynamic> body, {
    List<String> path,
    PrintMode mode = PrintMode.normal,
    bool eTag = false,
    String ifMatch,
  }) async {
    _logger.fine("Sending put request...");
    final response = await _client.put(
      _buildUri(
        path,
        mode: mode,
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

  Future<DbResponse> delete({
    List<String> path,
    PrintMode mode = PrintMode.normal,
    bool eTag = false,
    String ifMatch,
  }) async {
    _logger.fine("Sending delete request...");
    final response = await _client.delete(
      _buildUri(
        path,
        mode: mode,
      ),
      headers: _buildHeaders(
        eTag: eTag,
        ifMatch: ifMatch,
      ),
    );
    return _parseResponse(response, eTag);
  }

  Stream<StreamEvent> stream({
    List<String> path,
    PrintMode mode = PrintMode.normal,
    bool shallow = false,
    Filter filter,
  }) async* {
    _logger.fine("Sending stream request...");
    final source = await EventSource.connect(
      _buildUri(
        path,
        filter: filter,
        mode: mode,
        shallow: shallow,
      ),
      headers: _buildHeaders(
        accept: "text/event-stream",
      ),
      client: _client,
    );

    await for (final event in source) {
      _logger.fine("Received event of type: ${event.event}");
      switch (event.event) {
        case "put":
          yield StreamEventPut.fromJson(
              json.decode(event.data) as Map<String, dynamic>);
          break;
        case "patch":
          yield StreamEventPatch.fromJson(
              json.decode(event.data) as Map<String, dynamic>);
          break;
        case "keep-alive":
          break; // no-op
        case "cancel":
          throw DbError(error: event.data);
        case "auth_revoked":
          yield const StreamEvent.authRevoked();
          break;
      }
    }
  }

  Uri _buildUri(
    List<String> path, {
    Filter filter,
    PrintMode mode,
    bool shallow,
  }) {
    final fullPath = _path + path;
    if (fullPath.isEmpty) {
      throw null;
    }
    fullPath.last += ".json";

    final uri = Uri(
      scheme: "https",
      host: "$_database.firebaseio.com",
      pathSegments: fullPath,
      queryParameters: <String, dynamic>{
        if (_idToken != null) "auth": _idToken,
        "timeout": _timeout.serialize(),
        "writeSizeLimit": _writeSizeLimit.toString(),
        if (mode != PrintMode.normal) "print": mode.toString(),
        if (shallow != null) "shallow": shallow.toString(),
        ...?filter?.query(),
      },
    );
    _logger.fine("Building request URI as: ${uri.toString()}");
    return uri;
  }

  Map<String, String> _buildHeaders({
    bool hasBody = false,
    bool eTag = false,
    String ifMatch,
    String accept,
  }) {
    final headers = {
      "Accept": accept ?? "application/json",
      if (hasBody) "Content-Type": "application/json",
      if (eTag) "X-Firebase-ETag": "true",
      if (ifMatch != null) "if-match": ifMatch,
    };
    _logger.fine("Building request headers as: ${headers.toString()}");
    return headers;
  }

  DbResponse _parseResponse(
    Response response,
    bool eTag,
  ) {
    final tag = eTag ? response.headers["ETag"] : null;
    if (response.statusCode >= 300) {
      throw DbError.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    } else if (response.statusCode == 204) {
      return DbResponse(
        data: null,
        eTag: tag,
      );
    } else {
      return DbResponse(
        data: json.decode(response.body) as Map<String, dynamic>,
        eTag: tag,
      );
    }
  }
}
