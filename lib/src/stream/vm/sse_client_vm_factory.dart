import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../sse_client.dart';
import 'sse_client_vm.dart';

/// @nodoc
@internal
abstract class SSEClientFactory {
  const SSEClientFactory._(); // coverage:ignore-line

  /// @nodoc
  static SSEClient create(Client client) => SSEClientVM(client);
}
