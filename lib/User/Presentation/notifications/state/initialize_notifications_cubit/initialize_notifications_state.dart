part of 'initialize_notifications_cubit.dart';

abstract class InitializeNotificationsState extends Equatable {
  const InitializeNotificationsState();

  @override
  List<Object> get props => [];
}

class InitializeNotificationsInitial extends InitializeNotificationsState {}

class InitializeNotificationsLoading extends InitializeNotificationsState {}

class InitializeNotificationsSuccess extends InitializeNotificationsState {}

class InitializeNotificationsFailure extends InitializeNotificationsState {
  final String message;

  const InitializeNotificationsFailure(this.message);

  @override
  List<Object> get props => [message];
}
