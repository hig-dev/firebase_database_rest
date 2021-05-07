import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../sse_client.dart';
import 'sse_client_js.dart';

/// @nodoc
@internal
abstract class SSEClientFactory {
  const SSEClientFactory._();

  /// @nodoc
  static SSEClient create(Client client) => SSEClientJS(client);
}
