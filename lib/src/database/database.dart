import 'dart:async';

import 'package:firebase_auth_rest/firebase_auth_rest.dart';
import 'package:http/http.dart';

import '../common/api_constants.dart';
import '../common/timeout.dart';
import '../rest/rest_api.dart';
import '../stream/sse_client.dart';
import 'store.dart';

/// The root database that manages access to the firebase realtime database.
///
/// This class manages the [account] and [api], which are used by all substores
/// created from this database. While the database itself does not provide
/// much functionality, it serves as an entry point to access the server
/// database and to create [FirebaseStore]s from.
class FirebaseDatabase {
  StreamSubscription<String>? _idTokenSub;

  /// An optional account used by the database.
  ///
  /// If used, the database will automatically listen to
  /// [FirebaseAccount.idTokenStream] to automatically update the
  /// [RestApi.idToken], making it easier to use the database.
  final FirebaseAccount? account;

  /// The api beeing used to communicate with the firebase servers.
  final RestApi api;

  /// An untyped root store, representing the virtual root used by the database.
  final FirebaseStore<dynamic> rootStore;

  /// Constructs a database for an authenticated user.
  ///
  /// This constructor needs an [account] and a [database]. The [account] is the
  /// user account used to authenticate to the API, the [database] is the name
  /// of the database to connect to. If you want to connec to a database without
  /// a user, use [FirebaseDatabase.unauthenticated] instead.
  ///
  /// The database will reuse the [Client] of the [FirebaseAccount.api], unless
  /// [client] is explicitly specified. Either one is used to create the [api].
  /// If the explicit client is a [SSEClient], that one is used for the API.
  /// Otherwise a wrapper is created around [client] to provide the SSE
  /// features.
  ///
  /// By default, the database will connect to the root path of the server
  /// database. If you want to connect to a subset of the database, use
  /// [basePath] to only connect to that part. This path will also be the path
  /// of the [rootStore].
  ///
  /// In addition, you can use [timeout] and [writeSizeLimit] to configure the
  /// corresponding values of the newly created [RestApi].
  FirebaseDatabase({
    required FirebaseAccount account,
    required String database,
    String basePath = '',
    Timeout? timeout,
    WriteSizeLimit? writeSizeLimit,
    Client? client,
  }) : this.api(
          RestApi(
            client: client ?? account.api.client,
            database: database,
            basePath: basePath,
            idToken: account.idToken,
            timeout: timeout,
            writeSizeLimit: writeSizeLimit,
          ),
          account: account,
        );

  /// Constructs a database without a user
  ///
  /// This constructor needs a [database], the name of the database to connect
  /// to. If you want to connect to a database with an authenticated user, use
  /// [FirebaseDatabase()] instead.
  ///
  /// The [client] is required here and used to create the [api]. If the
  /// explicit client is a [SSEClient], that one is used for the API. Otherwise
  /// a wrapper is created around [client] to provide the SSE features.
  ///
  /// By default, the database will connect to the root path of the server
  /// database. If you want to connect to a subset of the database, use
  /// [basePath] to only connect to that part. This path will also be the path
  /// of the [rootStore].
  ///
  /// In addition, you can use [timeout] and [writeSizeLimit] to configure the
  /// corresponding values of the newly created [RestApi].
  FirebaseDatabase.unauthenticated({
    required Client client,
    required String database,
    String basePath = '',
    Timeout? timeout,
    WriteSizeLimit? writeSizeLimit,
  }) : this.api(
          RestApi(
            client: client,
            database: database,
            basePath: basePath,
            timeout: timeout,
            writeSizeLimit: writeSizeLimit,
          ),
        );

  /// Constructs a rawdatabase from the raw api
  ///
  /// This constructor creates a database that directly uses a previously
  /// created [api]. The database to connect to and other parameters must be
  /// directly configured when created the [RestApi].
  ///
  /// By default, you have to manually set authentication on the API. However,
  /// if you want the [RestApi.idToken] to be automatically updated when an
  /// account is updated, you can optionally pass a [account] to this
  /// constructor. In that case, the database connects to the
  /// [FirebaseAccount.idTokenStream] and streams idToken updates to the [api].
  ///
  /// **Note:** Typically, you would use one of the other constructors to create
  /// the database. Only use this constructor if you can't use the others.
  FirebaseDatabase.api(
    this.api, {
    this.account,
  }) : rootStore = FirebaseStore<dynamic>.apiCreate(
          restApi: api,
          subPaths: [],
          onDataFromJson: (dynamic json) => json,
          onDataToJson: (dynamic data) => data,
          onPatchData: (dynamic data, updatedFields) =>
              (data as Map<String, dynamic>)..addAll(updatedFields),
        ) {
    if (account != null) {
      _idTokenSub = account!.idTokenStream.listen(
        (idToken) => api.idToken = idToken,
        cancelOnError: false,
      );
    }
  }

  /// Disposes of the database.
  ///
  /// This internally canceles any subscriptions to the accounts idTokenStream,
  /// if active.
  Future<void> dispose() async {
    await _idTokenSub?.cancel();
  }

  /// Creates a typed variant of the [rootStore].
  ///
  /// Returns a store which is scoped to the database, just like the
  /// [rootStore], but with converter callbacks to make it typed to [T].
  ///
  /// Iternally uses [FirebaseStore.apiCreate] with [onDataFromJson],
  /// [onDataToJson] and [onPatchData] to create the store.
  FirebaseStore<T> createRootStore<T>({
    required DataFromJsonCallback<T> onDataFromJson,
    required DataToJsonCallback<T> onDataToJson,
    required PatchDataCallback<T> onPatchData,
  }) =>
      FirebaseStore.apiCreate(
        restApi: api,
        subPaths: [],
        onDataFromJson: onDataFromJson,
        onDataToJson: onDataToJson,
        onPatchData: onPatchData,
      );
}
