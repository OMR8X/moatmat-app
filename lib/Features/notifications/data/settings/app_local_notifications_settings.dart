import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppLocalNotificationsSettings {
  ///
  static const InitializationSettings settings = InitializationSettings(
    iOS: DarwinInitializationSettings(),
    // TODO ABOUD 'icon'
    android: AndroidInitializationSettings("ic_launcher"),
  );

  ///
  static const defaultChannel = AndroidNotificationChannel(
    "local_notifications_channel",
    "local_notifications_channel",
    importance: Importance.min,
    playSound: false,
    enableVibration: false,
    enableLights: false,
  );

  /// default
  static const List<AndroidNotificationChannel> channels = [
    defaultChannel,
  ];

  ///
  static NotificationDetails defaultNotificationsDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        defaultChannel.id,
        defaultChannel.name,
        importance: Importance.min,
        priority: Priority.min,
        playSound: false,
        enableVibration: false,
        enableLights: false,
      ),
      iOS: const DarwinNotificationDetails(
        badgeNumber: 1,
        presentAlert: false,
        presentBadge: false,
        presentSound: false,
        subtitle: '',
        threadIdentifier: '',
      ),
    );
  }

  ///
  static NotificationDetails remoteNotificationsDetails({String? imagePath}) {
    StyleInformation? styleInformation;
    if (imagePath != null) {
      styleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(imagePath), // Use valid file path here
      );
    }

    return NotificationDetails(
      android: AndroidNotificationDetails(
        defaultChannel.id,
        defaultChannel.name,
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        enableLights: false,
        styleInformation: styleInformation,
      ),
      iOS: const DarwinNotificationDetails(
        badgeNumber: 1,
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        subtitle: '',
        threadIdentifier: '',
      ),
    );
  }

  ///
  static NotificationDetails progressNotificationsDetails({
    required int sent,
    required int total,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        defaultChannel.id,
        defaultChannel.name,
        importance: Importance.high,
        priority: Priority.high,
        showProgress: true,
        maxProgress: total,
        progress: sent,
        indeterminate: total == 0,
        playSound: false,
        enableLights: false,
        enableVibration: false,
        silent: true,
        actions: [
          const AndroidNotificationAction(
            'cancel_operation_button',
            'الغاء العملية',
          ),
        ],
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }
}
