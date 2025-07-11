import 'package:moatmat_app/User/Features/update/domain/entites/update_info.dart';

class UpdateInfoModel extends UpdateInfo {
  UpdateInfoModel({
    required super.appVersion,
    required super.currentVersion,
    required super.minimumVersion,
    required super.app,
  });

  factory UpdateInfoModel.fromJson(Map json) {
    return UpdateInfoModel(
      appVersion: 203,
      currentVersion: int.parse(
        (json["current_version"] as String).replaceAll(".", ""),
      ),
      minimumVersion: int.parse(
        (json["minimum_version"] as String).replaceAll(".", ""),
      ),
      app: json["app"],
    );
  }
  factory UpdateInfoModel.fromClass(UpdateInfo info) {
    return UpdateInfoModel(
      appVersion: info.appVersion,
      currentVersion: info.currentVersion,
      minimumVersion: info.minimumVersion,
      app: info.app,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "app_version": appVersion,
      "current_version": currentVersion,
      "minimum_version": minimumVersion,
      "app": app,
    };
  }
}
