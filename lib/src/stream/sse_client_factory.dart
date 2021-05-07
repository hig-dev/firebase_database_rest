import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import 'sse_client.dart';

/// @nodoc
@internal
abstract class SSEClientFactory {
  const SSEClientFactory._(); // coverage:ignore-line

  /// @nodoc
  static SSEClient create(Client _client) => throw UnimplementedError(
        'There is no default implementation of the SSEClient for this platform',
      );
}

/// @nodoc
@internal
mixin ClientProxy implements Client {
  /// @nodoc
  @visibleForOverriding
  Client get client;

  @override
  void close() => client.close();

  @override
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      client.delete(
        url,
        headers: headers,
        body: body,
        encoding: encoding,
      );

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) =>
      client.get(url, headers: headers);

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      client.head(url, headers: headers);

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      client.patch(
        url,
        headers: headers,
        body: body,
        encoding: encoding,
      );

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      client.post(
        url,
        headers: headers,
        body: body,
        encoding: encoding,
      );

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      client.put(
        url,
        headers: headers,
        body: body,
        encoding: encoding,
      );

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) =>
      client.read(url, headers: headers);

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) =>
      client.readBytes(url, headers: headers);

  @override
  Future<StreamedResponse> send(BaseRequest request) => client.send(request);
}
