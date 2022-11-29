class LimitedProperty<T> {
  late T maxValue;
  late T value;

  LimitedProperty(this.value, this.maxValue);

  @override
  String toString() {
    return "$value/$maxValue";
  }
}
