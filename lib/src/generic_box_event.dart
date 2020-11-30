import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'generic_box_event.freezed.dart';

@freezed
abstract class GenericBoxEvent<TKey, TValue> extends BoxEvent
    with _$GenericBoxEvent<TKey, TValue> {
  const factory GenericBoxEvent({
    @required TKey key,
    @required @nullable TValue value,
    @required bool deleted,
  }) = _GenericBoxEvent;
}
