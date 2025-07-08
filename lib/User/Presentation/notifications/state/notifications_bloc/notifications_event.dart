part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
  @override
  List<Object> get props => [];
}

class GetNotifications extends NotificationsEvent {}

class MarkNotificationAsSeen extends NotificationsEvent {
  final String id;

  const MarkNotificationAsSeen(this.id);

  @override
  List<Object> get props => [id]; 
}

class ClearNotifications extends NotificationsEvent {}

class DeleteNotification extends NotificationsEvent {
  final int id;

  const DeleteNotification(this.id);

  @override
  List<Object> get props => [id];
}
