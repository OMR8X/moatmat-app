import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank_q.dart';
import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';

class Bank {
  //
  final int id;
  final int cost;
  //
  final String clas;
  final String title;
  final String material;
  final String teacher;
  //
  final List<BankQuestion> questions;
  //
  Bank({
    required this.id,
    required this.cost,
    required this.title,
    required this.clas,
    required this.material,
    required this.teacher,
    required this.questions,
  });
  //
  Bank copyWith({
    int? id,
    int? cost,
    String? clas,
    String? title,
    String? material,
    String? teacher,
    List<BankQuestion>? questions,
  }) {
    return Bank(
      id: id ?? this.id,
      cost: cost ?? this.cost,
      title: title ?? this.title,
      clas: clas ?? this.clas,
      material: material ?? this.material,
      teacher: teacher ?? this.teacher,
      questions: questions ?? this.questions,
    );
  }

  PurchaseItem toPurchaseItem() {
    return PurchaseItem(
      amount: cost,
      item: "$id , $title",
      teacher: teacher,
    );
  }

  bool isPurchased() {
    var items = locator<List<PurchaseItem>>().map((e) => e.item).toList();
    return items.contains("$id , $title");
  }
}
