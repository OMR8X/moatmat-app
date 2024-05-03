import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';

class PurchaseItemModel extends PurchaseItem {
  PurchaseItemModel({
    required super.id,
    required super.uuid,
    required super.amount,
    required super.itemId,
    required super.itemType,
  });
  factory PurchaseItemModel.fromJson(Map json) {
    return PurchaseItemModel(
      id: json["id"],
      uuid: json["uuid"],
      amount: json["amount"],
      itemId: json["item_id"],
      itemType: json["item_type"],
    );
  }
  factory PurchaseItemModel.fromClass(PurchaseItem item) {
    return PurchaseItemModel(
      id: item.id,
      uuid: item.uuid,
      amount: item.amount,
      itemId: item.itemId,
      itemType: item.itemType,
    );
  }
  toJson() {
    return {
      "uuid": uuid,
      "amount": amount,
      "item_id": itemId,
      "item_type": itemType,
      "day_month": "${DateTime.now().month}/${DateTime.now().day}",
    };
  }
}
