import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/video/domain/usecases/get_my_rating_uc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'my_rating_to_video_state.dart';

class MyRatingToVideoCubit extends Cubit<MyRatingToVideoState> {
  MyRatingToVideoCubit() : super(MyRatingToVideoInitial());

  init({required int videoId}) {
    emit(MyRatingToVideoLoading());
    var user = Supabase.instance.client.auth.currentUser;
    locator<GetMyRatingUc>().call(videoId: 1, userId: user!.id).then((value) {
      value.fold(
        (l) {
          emit(MyRatingToVideoError(msg: l.text));
        },
        (r) {
          emit(MyRatingToVideoLoaded(myRating: r.rating));
        },
      );
    });
  }
}
