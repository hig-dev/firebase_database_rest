import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_config.freezed.dart';
part 'firebase_config.g.dart';

@freezed
abstract class FirebaseConfig with _$FirebaseConfig {
  const factory FirebaseConfig({
    required String apiKey,
    required String authDomain,
    required String databaseURL,
    required String projectId,
    required String storageBucket,
    required String messagingSenderId,
    required String appId,
  }) = _FirebaseConfig;

  factory FirebaseConfig.fromJson(Map<String, dynamic> json) =>
      _$FirebaseConfigFromJson(json);
}
