part of 'notification_settings_bloc.dart';

abstract class NotificationSettingsState extends Equatable {
  const NotificationSettingsState();

  @override
  List<Object> get props => [];
}

class NotificationSettingsInitial extends NotificationSettingsState {}

class NotificationSettingsLoading extends NotificationSettingsState {}

class NotificationSettingsLoaded extends NotificationSettingsState {
  final String deviceToken;
  final List<String> subscribedTopics;

  const NotificationSettingsLoaded({
    required this.deviceToken,
    this.subscribedTopics = const [],
  });

  @override
  List<Object> get props => [deviceToken, subscribedTopics];

  NotificationSettingsLoaded copyWith({
    String? deviceToken,
    List<String>? subscribedTopics,
  }) {
    return NotificationSettingsLoaded(
      deviceToken: deviceToken ?? this.deviceToken,
      subscribedTopics: subscribedTopics ?? this.subscribedTopics,
    );
  }
}

class NotificationSettingsFailure extends NotificationSettingsState {
  final String message;

  const NotificationSettingsFailure(this.message);

  @override
  List<Object> get props => [message];
}
