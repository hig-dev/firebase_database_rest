import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter.freezed.dart';

@freezed
abstract class Filter with _$Filter {
  const factory Filter._(Map<String, String> filters) = _Filter;

  static FilterBuilder<T> property<T>(String property) =>
      FilterBuilder<T>._(property);
  static FilterBuilder<String> key() => FilterBuilder<String>._(r'$key');
  static FilterBuilder<T> value<T>() => FilterBuilder<T>._(r'$value');
}

class FilterBuilder<T> {
  final String _orderyBy;
  final _queries = <String, String>{};

  FilterBuilder._(this._orderyBy);

  FilterBuilder<T> limitToFirst(int value) {
    _queries['limitToFirst'] = json.encode(value);
    return this;
  }

  FilterBuilder<T> limitToLast(int value) {
    _queries['limitToLast'] = json.encode(value);
    return this;
  }

  FilterBuilder<T> startAt(T value) {
    _queries['startAt'] = json.encode(value);
    return this;
  }

  FilterBuilder<T> endAt(T value) {
    _queries['endAt'] = json.encode(value);
    return this;
  }

  FilterBuilder<T> equalTo(T value) {
    _queries['equalTo'] = json.encode(value);
    return this;
  }

  Filter build() => Filter._({
        'orderBy': json.encode(_orderyBy),
        ..._queries,
      });
}
