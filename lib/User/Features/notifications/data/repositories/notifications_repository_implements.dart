import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/notifications/data/datasources/notification_local_data_source.dart';
import 'package:moatmat_app/User/Features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:moatmat_app/User/Features/notifications/domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImplements implements NotificationsRepository {
  final NotificationsRemoteDatasource _remoteDatasource;
  final NotificationLocalDataSource _localDataSourse;

  NotificationsRepositoryImplements(this._remoteDatasource, this._localDataSourse);
  @override
  Future<Either<Failure, Unit>> initializeLocalNotification() async {
    try {
      final response = await _remoteDatasource.initializeLocalNotification();
      return right(response);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> initializeFirebaseNotification() async {
    try {
      final response = await _remoteDatasource.initializeFirebaseNotification();
      return right(response);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> createNotificationsChannel({required AndroidNotificationChannel channel}) async {
    try {
      final response = await _remoteDatasource.createNotificationsChannel(channel);
      debugPrint("createNotificationsChannel : $response");

      return right(unit);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> displayFirebaseNotification({required RemoteMessage message}) async {
    try {
      final response1 = await _remoteDatasource.displayFirebaseNotification(message);
      return right(response1);
    } on Exception catch (e) {
      debugPrint("debugging error ${e.toString()}");
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> displayNotification({
    required AppNotification notification,
    bool oneTimeNotification = true,
    NotificationDetails? details,
  }) async {
    try {
      final response = await _remoteDatasource.displayLocalNotification(
        notification: notification,
        oneTimeNotification: oneTimeNotification,
        details: details,
      );
      return right(response);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications() async {
    try {
      final List<AppNotification> remoteNotifications = await _remoteDatasource.getNotifications();

      final List<AppNotification> updatedNotifications = await Future.wait(remoteNotifications.map((notification) async {
        final bool isSeen = await _localDataSourse.isNotificationSeen(notification.id.toString());

        return notification.copyWith(seen: isSeen);
      }));

      return Right(updatedNotifications);
    } on CacheFailure {
      return Left(CacheFailure());
    } catch (e) {
      return Left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> subscribeToTopic({required String topic}) async {
    try {
      await _remoteDatasource.subscribeToTopic(topic);
      return right(unit);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteDeviceToken() async {
    try {
      await _remoteDatasource.deleteDeviceToken();
      return right(unit);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> unsubscribeToTopic({required String topic}) async {
    try {
      await _remoteDatasource.unsubscribeToTopic(topic);
      return right(unit);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getDeviceToken() async {
    try {
      final response = await _remoteDatasource.getDeviceToken();
      return right(response);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, String>> refreshDeviceToken() async {
    await FirebaseMessaging.instance.deleteToken();
    return getDeviceToken();
  }

  @override
  Future<Either<Failure, Unit>> registerDeviceToken({
    required String deviceToken,
    required String platform,
  }) async {
    try {
      final response = await _remoteDatasource.registerDeviceToken(
        deviceToken: deviceToken,
        platform: platform,
      );
      debugPrint("Success");
      return right(response);
    } on ServerException {
      return left(ServerFailure());
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> markNotificationAsSeen(String notificationId) async {
    try {
      await _localDataSourse.addSeenNotification(notificationId);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
