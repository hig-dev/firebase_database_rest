import 'dart:convert';

import 'package:http/http.dart';
import 'package:path/path.dart';

import '../common/api_constants.dart';
import '../common/db_exception.dart';
import '../common/filter.dart';
import '../common/timeout.dart';
import '../stream/sse_client.dart';
import 'models/db_response.dart';
import 'models/stream_event.dart';
import 'stream_event_transformer.dart';

/// A class to communicated with the firebase realtime database REST-API
///
/// Many methods of this class accept an `eTag` parameter. The Firebase ETag is
/// the unique identifier for the current data at a specified location. If the
/// data changes at that location, the ETag changes, too. If set, the class
/// will request this eTag and return in via [DbResponse.eTag].
class RestApi {
  /// The host url of the database, the default is 'firebaseio.com'.
  /// Set this if you are using a custom region like 'europe-west1.firebasedatabase.app'.
  final String host;

  /// The HTTP-Client that should be used to send requests.
  final SSEClient client;

  /// The name of the database to connect to.
  final String database;

  /// A sub path in the database to use as virtual root path.
  final String basePath;

  /// The idToken to use for requests.
  ///
  /// If set to null, all requests will be unauthenticated. If set, all requests
  /// will add the auth parameter and thus be authenticated.
  String? idToken;

  /// The timeout for read requests. See [Timeout].
  Timeout? timeout;

  /// The limit for how big write requests can be. See [WriteSizeLimit].
  WriteSizeLimit? writeSizeLimit;

  /// Default constructor.
  ///
  /// If [client] is as [SSEClient], it is directly used as [this.client].
  /// Otherwise, [SSEClient.proxy] is used to create a [SSEClient] from the
  /// given simple [Client].
  RestApi({
    required Client client,
    required this.database,
    this.host = 'firebaseio.com',
    this.basePath = '',
    this.idToken,
    this.timeout,
    this.writeSizeLimit,
  }) : client = client is SSEClient ? client : SSEClient.proxy(client);

  /// Sends a get requests to the database to read some data.
  ///
  /// Tries to read the data at [path], or the whole virtual root, if not set.
  /// The [printMode] and [formatMode] can be used to control how data is
  /// formatted by the server.
  ///
  /// The [shallow] parameter can be used to help you work with large datasets
  /// without needing to download everything. Set this to true to limit the
  /// depth of the data returned at a location. If the data at the location is
  /// a JSON primitive (string, number or boolean), its value will simply be
  /// returned. If the data snapshot at the location is a JSON object, the
  /// values for each key will be truncated to true.
  ///
  /// If [filter] is added, that filter will be applied to filter the results
  /// returned by the server. See [Filter] for more details.
  ///
  /// Finally, the [eTag] parameter can be set to true to request an eTag for
  /// the given data.
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

  /// Sends a post requests to the database to create new data.
  ///
  /// Tries to create a new child entry at [path], or the whole virtual root,
  /// if not set. The target location must be an object or array for this to
  /// work. If posting to an array, the [body] is simply appended. For objects,
  /// a new random key is generated and the [body] added to the object under
  /// that key. In either cases, the returned result contains the id of the
  /// newly created entry.
  ///
  /// The [printMode] can be used to control how data is formatted by the
  /// server.
  ///
  /// Finally, the [eTag] parameter can be set to true to request an eTag for
  /// the given data.
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

  /// Sends a put requests to the database to write some data.
  ///
  /// Tries to write the [body] to [path], or to the virtual root, if not set.
  /// The [printMode] can be used to control how data is formatted by the
  /// server.
  ///
  /// Finally, the [eTag] parameter can be set to true to request an eTag for
  /// the given data. If you only want to be able to write data if it was not
  /// changed, pass a previously acquired eTag as [ifMatch]. In case the eTag
  /// does not match, the request will fail with the
  /// [ApiConstants.statusCodeETagMismatch] status code. To only write data that
  /// does not exist yet, use [ApiConstants.nullETag] as value for [ifMatch].
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

  /// Sends a patch requests to the database to update some data.
  ///
  /// Tries to update the given fields of [updateChildren] to their new values
  /// at [path], or to the virtual root, if not set. Only fields explicitly
  /// specified are updated, all other fields are not modified. To delete a
  /// field, set the update value to `null`.
  ///
  /// The [printMode] can be used to control how data is formatted by the
  /// server.
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

  /// Sends a delete requests to the database to delete some data.
  ///
  /// Tries to delete the data at [path], or the whole virtual root, if not set.
  /// The [printMode] can be used to control how data is formatted by the
  /// server.
  ///
  /// Finally, the [eTag] parameter can be set to true to request an eTag for
  /// the given data. The resulting eTag should always be
  /// [ApiConstants.nullETag]. If you only want to be able to delete data if it
  /// was not changed, pass a previously acquired eTag as [ifMatch]. In case
  /// the eTag does not match, the request will fail with the
  /// [ApiConstants.statusCodeETagMismatch] status code.
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

  /// Sends a get requests to the database to stream changes.
  ///
  /// Tries to stream the data at [path], or the whole virtual root, if not set.
  /// The [printMode] and [formatMode] can be used to control how data is
  /// formatted by the server.
  ///
  /// The resulting future will stream various [StreamEvent]s, which provide
  /// realtime information about how data is changed in the database. Please
  /// note that the first element of every stream will be a [StreamEvent.put]
  /// with the current state of the database at [path]. All events after that
  /// are fired as data is manipulated in the database.
  ///
  /// The [shallow] parameter can be used to help you work with large datasets
  /// without needing to download everything. Set this to true to limit the
  /// depth of the data returned at a location. If the data at the location is
  /// a JSON primitive (string, number or boolean), its value will simply be
  /// returned. If the data snapshot at the location is a JSON object, the
  /// values for each key will be truncated to true.
  ///
  /// If [filter] is added, that filter will be applied to filter the results
  /// returned by the server. See [Filter] for more details.
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
    );
    for (final eventType in StreamEventTransformer.eventTypes) {
      source.addEventType(eventType);
    }
    return source.transform(const StreamEventTransformer());
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
      host: '$database.$host',
      path: posix.normalize(
        path != null ? '$basePath/$path.json' : '$basePath.json',
      ),
      queryParameters: <String, dynamic>{
        if (idToken != null) 'auth': idToken!,
        if (timeout != null) 'timeout': timeout!.toString(),
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
    if (response.statusCode == ApiConstants.statusCodeETagMismatch) {
      throw const DbException(statusCode: ApiConstants.statusCodeETagMismatch);
    } else if (response.statusCode >= 300) {
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
}
