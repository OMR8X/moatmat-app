import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/notifications/domain/entities/notifications_data.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/get_notifications_uc.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/is_there_new_notifications_uc.dart';
part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsInitial());
  bool newNotifications = false;
  List<NotificationData> notifications = [];
  init() async {
    emit(NotificationsLoading());
    locator<GetNotificationsUC>().call().then((value) {
      value.fold(
        (l) {},
        (r) {
          notifications = r;
          newNotifications = locator<IsThereNewNotificationsUC>().call(
            notifications,
          );
          emit(NotificationsInitial(
            newNotifications: newNotifications,
            notifications: notifications,
          ));
        },
      );
    });
  }
}
