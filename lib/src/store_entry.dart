import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import 'rest_api.dart';

part 'store_entry.freezed.dart';
part 'store_entry.g.dart';

@freezed
abstract class StoreEntry<T> with _$StoreEntry<T> {
  @HiveType(typeId: 223, adapterName: '_StoreEntryAdapterRaw')
  const factory StoreEntry({
    @required @nullable @HiveField(0) T value,
    @Default(RestApi.nullETag) @HiveField(1) String eTag,
    @Default(false) @HiveField(2) bool modified,
  }) = _StoreEntry;

  static TypeAdapter<dynamic> createAdapter<T>(int typeId) =>
      _StoreEntryAdapter(typeId);
}

class _StoreEntryAdapter extends _StoreEntryAdapterRaw {
  @override
  // ignore: overridden_fields
  final int typeId;

  _StoreEntryAdapter(this.typeId);
}
