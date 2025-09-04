import '../../domain/entites/bank_properties.dart';

class BankPropertiesModel extends BankProperties {
  BankPropertiesModel({
    required super.visible,
    required super.scrollable,
  });
  factory BankPropertiesModel.fromJson(Map? json) {
    return BankPropertiesModel(
      visible: json?["visible"],
      scrollable: json?["scrollable"],
    );
  }
  factory BankPropertiesModel.fromClass(BankProperties properties) {
    return BankPropertiesModel(
      visible: properties.visible,
      scrollable: properties.scrollable,
    );
  }

  toJson() {
    return {
      "visible": visible,
      "scrollable": scrollable,
    };
  }
}
