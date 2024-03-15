part of 'notifications_cubit.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

final class NotificationsInitial extends NotificationsState {
  final bool newNotifications;
  final List<NotificationData> notifications;

  const NotificationsInitial({
    this.newNotifications = false,
    this.notifications = const [],
  });
  @override
  List<Object> get props => [newNotifications, notifications];
}

final class NotificationsLoading extends NotificationsState {}
