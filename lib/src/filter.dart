abstract class Filter {
  Map<String, String> query();
}

mixin FilterScope<T, TType> on Filter {
  final _queries = <String, String>{};

  FilterScope<T, TType> limitToFirst(int value) {
    _queries["limitToFirst"] = value.toString();
    return this;
  }

  FilterScope<T, TType> limitToLast(int value) {
    _queries["limitToLast"] = value.toString();
    return this;
  }

  FilterScope<T, TType> startAt(T value) {
    _queries["startAt"] = value.toString();
    return this;
  }

  FilterScope<T, TType> endAt(T value) {
    _queries["endAt"] = value.toString();
    return this;
  }

  FilterScope<T, TType> equalTo(T value) {
    _queries["equalTo"] = value.toString();
    return this;
  }
}

class PathFilter<T> extends Filter with FilterScope<T, PathFilter<T>> {
  final String _path;

  PathFilter(this._path);

  @override
  Map<String, String> query() => {
        "orderBy": _path,
        ..._queries,
      };
}

class KeyFilter extends Filter with FilterScope<String, KeyFilter> {
  @override
  Map<String, String> query() => {
        "orderBy": "\$key",
        ..._queries,
      };
}

class ValueFilter<T> extends Filter with FilterScope<T, PathFilter<T>> {
  @override
  Map<String, String> query() => {
        "orderBy": "\$value",
        ..._queries,
      };
}
