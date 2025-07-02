import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/initialize_firebase_notifications_usecase.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/initialize_local_notifications_usecase.dart';

part 'initialize_notifications_state.dart';

class InitializeNotificationsCubit extends Cubit<InitializeNotificationsState> {
  final InitializeLocalNotificationsUsecase _initializeLocalNotifications;
  final InitializeFirebaseNotificationsUsecase _initializeFirebaseNotifications;

  InitializeNotificationsCubit({
    required InitializeLocalNotificationsUsecase initializeLocalNotifications,
    required InitializeFirebaseNotificationsUsecase
        initializeFirebaseNotifications,
  })  : _initializeLocalNotifications = initializeLocalNotifications,
        _initializeFirebaseNotifications = initializeFirebaseNotifications,
        super(InitializeNotificationsInitial());

  Future<void> initialize() async {
    emit(InitializeNotificationsLoading());
    final localResult = await _initializeLocalNotifications.call();
    if (localResult.isLeft()) {
      localResult.fold((f) => f, (_) => null);
      emit(InitializeNotificationsFailure("خطا في إعداد الإشعارات"));
    }
    final firebaseResult = await _initializeFirebaseNotifications.call();
    if (firebaseResult.isLeft()) {
      firebaseResult.fold((f) => f, (_) => null);
      emit(InitializeNotificationsFailure("خطا في إعداد الإشعارات"));
      return;
    }
    emit(InitializeNotificationsSuccess());
  }
}
