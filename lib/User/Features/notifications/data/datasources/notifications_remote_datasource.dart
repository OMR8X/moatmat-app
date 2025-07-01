import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/notifications/data/handlers/firebase_messaging_handlers.dart';
import 'package:moatmat_app/User/Features/notifications/data/models/device_token_model.dart';
import 'package:moatmat_app/User/Features/notifications/data/settings/app_local_notifications_settings.dart';
import 'package:moatmat_app/User/Features/notifications/data/settings/firebase_messaging_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/app_notification.dart';

abstract class NotificationsRemoteDatasource {
  Future<Unit> initializeLocalNotification();
  Future<Unit> initializeFirebaseNotification();
  Future<Unit> createNotificationsChannel(AndroidNotificationChannel channel);
  Future<Unit> displayFirebaseNotification(RemoteMessage message);
  Future<Unit> displayLocalNotification({
    required AppNotification notification,
    bool oneTimeNotification = true,
    NotificationDetails? details,
  });
  Future<Unit> subscribeToTopic(String topic);
  Future<Unit> unsubscribeToTopic(String topic);
  Future<String> getDeviceToken();
  Future<Unit> deleteDeviceToken();
  Future<Unit> registerDeviceToken(
      {required String deviceToken, required String platform});
  Future<List<AppNotification>> getNotifications();
}

class NotificationsRemoteDatasourceImpl
    implements NotificationsRemoteDatasource {
  final _supabase = Supabase.instance.client;
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Future<Unit> initializeLocalNotification() async {
    await _requestNotificationPermission();

    for (var channel in AppLocalNotificationsSettings.channels) {
      await createNotificationsChannel(channel);
    }

    await _localNotificationsPlugin.initialize(
      AppLocalNotificationsSettings.settings,
      onDidReceiveNotificationResponse: (response) {},
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    return unit;
  }

  @override
  Future<Unit> initializeFirebaseNotification() async {
    await _firebaseMessaging.requestPermission();

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: AppRemoteNotificationsSettings.showAlert,
      badge: AppRemoteNotificationsSettings.showBadge,
      sound: AppRemoteNotificationsSettings.showSound,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage
        .listen(onData, onDone: onDone, onError: onError);
    FirebaseMessaging.instance.onTokenRefresh.listen(onTokenRefreshed);

    for (var topic in AppRemoteNotificationsSettings.defaultTopicList) {
      await subscribeToTopic(topic);
    }

    debugPrint("Firebase token: ${await getDeviceToken()}");
    return unit;
  }

  @override
  Future<Unit> createNotificationsChannel(
      AndroidNotificationChannel channel) async {
    final androidImplementation =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.createNotificationChannel(channel);
    return unit;
  }

  @override
  Future<Unit> displayLocalNotification({
    required AppNotification notification,
    bool oneTimeNotification = true,
    NotificationDetails? details,
  }) async {
    if (!notification.isValid()) return unit;

    await _localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      details ?? AppLocalNotificationsSettings.defaultNotificationsDetails(),
    );

    return unit;
  }

  @override
  Future<Unit> displayFirebaseNotification(RemoteMessage message) async {
    final notification = AppNotification.fromRemoteMessage(message);
    debugPrint(notification.toString());

    if (message.notification?.title != null || !notification.isValid()) {
      return unit;
    }

    await _localNotificationsPlugin.show(
      DateTime.now().millisecond,
      notification.title,
      notification.body,
      AppLocalNotificationsSettings.defaultNotificationsDetails(),
    );

    return unit;
  }

  @override
  Future<Unit> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    return unit;
  }

  @override
  Future<Unit> unsubscribeToTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    return unit;
  }

  @override
  Future<Unit> deleteDeviceToken() async {
    await _firebaseMessaging.deleteToken();
    return unit;
  }

  @override
  Future<String> getDeviceToken() async {
    final token = Platform.isIOS
        ? await _firebaseMessaging.getAPNSToken()
        : await _firebaseMessaging.getToken();

    if (token == null) throw Exception("FCM token is null");
    return token;
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
  Future<Unit> registerDeviceToken(
      {required String deviceToken, required String platform}) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      debugPrint('User is null');
      throw ServerException();
    }

    final model = DeviceTokenModel.create(
      userId: user.id,
      deviceToken: deviceToken,
      platform: platform,
    );

    try {
      await _supabase
          .from('device_tokens')
          .delete()
          .eq('user_id', model.userId)
          .eq('platform', model.platform);

      await _supabase.from('device_tokens').insert(model.toMap());
      debugPrint("✅ Device token registered successfully to Supabase");
      return unit;
    } on PostgrestException catch (e) {
      debugPrint('Supabase error: ${e.message}');
      throw ServerException();
    } catch (e) {
      debugPrint('Unexpected error: ${e.toString()}');
      throw ServerException();
    }
  }

  @override
  Future<List<AppNotification>> getNotifications() async {
    try {
      final user = _supabase.auth.currentUser;
      final userId = user?.id;
      final subscribedTopics = AppRemoteNotificationsSettings.defaultTopicList;

      if (userId == null) return [];

      final response = await _supabase.from('notifications2').select().or(
            'and(type.eq.user,target_user_ids.cs.{$userId}),and(type.eq.topic,target_topics.cs.{${subscribedTopics.join(',')}})',
          ) as List;

      return response.map((e) {
        return AppNotification.fromJson(e as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint('Unexpected error while trying to get notifications: $e');
      throw ServerException();
    }
  }
}
