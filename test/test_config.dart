import 'dart:io';

abstract class TestConfig {
  const TestConfig._();

  static String get projectId => Platform.environment['FIREBASE_PROJECT_ID']!;
  static String get apiKey => Platform.environment['FIREBASE_API_KEY']!;

  static int get allTestLimit =>
      int.tryParse(Platform.environment['FIREBASE_ALL_TEST_LIMIT'] ?? '') ?? 5;
}
