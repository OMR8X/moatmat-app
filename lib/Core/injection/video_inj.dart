import 'package:moatmat_app/Core/injection/app_inj.dart';
import 'package:moatmat_app/Features/video/data/datasources/remote_data_source.dart';
import 'package:moatmat_app/Features/video/data/repository/video_repository.dart';
import 'package:moatmat_app/Features/video/domain/repository/video_repository.dart';
import 'package:moatmat_app/Features/video/domain/usecases/add_comment_uc.dart';
import 'package:moatmat_app/Features/video/domain/usecases/add_rating_uc.dart';
import 'package:moatmat_app/Features/video/domain/usecases/add_reply_comment_uc.dart';
import 'package:moatmat_app/Features/video/domain/usecases/add_video_uc.dart';
import 'package:moatmat_app/Features/video/domain/usecases/get_comments_uc.dart';
import 'package:moatmat_app/Features/video/domain/usecases/get_my_rating_uc.dart';
import 'package:moatmat_app/Features/video/domain/usecases/get_rating_uc.dart';
import 'package:moatmat_app/Features/video/domain/usecases/get_replies_uc.dart';
import 'package:moatmat_app/Features/video/domain/usecases/get_video_uc.dart';
import 'package:moatmat_app/Features/video/domain/usecases/set_as_viewed_video_uc.dart';

injectVideo() {
  injectUC();
  injectRepo();
  injectDS();
}

void injectUC() {
  locator.registerFactory<AddVideoUc>(
    () => AddVideoUc(
      repository: locator(),
    ),
  );
  locator.registerFactory<AddCommentUc>(
    () => AddCommentUc(
      repository: locator(),
    ),
  );
  locator.registerFactory<AddRatingUc>(
    () => AddRatingUc(
      repository: locator(),
    ),
  );
  locator.registerFactory<AddReplyCommentUc>(
    () => AddReplyCommentUc(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetVideoUc>(
    () => GetVideoUc(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetCommentsUc>(
    () => GetCommentsUc(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetMyRatingUc>(
    () => GetMyRatingUc(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetRatingUc>(
    () => GetRatingUc(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetRepliesUc>(
    () => GetRepliesUc(
      repository: locator(),
    ),
  );
  locator.registerFactory<SetAsViewedVideoUc>(
    () => SetAsViewedVideoUc(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<VideoRepository>(
    () => VideoRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<VideoRemoteDataSource>(
    () => VideoRemoteDataSourceImpl(
      client: locator(),
    ),
  );
}
