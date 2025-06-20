import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/video.dart';
import 'package:moatmat_app/User/Features/video/domain/usecases/get_video_uc.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit() : super(VideoInitial());
  init(int videoId) {
    emit(VideoLoading());
    locator<GetVideoUc>().call(videoId: videoId).then((value) {
      value.fold(
        (l1) {
          emit(VideoError(msg: l1.text));
        },
        (r1) {
          emit(VideoLoaded(video: r1));
        },
      );
    });
  }
}
