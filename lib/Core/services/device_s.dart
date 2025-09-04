import 'package:device_info_plus/device_info_plus.dart';

class DeviceService {
  // Private constructor
  DeviceService._privateConstructor();

  // The singleton instance
  static final DeviceService _instance = DeviceService._privateConstructor();

  // Factory constructor that returns the singleton instance
  factory DeviceService() {
    return _instance;
  }

  // Variable to store the device ID
  String _deviceId = "";

  // Initialize the device ID only once
  Future<void> init() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var deviceData = await deviceInfo.deviceInfo;

    if (deviceData is AndroidDeviceInfo) {
      // For Android, use the androidId
      _deviceId = deviceData.id + deviceData.brand + deviceData.device;
    } else if (deviceData is IosDeviceInfo) {
      // For iOS, use the identifierForVendor
      _deviceId = deviceData.identifierForVendor ?? "";
    }
  }

  // Function to get the initialized device ID
  String get deviceId => _deviceId;
}
