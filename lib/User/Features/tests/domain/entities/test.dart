import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/question.dart';

import '../../../../Core/injection/app_inj.dart';

class Test {
  final int id;
  // info
  final String title;
  final String clas;
  final String material;
  final String teacher;
  // Properties
  final int? seconds;
  final String? password;
  final int? cost;
  // settings
  final bool timePerQuestion;
  final bool explorable;
  final bool returnable;
  //
  final List<TestQuestion> questions;

  Test({
    required this.id,
    required this.title,
    required this.clas,
    required this.material,
    required this.teacher,
    required this.seconds,
    required this.password,
    required this.cost,
    required this.timePerQuestion,
    required this.explorable,
    required this.returnable,
    required this.questions,
  });
  Test copyWith({
    final int? id,
    final String? title,
    final String? clas,
    final String? material,
    final String? teacher,
    final int? seconds,
    final String? password,
    final int? cost,
    final bool? timePerQuestion,
    final bool? explorable,
    final bool? returnable,
    final List<TestQuestion>? questions,
  }) {
    return Test(
      id: id ?? this.id,
      title: title ?? this.title,
      clas: clas ?? this.clas,
      material: material ?? this.material,
      teacher: teacher ?? this.teacher,
      seconds: seconds ?? this.seconds,
      password: password ?? this.password,
      cost: cost ?? this.cost,
      timePerQuestion: timePerQuestion ?? this.timePerQuestion,
      explorable: explorable ?? this.explorable,
      returnable: returnable ?? this.returnable,
      questions: questions ?? this.questions,
    );
  }

  PurchaseItem toPurchaseItem() {
    return PurchaseItem(
      amount: cost ?? 0,
      item: "$id , $title",
      teacher: teacher,
    );
  }

  bool isPurchased() {
    var items = locator<List<PurchaseItem>>().map((e) => e.item).toList();
    return items.contains("$id , $title");
  }
}
