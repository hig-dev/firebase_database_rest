import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_database_rest/src/stream/sse_client_factory.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'sse_client_test_fallback.dart'
    if (dart.library.io) 'vm/sse_client_test_vm.dart'
    if (dart.library.html) 'js/sse_client_test_js.dart';

class MockClient extends Mock implements Client {}

class FakeRequest extends Fake implements Request {}

class FakeResponse extends Fake implements Response {}

class FakeStreamedResponse extends Fake implements StreamedResponse {}

class SutClientProxy with ClientProxy implements Client {
  @override
  final Client client;

  SutClientProxy(this.client);
}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue<Request>(FakeRequest());
  });

  test('fallback factory throws exception', () {
    expect(
      () => SSEClientFactory.create(MockClient()),
      throwsA(isA<UnimplementedError>()),
    );
  });

  setupTests();

  group('ClientProxy', () {
    final mockClient = MockClient();

    late ClientProxy sut;

    setUp(() {
      reset(mockClient);

      sut = SutClientProxy(mockClient);
    });

    test('close proxies to close', () {
      sut.close();

      verify(() => mockClient.close());
    });

    test('delete proxies to delete', () async {
      final response = FakeResponse();
      final url = Uri.http('localhost', '/');
      const headers = <String, String>{
        'A': 'B',
      };
      const body = 'body';

      when(() => mockClient.delete(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          )).thenAnswer((i) async => response);

      final res = await sut.delete(
        url,
        headers: headers,
        body: body,
        encoding: utf8,
      );

      expect(res, response);
      verify(
        () => mockClient.delete(
          url,
          headers: headers,
          body: body,
          encoding: utf8,
        ),
      );
    });

    test('get proxies to get', () async {
      final response = FakeResponse();
      final url = Uri.http('localhost', '/');
      const headers = <String, String>{
        'A': 'B',
      };

      when(() => mockClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((i) async => response);

      final res = await sut.get(
        url,
        headers: headers,
      );

      expect(res, response);
      verify(
        () => mockClient.get(
          url,
          headers: headers,
        ),
      );
    });

    test('head proxies to head', () async {
      final response = FakeResponse();
      final url = Uri.http('localhost', '/');
      const headers = <String, String>{
        'A': 'B',
      };

      when(() => mockClient.head(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((i) async => response);

      final res = await sut.head(
        url,
        headers: headers,
      );

      expect(res, response);
      verify(
        () => mockClient.head(
          url,
          headers: headers,
        ),
      );
    });

    test('patch proxies to patch', () async {
      final response = FakeResponse();
      final url = Uri.http('localhost', '/');
      const headers = <String, String>{
        'A': 'B',
      };
      const body = 'body';

      when(() => mockClient.patch(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          )).thenAnswer((i) async => response);

      final res = await sut.patch(
        url,
        headers: headers,
        body: body,
        encoding: utf8,
      );

      expect(res, response);
      verify(
        () => mockClient.patch(
          url,
          headers: headers,
          body: body,
          encoding: utf8,
        ),
      );
    });

    test('post proxies to post', () async {
      final response = FakeResponse();
      final url = Uri.http('localhost', '/');
      const headers = <String, String>{
        'A': 'B',
      };
      const body = 'body';

      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          )).thenAnswer((i) async => response);

      final res = await sut.post(
        url,
        headers: headers,
        body: body,
        encoding: utf8,
      );

      expect(res, response);
      verify(
        () => mockClient.post(
          url,
          headers: headers,
          body: body,
          encoding: utf8,
        ),
      );
    });

    test('put proxies to put', () async {
      final response = FakeResponse();
      final url = Uri.http('localhost', '/');
      const headers = <String, String>{
        'A': 'B',
      };
      const body = 'body';

      when(() => mockClient.put(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            encoding: any(named: 'encoding'),
          )).thenAnswer((i) async => response);

      final res = await sut.put(
        url,
        headers: headers,
        body: body,
        encoding: utf8,
      );

      expect(res, response);
      verify(
        () => mockClient.put(
          url,
          headers: headers,
          body: body,
          encoding: utf8,
        ),
      );
    });

    test('read proxies to read', () async {
      const response = 'response';
      final url = Uri.http('localhost', '/');
      const headers = <String, String>{
        'A': 'B',
      };

      when(() => mockClient.read(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((i) async => response);

      final res = await sut.read(
        url,
        headers: headers,
      );

      expect(res, response);
      verify(
        () => mockClient.read(
          url,
          headers: headers,
        ),
      );
    });

    test('readBytes proxies to readBytes', () async {
      final response = Uint8List(10);
      final url = Uri.http('localhost', '/');
      const headers = <String, String>{
        'A': 'B',
      };

      when(() => mockClient.readBytes(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((i) async => response);

      final res = await sut.readBytes(
        url,
        headers: headers,
      );

      expect(res, response);
      verify(
        () => mockClient.readBytes(
          url,
          headers: headers,
        ),
      );
    });

    test('send proxies to send', () async {
      final response = FakeStreamedResponse();
      final request = FakeRequest();

      when(() => mockClient.send(any())).thenAnswer((i) async => response);

      final res = await sut.send(request);

      expect(res, response);
      verify(() => mockClient.send(request));
    });
  });
}
