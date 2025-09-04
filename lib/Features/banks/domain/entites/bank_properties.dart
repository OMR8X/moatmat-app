class BankProperties {
  final bool? visible;
  final bool? scrollable;

  BankProperties({
    required this.visible,
    required this.scrollable,
  });
  BankProperties copyWith({
    bool? visible,
    bool? scrollable,
  }) {
    return BankProperties(
      visible: visible ?? this.visible,
      scrollable: scrollable ?? this.scrollable,
    );
  }
}
