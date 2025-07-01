import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/resources/supabase_r.dart';
import 'package:moatmat_app/User/Features/notifications/domain/requests/register_device_token_request.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/display_firebase_notification_usecase.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/register_device_token_usecase.dart';
import 'package:moatmat_app/User/Presentation/notifications/state/notifications_bloc/notifications_bloc.dart';
import 'package:moatmat_app/firebase_options.dart';

///
/// [firebase messaging background handler]
import 'package:supabase_flutter/supabase_flutter.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('A background message was received in flutter_background_service plugin: ${message.messageId}');
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

  await locator<DisplayFirebaseNotificationUsecase>().call(message: message);
  debugPrint('DisplayFirebaseNotificationUsecase called');
}

///
/// [notifications action handler]
@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse? response) async {
  if (response == null) {
    return;
  }
  return;
}

///
/// [firebase messaging foreground handler]
void onData(RemoteMessage message) async {
  // debugPrint('A foreground message was received in flutter_background_service plugin: ${message.messageId}');
  await locator<DisplayFirebaseNotificationUsecase>().call(message: message);
  debugPrint('DisplayFirebaseNotificationUsecase called');
  locator<NotificationsBloc>().add(GetNotifications());
}

///
void onTokenRefreshed(String newToken) async {
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
