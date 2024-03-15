class PurchaseItem {
  //
  final int id;
  final String uuid;
  //
  final int amount;
  //
  final String item;
  final String teacher;
  //
  late String dayAndMoth;

  PurchaseItem({
    this.id = 0,
    this.uuid = "",
    required this.amount,
    required this.item,
    required this.teacher,
  });
  PurchaseItem copyWith({
    int? id,
    String? uuid,
    int? amount,
    String? item,
    String? teacher,
  }) {
    return PurchaseItem(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      amount: amount ?? this.amount,
      item: item ?? this.item,
      teacher: teacher ?? this.teacher,
    );
  }
}
