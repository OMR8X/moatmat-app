class PurchaseItem {
  //
  final int id;
  final String uuid;
  final String userName;
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
    required this.userName,
    required this.amount,
    required this.itemType,
    required this.itemId,
    this.dayAndMoth = "",
  });
  PurchaseItem copyWith({
    int? id,
    String? uuid,
    String? userName,
    int? amount,
    String? itemId,
    String? itemType,
    String? dayAndMoth,
  }) {
    return PurchaseItem(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      userName: userName ?? this.userName,
      amount: amount ?? this.amount,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      dayAndMoth: dayAndMoth ?? this.dayAndMoth,
    );
  }
}
