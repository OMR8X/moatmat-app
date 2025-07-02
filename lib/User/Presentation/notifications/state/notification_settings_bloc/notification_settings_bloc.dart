import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/get_device_token_usecase.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/subscribe_to_topic_usecase.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/unsubscribe_to_topic_usecase.dart';

part 'notification_settings_event.dart';
part 'notification_settings_state.dart';

class NotificationSettingsBloc
    extends Bloc<NotificationSettingsEvent, NotificationSettingsState> {
  final GetDeviceTokenUsecase _getDeviceToken;
  final SubscribeToTopicUsecase _subscribeToTopic;
  final UnsubscribeToTopicUsecase _unsubscribeFromTopic;

  NotificationSettingsBloc({
    required GetDeviceTokenUsecase getDeviceToken,
    required SubscribeToTopicUsecase subscribeToTopic,
    required UnsubscribeToTopicUsecase unsubscribeFromTopic,
  })  : _getDeviceToken = getDeviceToken,
        _subscribeToTopic = subscribeToTopic,
        _unsubscribeFromTopic = unsubscribeFromTopic,
        super(NotificationSettingsInitial()) {
    on<GetDeviceToken>(_onGetDeviceToken);
    on<SubscribeToTopic>(_onSubscribeToTopic);
    on<UnsubscribeFromTopic>(_onUnsubscribeFromTopic);
  }

  Future<void> _onGetDeviceToken(
    GetDeviceToken event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    emit(NotificationSettingsLoading());
    final tokenResult = await _getDeviceToken();
    tokenResult.fold(
      (failure) =>
          emit(NotificationSettingsFailure("خطأ اثناء الحصول على توكن الجهاز")),
      (token) => emit(NotificationSettingsLoaded(deviceToken: token)),
    );
  }

  Future<void> _onSubscribeToTopic(
    SubscribeToTopic event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    final result = await _subscribeToTopic(topic: event.topic);
    result.fold(
      (failure) =>
          emit(NotificationSettingsFailure("خطأ اثناء الاشتراك في التوبيك")),
      (_) {
        if (state is NotificationSettingsLoaded) {
          final currentState = state as NotificationSettingsLoaded;
          final updatedTopics = List<String>.from(currentState.subscribedTopics)
            ..add(event.topic);
          emit(currentState.copyWith(subscribedTopics: updatedTopics));
        }
      },
    );
  }

  Future<void> _onUnsubscribeFromTopic(
    UnsubscribeFromTopic event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    final result = await _unsubscribeFromTopic(topic: event.topic);
    result.fold(
      (failure) => emit(
          NotificationSettingsFailure("خطأ اثناء الالغاء الاشتراك في التوبيك")),
      (_) {
        if (state is NotificationSettingsLoaded) {
          final currentState = state as NotificationSettingsLoaded;
          final updatedTopics = List<String>.from(currentState.subscribedTopics)
            ..remove(event.topic);
          emit(currentState.copyWith(subscribedTopics: updatedTopics));
        }
      },
    );
  }
}
