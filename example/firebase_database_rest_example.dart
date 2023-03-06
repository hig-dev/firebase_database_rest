// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';

import 'package:firebase_database_rest/firebase_database_rest.dart';
import 'package:http/http.dart';

class ExampleModel {
  final int id;
  final String data;

  const ExampleModel(this.id, this.data);

  @override
  bool operator ==(covariant ExampleModel other) => id == other.id && data == other.data;

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode ^ data.hashCode;

  @override
  String toString() => 'ExampleModel(id: $id, data: $data)';
}

// pass your firebase project id as first argument and the API key as second
Future<void> main(List<String> args) async {
  if (args.length != 2) {
    print('First argument must be the firebase project id.');
    print('Second argument must be the firebase API key.');
    exit(-1);
  }

  Client? client;
  FirebaseDatabase? database;
  StreamSubscription<StoreEvent<ExampleModel>>? sub;
  try {
    // use firebase_auth_rest to log into a firebase account
    client = Client();

    // create a database reference from that account
    database = FirebaseDatabase(
      client: client,
      database: args[0],
      basePath: 'firebase_database_rest/demo',
    );

    // create typed store. In this example, we use the database root path,
    // but it can also have a subpath
    // you should use json_serializable for json conversions in real projects
    final store = database.createRootStore<ExampleModel>(
      onDataFromJson: (dynamic json) => ExampleModel(
        json['id'] as int,
        json['data'] as String,
      ),
      onDataToJson: (data) => {
        'id': data.id,
        'data': data.data,
      },
      onPatchData: (_, __) => throw UnimplementedError(),
    );

    // get all keys -> initially empty
    print('Initial keys: ${await store.keys()}');

    // add some data
    await store.create(const ExampleModel(1, 'A'));
    await store.write('myId', const ExampleModel(2, 'B'));

    // get all data in store
    print('All data: ${await store.all()}');

    // query only some elements
    final filter = Filter.property<int>('id').equalTo(2).build();
    print('Only with id 2: ${await store.query(filter)}');

    // stream changes (edit, delete)
    sub = (await store.streamAll()).listen((e) => print('Stream update: $e'));
    await store.write('myId', const ExampleModel(3, 'C'));
    await store.delete('myId');
    await Future<void>.delayed(const Duration(seconds: 1));
    await sub.cancel();
    sub = null;

    // cleanup: delete database and account
    await database.rootStore.destroy();
  } finally {
    await sub?.cancel();
    await database?.dispose();
    client?.close();
  }
}
