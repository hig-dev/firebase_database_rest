import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeout.freezed.dart';

@freezed
abstract class Timeout implements _$Timeout {
  const Timeout._();

  @Assert('value >= 0')
  @Assert('value <= 900000')
  const factory Timeout.ms(int value) = _TimeoutMs;
  @Assert('value >= 0')
  @Assert('value <= 900')
  const factory Timeout.s(int value) = _TimeoutS;
  @Assert('value >= 0')
  @Assert('value <= 15')
  const factory Timeout.min(int value) = _TimeoutMin;

  factory Timeout.fromDuration(Duration duration) {
    if (duration.inMilliseconds % 1000 != 0) {
      return Timeout.ms(duration.inMilliseconds);
    } else if (duration.inSeconds % 60 != 0) {
      return Timeout.s(duration.inSeconds);
    } else {
      return Timeout.min(duration.inMinutes);
    }
  }

  Duration get duration => when(
        ms: (value) => Duration(milliseconds: value),
        s: (value) => Duration(seconds: value),
        min: (value) => Duration(minutes: value),
      );

  String serialize() => when(
        ms: (value) => '${value}ms',
        s: (value) => '${value}s',
        min: (value) => '${value}min',
      );
}
