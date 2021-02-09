// ignore_for_file: avoid_print
import 'package:firebase_auth_rest/firebase_auth_rest.dart';
import 'package:firebase_database_rest/src/rest/rest_api.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

import '../firebase_test_config.dart';

void main() {
  late Client client;
  late FirebaseAccount account;

  var caseCtr = 0;
  late RestApi sut;

  setUpAll(() async {
    client = Client();
    final auth = FirebaseAuth(client, firebaseConfig.apiKey);
    account = await auth.signUpAnonymous(autoRefresh: false);
  });

  tearDownAll(() async {
    await account.delete();
    client.close();
  });

  setUp(() {
    sut = RestApi(
      client: client,
      database: firebaseConfig.projectId,
      basePath:
          'firebase_database_rest/${account.localId}/_test_path_${caseCtr++}',
      idToken: account.idToken,
    );
  });

  tearDown(() async {
    await sut.delete();
  });

  test('setup and teardown work as expected', () async {
    final stream = await sut.stream(shallow: true);

    final sub = stream.listen((event) => print(event));

    try {
      await Future<void>.delayed(const Duration(seconds: 3));

      print(await sut.put(42, path: 'live', eTag: true));
      await Future<void>.delayed(const Duration(seconds: 3));
      print(await sut.put(
        {
          'begin': 42,
          'end': {
            'a': 'yes',
            'b': [1.0, 1.4, 1.8],
          },
        },
        path: 'death',
        eTag: true,
      ));
      await Future<void>.delayed(const Duration(seconds: 3));
      print(await sut.delete(path: 'death', eTag: true));
      await Future<void>.delayed(const Duration(seconds: 3));
      print('before');
    } finally {
      print('pre');
      await sub.cancel();
      print('post');
    }
  });
}
