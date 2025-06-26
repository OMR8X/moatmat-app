import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/video.dart';
import 'package:moatmat_app/User/Features/video/domain/repository/video_repository.dart';

class AddVideoUc {
  final VideoRepository repository;

  AddVideoUc({required this.repository});

  Future<Either<Failure, Unit>> call({
    required Video video,
  }) async {
    return await repository.addVideo(
      video: video,
    );
  }
}
