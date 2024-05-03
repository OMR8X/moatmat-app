import '../../../../Core/injection/app_inj.dart';
import '../../../purchase/domain/entites/purchase_item.dart';
import 'test_information.dart';
import 'test_properties.dart';
import 'question.dart';

class Test {
  final int id;
  final String teacherEmail;
  final TestInformation information;
  final TestProperties properties;
  final List<Question> questions;

  Test({
    required this.id,
    required this.teacherEmail,
    required this.information,
    required this.properties,
    required this.questions,
  });
  Test copyWith({
    int? id,
    String? teacherEmail,
    TestInformation? information,
    TestProperties? properties,
    List<Question>? questions,
  }) {
    return Test(
      id: id ?? this.id,
      teacherEmail: teacherEmail ?? this.teacherEmail,
      information: information ?? this.information,
      properties: properties ?? this.properties,
      questions: questions ?? this.questions,
    );
  }

  PurchaseItem toPurchaseItem() {
    return PurchaseItem(
      amount: information.price ?? 0,
      itemId: "$id",
      itemType: "test",
    );
  }

  bool isPurchased() {
    bool purchased = false;
    //
    var items = locator<List<PurchaseItem>>();
    //

    for (var i in items) {
      if (i.itemId == "$id" && i.itemType == "test") {
        purchased = true;
      }
    }
    //
    return purchased;
  }
}
