part of 'notifications_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<AppNotification> notifications;
  final int unreadCount;

  const NotificationsLoaded({
    this.notifications = const [],
    this.unreadCount = 0,
  });
  NotificationsLoaded copyWith({
    List<AppNotification>? notifications,
    int? unreadCount,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
  @override
  List<Object> get props => [notifications, unreadCount];
}

class NotificationsFailure extends NotificationsState {
  final String message;

  const NotificationsFailure(this.message);

  @override
  List<Object> get props => [message];
}