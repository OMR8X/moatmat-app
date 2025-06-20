import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/comment.dart';
import 'package:moatmat_app/User/Features/video/domain/usecases/add_comment_uc.dart';
import 'package:moatmat_app/User/Features/video/domain/usecases/get_comments_uc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentInitial());

  init(int videoId) {
    emit(CommentLoadind());
    //
    // emit(CommentLoaded(comments: [
    //   ...List.generate(10, (index) {
    //     return Comment(
    //       id: index,
    //       comment: "comment $index",
    //       username: "username $index",
    //       userId: Supabase.instance.client.auth.currentUser!.id,
    //       likes: 0,
    //       videoId: 1,
    //       repliesNum: 0,
    //       createdAt: "2025-06-18 20:48:34.569287",
    //     );
    //   }),
    // ]));
    //
    locator<GetCommentsUc>().call(videoId: videoId).then((value) {
      value.fold(
        (l) {
          emit(CommentError(msg: l.text));
        },
        (r) {
          emit(CommentLoaded(comments: r));
        },
      );
    });
  }

  addComment({required String commentText, required int videoId}) {
    Comment comment = Comment(
      comment: commentText,
      userId: Supabase.instance.client.auth.currentUser!.id,
      videoId: videoId,
      id: -1,
      likes: 0,
      repliesNum: 0,
      username: '1',
      createdAt: "",
    );
    locator<AddCommentUc>().call(comment: comment);
  }
}
