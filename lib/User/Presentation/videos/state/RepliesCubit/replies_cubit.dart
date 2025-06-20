import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/reply_comment.dart';
import 'package:moatmat_app/User/Features/video/domain/usecases/get_replies_uc.dart';

part 'replies_state.dart';

class RepliesCubit extends Cubit<RepliesState> {
  RepliesCubit() : super(RepliesInitial());

  init({required int commentId}) async {
    emit(RepliesLoading());
    locator<GetRepliesUc>().call(commentId: commentId).then((val) {
      val.fold(
        (l) => emit(RepliesError(msg: l.text)),
        (r) => emit(RepliesLoaded(replies: r)),
      );
    });
  }
}
