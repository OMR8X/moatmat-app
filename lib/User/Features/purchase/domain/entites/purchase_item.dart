class PurchaseItem {
  //
  final int id;
  final String uuid;
  //
  final int amount;
  //
  final String itemType;
  final String itemId;
  //
  late String dayAndMoth;

  PurchaseItem({
    this.id = 0,
    this.uuid = "",
    required this.amount,
    required this.itemType,
    required this.itemId,
  });
  PurchaseItem copyWith({
    int? id,
    String? uuid,
    int? amount,
    String? itemId,
    String? itemType,
  }) {
    return PurchaseItem(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      amount: amount ?? this.amount,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
    );
  }
}
