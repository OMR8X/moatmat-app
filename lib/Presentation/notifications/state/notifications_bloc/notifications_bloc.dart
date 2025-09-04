import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Features/notifications/domain/entities/app_notification.dart';
import 'package:moatmat_app/Features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:moatmat_app/Features/notifications/domain/usecases/mark_notification_seen.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUsecase _getNotificationsUsecase;
  final MarkNotificationSeen _markNotificationSeen; 
  // final ClearNotificationsUsecase _clearNotificationsUsecase;
  // final DeleteNotificationUsecase _deleteNotificationUsecase;

  NotificationsBloc({
    required GetNotificationsUsecase getNotificationsUsecase,
    required MarkNotificationSeen markNotificationSeen,
    // required ClearNotificationsUsecase clearNotificationsUsecase,
    // required DeleteNotificationUsecase deleteNotificationUsecase,
  })  : _getNotificationsUsecase = getNotificationsUsecase,
        _markNotificationSeen = markNotificationSeen,
        // _clearNotificationsUsecase = clearNotificationsUsecase,
        // _deleteNotificationUsecase = deleteNotificationUsecase,
        super(NotificationsInitial()) {
    on<GetNotifications>(_onGetNotifications);
    on<MarkNotificationAsSeen>(_onMarkNotificationAsSeen);
  }

  Future<void> _onGetNotifications(
    GetNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());
    final result = await _getNotificationsUsecase();
    result.fold(
      (failure) => emit(NotificationsFailure("خطأ اثناء الحصول على الإشعارات")),
      (notifications) {
        final unread = notifications.where((n) => !n.seen).length;
        emit(NotificationsLoaded(notifications: notifications, unreadCount: unread));
      },
    );
  }

Future<void> _onMarkNotificationAsSeen(
  MarkNotificationAsSeen event,
  Emitter<NotificationsState> emit,
) async {
    await _markNotificationSeen.call(event.id);
    final state = this.state;
  if (state is NotificationsLoaded) {
    final updated = state.notifications.map((n) {
      return n.id == event.id ? n.copyWith(seen: true) : n;
    }).toList();

    final unread = updated.where((n) => !n.seen).length;

    emit(state.copyWith(notifications: updated, unreadCount: unread));
  }
}
}
