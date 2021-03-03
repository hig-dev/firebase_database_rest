# firebase_database_rest
[![Continous Integration](https://github.com/Skycoder42/firebase_database_rest/actions/workflows/ci.yaml/badge.svg)](https://github.com/Skycoder42/firebase_database_rest/actions/workflows/ci.yaml)
[![Pub Version](https://img.shields.io/pub/v/firebase_database_rest)](https://pub.dev/packages/firebase_database_rest)

A platform independent Dart/Flutter Wrapper for the Firebase Realtime Database API based on REST

## Features
- Pure Dart-based implementation
  - works on all platforms supported by dart
- Uses the official REST-API endpoints
- Provides high-level classes to manage database access
- Supports Model-Binding via Generics and converter functions
- Full support of all Realtime database features:
  - Supports CRUD
  - Supports Queries (filtering, sorting)
  - Supports realtime server updates (streaming)
  - Supports ETags
- Provides a Transaction class to wrap ETag-Logic into safe transactions
- Provides timestamp class for server set timestamps
- Proivides low-level REST classes for direct API access (import `firebase_database_rest/rest.dart`)
- Fully integrated with [firebase_auth_rest](https://github.com/Skycoder42/firebase_auth_rest) - including automatic auth token refreshes

## Installation
Simply add `firebase_database_rest` to your `pubspec.yaml` and run `pub get` (or `flutter pub get`).

## Usage
The libraries primary class is the `FirebaseStore`. It is a high-level class that allows access to a certain part of the realtime database using Model binding.
With this store, you specify a subpatch and can then perform various operations on elements below that path (list key, create, read, write or delete them, ...).
This class also provides the APIs for streaming changes and transactions. Typically, your application would use multiple stores, one for each dataclass you plan
to store at a certain path.

The second important class is the `FirebaseDatabase`. It serves as the toplevel class, parent to all stores and manages the database connection itself, including
the management of the associated `FirebaseAccount` (from [firebase_auth_rest](https://github.com/Skycoder42/firebase_auth_rest)) and background ressources 
(like the REST-API interface).

The following code is a simple example, which can be found in full length, including errorhandling, at https://pub.dev/packages/firebase_database_rest/example. It loggs into firebase as anonymous user, starts streaming changes and then does some db operations.

```.dart
// The data class that is stored in firebase
class ExampleModel {
  final int id;
  final String data;

  const ExampleModel(this.id, this.data);
  
  // ...
}

// obtain a firebase account, using firebase_auth_rest
final account = // ...

// create a database reference from that account
final database = FirebaseDatabase(
  account: account,
  database: 'my-firebase-project-id,
  basePath: 'application/${account.localId}/example',
);

// create typed store. In this example, a callback store is used, but you can
// also just extend FirebaseStore
final store = database.createRootStore<ExampleModel>(
  onDataFromJson: (dynamic json) => ExampleModel.fromJson(json),
  onDataToJson: (data) => data.toJson(),
  onPatchData: (data, updatedFields) => data.patch(updatedFields),
);

// add a stream listener that reports database changes in realtime
sub = (await store.streamAll()).listen((e) => print('Stream update: $e'));

// add some data to the store
await store.create(const ExampleModel(1, 'A'));

// get all data in store
print('All data: ${await store.all()}');

// cleanup: stop streaming and dispose of the database
await sub.cancel();
await database.dispose();
```

## Documentation
The documentation is available at https://pub.dev/documentation/firebase_database_rest/latest/. 
A full example can be found at https://pub.dev/packages/firebase_database_rest/example.
