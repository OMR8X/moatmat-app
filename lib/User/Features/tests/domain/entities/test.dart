import 'package:moatmat_app/User/Features/auth/domain/entites/user_data.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../purchase/domain/entites/purchase_item.dart';
import 'test_information.dart';
import 'test_properties.dart';
import 'question.dart';

/*
TestInformation.title
TestInformation.price
TestInformation.period
TestInformation.video
TestInformation.files
TestInformation.previous
//
TestProperties.exploreAnswers
TestProperties.showAnswers
TestProperties.timePerQuestion
TestProperties.repeatable
//
questions
*/
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
      userName: locator<UserData>().name,
      amount: information.price ?? 0,
      itemId: "$id",
      itemType: "test",
    );
  }

  bool isPurchased() {
    //
    if (!locator.isRegistered<List<PurchaseItem>>()) {
      return false;
    }
    //
    bool purchased = false;
    //
    var items = locator<List<PurchaseItem>>().toSet().toList();
    //
    for (var i in items) {
      if (i.itemId.trim() == "$id" && i.itemType.trim() == "test") {
        purchased = true;
      }
      if ((i.itemId.trim() == information.teacher.trim()) && i.itemType.trim() == "teacher") {
        purchased = true;
      }
    }
    //
    return purchased;
  }
}
