import 'package:moatmat_app/Features/banks/domain/entites/bank_properties.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../auth/domain/entites/user_data.dart';
import '../../../purchase/domain/entites/purchase_item.dart';
import '../../../tests/domain/entities/question.dart';
import 'bank_information.dart';

class Bank {
  final int id;
  final String teacherEmail;
  final BankInformation information;
  final BankProperties properties;
  final List<Question> questions;
  Bank({
    required this.id,
    required this.teacherEmail,
    required this.information,
    required this.properties,
    required this.questions,
  });

  Bank copyWith({
    int? id,
    String? teacherEmail,
    BankInformation? information,
    BankProperties? properties,
    List<Question>? questions,
  }) {
    return Bank(
      id: id ?? this.id,
      teacherEmail: teacherEmail ?? this.teacherEmail,
      information: information ?? this.information,
      properties: properties ?? this.properties,
      questions: questions ?? this.questions,
    );
  }

  PurchaseItem toPurchaseItem() {
    return PurchaseItem(
      userName: locator<UserData>().name,
      amount: information.price,
      itemId: "$id",
      itemType: "bank",
    );
  }

  bool isPurchased() {
    //
    bool purchased = false;
    //
    var items = locator<List<PurchaseItem>>();
    //
    for (var i in items) {
      if (i.itemId == "$id" && i.itemType == "bank") {
        purchased = true;
      }
      if (i.itemId == information.teacher && i.itemType == "teacher") {
        purchased = true;
      }
    }
    //
    return purchased;
  }
}
