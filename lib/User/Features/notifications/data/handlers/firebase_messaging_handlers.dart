import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moatmat_app/User/Core/constant/navigation_key.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/resources/supabase_r.dart';
import 'package:moatmat_app/User/Features/notifications/domain/requests/register_device_token_request.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/display_firebase_notification_usecase.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/register_device_token_usecase.dart';
import 'package:moatmat_app/User/Presentation/notifications/state/notifications_bloc/notifications_bloc.dart';
import 'package:moatmat_app/User/Presentation/notifications/views/notifications_view.dart';
import 'package:moatmat_app/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('A background message was received: ${message.messageId}');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('Firebase initialized');

  await Supabase.initialize(
    url: SupabaseResources.url,
    anonKey: SupabaseResources.key,
  );

  debugPrint('Supabase initialized');

  if (!locator.isRegistered<DisplayFirebaseNotificationUsecase>()) {
    await initGetIt();
  }

  locator<NotificationsBloc>().add(GetNotifications());
  await locator<DisplayFirebaseNotificationUsecase>().call(message: message);
  debugPrint('DisplayFirebaseNotificationUsecase called');
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse? response) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('Firebase initialized');

  await Supabase.initialize(
    url: SupabaseResources.url,
    anonKey: SupabaseResources.key,
  );

  debugPrint('Supabase initialized');

  if (!locator.isRegistered<DisplayFirebaseNotificationUsecase>()) {
    await initGetIt();
  }

  locator<NotificationsBloc>().add(GetNotifications());

  await Future.delayed(const Duration(milliseconds: 500));

  if (navigatorKey.currentState != null) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const NotificationsView()),
    );
  }
}

class FirebaseMessagingHandlers {
  ///
  /// [firebase messaging foreground handler]
  Future<void> onData(RemoteMessage message) async {
    debugPrint('A foreground message was received: ${message.messageId}');
    await locator<DisplayFirebaseNotificationUsecase>().call(message: message);
    locator<NotificationsBloc>().add(GetNotifications());
    debugPrint('DisplayFirebaseNotificationUsecase called');
  }

  ///
  Future<void> onTokenRefreshed(String newToken) async {
    final platform = Platform.isAndroid ? 'android' : 'ios';

    await locator<RegisterDeviceTokenUseCase>().call(
      RegisterDeviceTokenRequest(
        deviceToken: newToken,
        platform: platform,
      ),
    );
  }

  ///
  void onDone() {}

  ///
  void onError(error) {}

  Future<void> onNotificationOpened(RemoteMessage message) async {
    debugPrint('Notification opened from background/terminated state: ${message.messageId}');

    // Refresh notifications
    locator<NotificationsBloc>().add(GetNotifications());

    // Add delay to ensure the app is fully resumed and navigation context is ready
    await Future.delayed(const Duration(milliseconds: 300));

    // Check if navigator is ready
    if (navigatorKey.currentState?.mounted == true) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const NotificationsView()),
      );
    } else {
      // If navigator is not ready, wait and try again
      await Future.delayed(const Duration(milliseconds: 500));
      if (navigatorKey.currentState?.mounted == true) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const NotificationsView()),
        );
      } else {
        debugPrint('Navigator not ready for notification navigation');
      }
    }
  }

  /// [firebase notification initial handler]
  Future<void> onInitialNotification() async {
    final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      debugPrint('App opened from terminated state via notification: ${initialMessage.messageId}');
      // Add delay to ensure app is fully initialized
      await Future.delayed(const Duration(milliseconds: 1000));
      await onNotificationOpened(initialMessage);
    }
  }
}
