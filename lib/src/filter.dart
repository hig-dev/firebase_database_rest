class Filter {
  final Map<String, String> filters;

  const Filter._(this.filters);

  static FilterBuilder<T> property<T>(String property) =>
      FilterBuilder<T>._(property);
  static FilterBuilder<String> key() => FilterBuilder<String>._("\$key");
  static FilterBuilder<T> value<T>() => FilterBuilder<T>._("\$value");
}

class FilterBuilder<T> {
  final String _orderyBy;
  final _queries = <String, String>{};

  FilterBuilder._(this._orderyBy);

  FilterBuilder<T> limitToFirst(int value) {
    _queries["limitToFirst"] = value.toString();
    return this;
  }

  FilterBuilder<T> limitToLast(int value) {
    _queries["limitToLast"] = value.toString();
    return this;
  }

  FilterBuilder<T> startAt(T value) {
    _queries["startAt"] = value.toString();
    return this;
  }

  FilterBuilder<T> endAt(T value) {
    _queries["endAt"] = value.toString();
    return this;
  }

  void equalTo(T value) {
    _queries["equalTo"] = value.toString();
  }

  Filter build() => Filter._({
        "orderBy": _orderyBy,
        ..._queries,
      });
}
