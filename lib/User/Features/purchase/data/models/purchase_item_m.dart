import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';

class PurchaseItemModel extends PurchaseItem {
  PurchaseItemModel({
    required super.id,
    required super.uuid,
    required super.amount,
    required super.item,
    required super.teacher,
  });
  factory PurchaseItemModel.fromJson(Map json) {
    return PurchaseItemModel(
      id: json["id"],
      uuid: json["uuid"],
      amount: json["amount"],
      item: json["item"],
      teacher: json["teacher"],
    );
  }
  factory PurchaseItemModel.fromClass(PurchaseItem item) {
    return PurchaseItemModel(
      id: item.id,
      uuid: item.uuid,
      amount: item.amount,
      item: item.item,
      teacher: item.teacher,
    );
  }
  toJson() {
    return {
      "uuid": uuid,
      "amount": amount,
      "item": item,
      "teacher": teacher,
      "day_month": "${DateTime.now().month}/${DateTime.now().day}",
    };
  }
}
