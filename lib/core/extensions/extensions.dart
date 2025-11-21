extension EnumX<T extends Enum> on Iterable<T> {
  T? by(String? name) {
    for (final value in this) {
      if (value.name.toLowerCase() == name?.toLowerCase()) {
        return value;
      }
    }
    return null;
  }
}
