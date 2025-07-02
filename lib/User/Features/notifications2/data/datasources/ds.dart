import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/User/Features/auth/domain/use_cases/get_user_data.dart';
import 'package:moatmat_app/User/Features/notifications2/data/models/notification_data_m.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/notifications_data.dart';

abstract class NotificationsDataSource {
  Future<List<NotificationData>> getNotifications();
  bool isThereNewNotifications(List<NotificationData> notifications);
  void readNotifications(List<NotificationData> notifications);
}

class NotificationsDataSourceImpl implements NotificationsDataSource {
  final SupabaseClient client;
  final SharedPreferences sp;

  NotificationsDataSourceImpl({
    required this.client,
    required this.sp,
  });
  @override
  Future<List<NotificationData>> getNotifications() async {
    var res = await client.from("notifications").select();
    List<NotificationData> notifications = [];
    notifications = res.map((e) => NotificationDataModel.fromJson(e)).toList();
    //
    final response = await locator<GetUserDataUC>()
        .call(uuid: locator<UserData>().uuid, update: true);
    //
    response.fold(
      (l) {
        notifications += List<NotificationDataModel>.from(
          locator<UserData>().notifications,
        );
      },
      (r) {
        notifications += List<NotificationDataModel>.from(
          r.notifications,
        );
      },
    );
    //

    //
    notifications.sort((a, b) => b.date.compareTo(a.date));
    //
    return notifications;
  }

  @override
  bool isThereNewNotifications(List<NotificationData> notifications) {
    //
    bool value = false;
    //
    List<String> oldIDs = sp.getStringList("notifications") ?? [];
    //
    List<String> newIDs = notifications.map((e) => e.id.toString()).toList();
    //
    if (oldIDs.length != newIDs.length) return true;
    //
    for (var id in newIDs) {
      if (!oldIDs.contains(id) && !value) {
        value = true;
        break;
      }
    }
    return value;
  }

  @override
  void readNotifications(List<NotificationData> notifications) async {
    List<String> newIDs = notifications.map((e) => e.id.toString()).toList();
    await sp.setStringList("notifications", newIDs);
    return;
  }
}
