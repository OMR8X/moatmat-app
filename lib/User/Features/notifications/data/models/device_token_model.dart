class DeviceTokenModel {
  final String userId;
  final String deviceToken;
  final String platform;
  final DateTime updatedAt;

  DeviceTokenModel({
    required this.userId,
    required this.deviceToken,
    required this.platform,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'device_token': deviceToken,
      'platform': platform,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static DeviceTokenModel create({
    required String userId,
    required String deviceToken,
    required String platform,
  })  {
    return DeviceTokenModel(
      userId: userId,
      deviceToken: deviceToken,
      platform: platform,
      updatedAt: DateTime.now().toUtc(),
    );
  }
}
