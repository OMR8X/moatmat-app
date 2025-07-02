part of 'notification_settings_bloc.dart';

abstract class NotificationSettingsEvent extends Equatable {
  const NotificationSettingsEvent();

  @override
  List<Object> get props => [];
}

class GetDeviceToken extends NotificationSettingsEvent {}

class SubscribeToTopic extends NotificationSettingsEvent {
  final String topic;

  const SubscribeToTopic(this.topic);

  @override
  List<Object> get props => [topic];
}

class UnsubscribeFromTopic extends NotificationSettingsEvent {
  final String topic;

  const UnsubscribeFromTopic(this.topic);

  @override
  List<Object> get props => [topic];
}
