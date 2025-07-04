import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NotificationLocalDataSource {
  Future<Unit> addSeenNotification(String id);
  Future<bool> isNotificationSeen(String id);
  Future<void> clearAll();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
static const String _key = 'seen_notification_ids';

  final SharedPreferences sharedPreferences;

  NotificationLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Unit> addSeenNotification(String id) async {
    try {
      final seenIds = sharedPreferences.getStringList(_key) ?? [];

      if (!seenIds.contains(id)) {
        seenIds.add(id);
        await sharedPreferences.setStringList(_key, seenIds);
      }

      return unit;
    } catch (e) {
      throw CacheFailure();
    }
  }

  @override
  Future<bool> isNotificationSeen(String id) async {
    final seenIds = sharedPreferences.getStringList(_key) ?? [];
    return seenIds.contains(id);
  }

  @override
  Future<void> clearAll() async {
    await sharedPreferences.remove(_key);
  }
}