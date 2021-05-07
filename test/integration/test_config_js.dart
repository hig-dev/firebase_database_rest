part 'test_config_js.env.dart';

abstract class TestConfig {
  const TestConfig._();

  static String get projectId => _firebaseProjectId;
  static String get apiKey => _firebaseApiKey;

  static int get allTestLimit => int.tryParse(_allTestLimit) ?? 5;
}
