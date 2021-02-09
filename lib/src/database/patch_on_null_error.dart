class PatchOnNullError extends Error {
  final String? key;

  PatchOnNullError([this.key]);

  @override
  String toString() => key != null
      ? 'Cannot patch a non existant entry, '
          'no value with key: ${Error.safeToString(key)}'
      : 'Cannot patch a non existant entry';
}
