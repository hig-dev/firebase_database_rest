import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeout.freezed.dart';

@freezed
abstract class Timeout implements _$Timeout {
  const Timeout._();

  const factory Timeout.ms(int duration) = _TimeoutMs;
  const factory Timeout.s(int duration) = _TimeoutS;
  const factory Timeout.min(int duration) = _TimeoutMin;

  String serialize() => when(
        ms: (duration) => "${duration}ms",
        s: (duration) => "${duration}s",
        min: (duration) => "${duration}min",
      );
}
