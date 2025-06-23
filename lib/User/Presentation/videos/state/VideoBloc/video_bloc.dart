import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/User/Features/auth/domain/use_cases/get_user_data.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/comment.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/rating.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/reply_comment.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/video.dart';
import 'package:moatmat_app/User/Features/video/domain/usecases/add_comment_uc.dart';
import 'package:moatmat_app/User/Features/video/domain/usecases/add_rating_uc.dart';
import 'package:moatmat_app/User/Features/video/domain/usecases/add_reply_comment_uc.dart';
import 'package:moatmat_app/User/Features/video/domain/usecases/get_comments_uc.dart';
import 'package:moatmat_app/User/Features/video/domain/usecases/get_my_rating_uc.dart';
import 'package:moatmat_app/User/Features/video/domain/usecases/get_replies_uc.dart';
import 'package:moatmat_app/User/Features/video/domain/usecases/get_video_uc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(VideoState()) {
    on<LoadVideo>(_onLoadVideoPage);
    on<LoadComments>(_onLoadComment);
    on<AddComment>(_onAddComment);
    on<AddReply>(_onAddReply);
    on<LoadReplies>(_onLoadReplies);
    on<AddRating>(_onAddRating);
  }
  //
  Future<void> _onLoadVideoPage(LoadVideo event, Emitter<VideoState> emit) async {
    var updatedLoadingMap = Map<Loading, bool>.from(state.isLoading);
    //
    updatedLoadingMap[Loading.video] = true;
    updatedLoadingMap[Loading.rating] = true;
    //
    emit(state.copyWith(isLoading: updatedLoadingMap, errorMsg: null));
    //
    try {
      //
      var user = Supabase.instance.client.auth.currentUser;
      //
      final myRatingRes = await locator<GetMyRatingUc>().call(
        videoId: event.videoId,
        userId: user!.id,
      );
      //
      final videoRes = await locator<GetVideoUc>().call(videoId: event.videoId);
      //
      if (videoRes.isLeft() || myRatingRes.isLeft()) {
        //
        updatedLoadingMap = Map<Loading, bool>.from(state.isLoading);
        //
        updatedLoadingMap[Loading.video] = false;
        updatedLoadingMap[Loading.rating] = false;
        //
        emit(state.copyWith(isLoading: updatedLoadingMap, errorMsg: "Error loading video page"));
        return;
      }
      //
      final video = videoRes.getOrElse(() => throw Exception());
      final myRating = myRatingRes.getOrElse(() => throw Exception());
      //
      updatedLoadingMap = Map<Loading, bool>.from(state.isLoading);
      //
      updatedLoadingMap[Loading.video] = false;
      updatedLoadingMap[Loading.rating] = false;
      //
      emit(state.copyWith(
        isLoading: updatedLoadingMap,
        errorMsg: null,
        video: video,
        myRating: myRating,
      ));
      //
    } catch (e) {
      updatedLoadingMap = Map<Loading, bool>.from(state.isLoading);
      //
      updatedLoadingMap[Loading.video] = false;
      updatedLoadingMap[Loading.rating] = false;
      //
      emit(state.copyWith(isLoading: updatedLoadingMap, errorMsg: e.toString()));
    }
  }

  //
  Future<void> _onLoadComment(LoadComments event, Emitter<VideoState> emit) async {
    var updatedLoadingMap = Map<Loading, bool>.from(state.isLoading);
    //
    updatedLoadingMap[Loading.comment] = true;
    //
    emit(state.copyWith(isLoading: updatedLoadingMap, errorMsg: null));
    //
    try {
      final commentRes = await locator<GetCommentsUc>().call(videoId: event.videoId);
      //
      commentRes.fold(
        (l) {
          updatedLoadingMap = Map<Loading, bool>.from(state.isLoading);
          //
          updatedLoadingMap[Loading.comment] = false;
          //
          emit(state.copyWith(isLoading: updatedLoadingMap, errorMsg: l.text));
        },
        (r) {
          updatedLoadingMap = Map<Loading, bool>.from(state.isLoading);
          //
          updatedLoadingMap[Loading.comment] = false;
          //
          emit(state.copyWith(
            isLoading: updatedLoadingMap,
            comments: r,
            errorMsg: null,
          ));
        },
      );
    } catch (e) {
      updatedLoadingMap = Map<Loading, bool>.from(state.isLoading);
      //
      updatedLoadingMap[Loading.comment] = false;
      //
      emit(state.copyWith(errorMsg: e.toString(), isLoading: updatedLoadingMap));
    }
  }

  //
  Future<void> _onAddComment(AddComment event, Emitter<VideoState> emit) async {
    //
    var user = Supabase.instance.client.auth.currentUser;
    //
    UserData? u = await locator<GetUserDataUC>().call(uuid: user!.id).then((val) {
      val.fold((l) {}, (r) => r);
      return null;
    });
    //
    final Comment comment = Comment(
      id: -1,
      comment: event.commentText,
      username: u?.name ?? "",
      userId: user.id,
      likes: 0,
      videoId: state.video!.id,
      repliesNum: 0,
      createdAt: DateTime.now().toString(),
    );
    //
    await locator<AddCommentUc>().call(comment: comment);
    //
    add(LoadComments(videoId: event.videoId));
  }

  //
  Future<void> _onAddReply(AddReply event, Emitter<VideoState> emit) async {
    emit(state.copyWith(
      loadingRepliesForComments: {...state.loadingRepliesForComments, event.commentId},
      addReplies: true,
    ));
    //
    var user = Supabase.instance.client.auth.currentUser;
    //
    final uRes = await locator<GetUserDataUC>().call(uuid: user!.id);
    //
    UserData? u;
    //
    uRes.fold((l) => null, (r) => u = r);
    //
    final ReplyComment reply = ReplyComment(
      id: -1,
      comment: event.replyText,
      commentId: event.commentId,
      username: u?.name ?? "",
      userId: user.id,
      likes: 0,
      createdAt: DateTime.now().toString(),
    );
    //
    final replyRes = await locator<AddReplyCommentUc>().call(replyComment: reply);
    //
    replyRes.fold(
      (l) {
        emit(state.copyWith(
          errorMsg: l.text,
          loadingRepliesForComments: state.loadingRepliesForComments..remove(event.commentId),
          addReplies: false,
        ));
      },
      (r) {
        final updatedMap = Map<int, List<ReplyComment>>.from(state.repliesMap);
        //
        updatedMap[event.commentId] = [
          ...updatedMap[event.commentId] ?? [],
          reply,
        ];
        //
        final updatedComments = [...state.comments!];
        final index = updatedComments.indexWhere((e) => e.id == event.commentId);
        if (index != -1) {
          updatedComments[index] = updatedComments[index].copyWith(
            repliesNum: (state.repliesMap[event.commentId]?.length ?? 0) + 1,
          );
        }
        //
        emit(state.copyWith(
          repliesMap: updatedMap,
          comments: updatedComments,
          loadingRepliesForComments: state.loadingRepliesForComments..remove(event.commentId),
          addReplies: false,
        ));
      },
    );
  }

  //
  Future<void> _onLoadReplies(LoadReplies event, Emitter<VideoState> emit) async {
    var updatedLoadingMap = Map<Loading, bool>.from(state.isLoading);
    //
    updatedLoadingMap[Loading.replies] = true;
    //
    emit(state.copyWith(
      isLoading: updatedLoadingMap,
      loadingRepliesForComments: {...state.loadingRepliesForComments, event.commentId},
    ));
    //
    final replyRes = await locator<GetRepliesUc>().call(commentId: event.commentId);
    //
    replyRes.fold(
      (l) {
        updatedLoadingMap = Map<Loading, bool>.from(state.isLoading);
        //
        updatedLoadingMap[Loading.replies] = false;
        //
        emit(state.copyWith(
          errorMsg: l.text,
          isLoading: updatedLoadingMap,
          loadingRepliesForComments: state.loadingRepliesForComments..remove(event.commentId),
        ));
      },
      (r) {
        final updatedMap = Map<int, List<ReplyComment>>.from(state.repliesMap);
        //
        updatedMap[event.commentId] = r;
        //
        //
        final updatedComments = [...state.comments!];
        //
        final index = updatedComments.indexWhere((e) => e.id == event.commentId);
        //
        if (index != -1) {
          updatedComments[index] = updatedComments[index].copyWith(
            repliesNum: (state.repliesMap[event.commentId]?.length ?? 0) + 1,
          );
        }
        //
        updatedLoadingMap = Map<Loading, bool>.from(state.isLoading);
        //
        updatedLoadingMap[Loading.replies] = false;
        //
        emit(state.copyWith(
          repliesMap: updatedMap,
          isLoading: updatedLoadingMap,
          loadingRepliesForComments: state.loadingRepliesForComments..remove(event.commentId),
          comments: updatedComments,
        ));
      },
    );
  }

  FutureOr<void> _onAddRating(AddRating event, Emitter<VideoState> emit) async {
    var user = Supabase.instance.client.auth.currentUser;
    //
    final rating = Rating(
      videoId: event.videoId,
      userId: user!.id,
      rating: event.rating,
      comment: '',
      createdAt: '',
      id: -1,
      username: '',
    );
    //
    final res = await locator<AddRatingUc>().call(rating: rating);
    //
    res.fold(
      (l) => emit(state.copyWith(errorMsg: l.text)),
      (r) {
        final updatedVideo = state.video!.copyWith(
          rating: _calculateNewAverage(state.video!.rating, state.video!.ratingNum, event.rating),
          ratingNum: state.video!.ratingNum + 1,
        );
        emit(state.copyWith(myRating: rating, video: updatedVideo));
      },
    );
  }

  double _calculateNewAverage(double currentAvg, int currentNum, int newRating) {
    return ((currentAvg * currentNum) + newRating) / (currentNum + 1);
  }
}
