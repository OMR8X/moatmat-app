part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class GetNotifications extends NotificationsEvent {}

class ClearNotifications extends NotificationsEvent {}

class DeleteNotification extends NotificationsEvent {
  final int id;

  const DeleteNotification(this.id);

  @override
  List<Object> get props => [id];
}
