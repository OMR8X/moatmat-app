import '../../../../Core/injection/app_inj.dart';
import '../../../purchase/domain/entites/purchase_item.dart';
import '../../../tests/domain/entities/question.dart';
import 'bank_information.dart';

class Bank {
  final int id;
  final String teacherEmail;
  final BankInformation information;
  final List<Question> questions;
  Bank({
    required this.id,
    required this.teacherEmail,
    required this.information,
    required this.questions,
  });

  Bank copyWith({
    int? id,
    String? teacherEmail,
    BankInformation? information,
    List<Question>? questions,
  }) {
    return Bank(
      id: id ?? this.id,
      teacherEmail: teacherEmail ?? this.teacherEmail,
      information: information ?? this.information,
      questions: questions ?? this.questions,
    );
  }

  PurchaseItem toPurchaseItem() {
    return PurchaseItem(
      amount: information.price,
      itemId: "$id",
      itemType: "bank",
    );
  }

  bool isPurchased() {
    bool purchased = false;
    //
    var items = locator<List<PurchaseItem>>();
    //
    for (var i in items) {
      if (i.itemId == "$id" && i.itemType == "bank") {
        purchased = true;
      }
    }
    //
    return purchased;
  }
}
