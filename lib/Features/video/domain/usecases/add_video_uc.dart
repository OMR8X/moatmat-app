import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/video/domain/entites/video.dart';
import 'package:moatmat_app/Features/video/domain/repository/video_repository.dart';

class AddVideoUc {
  final VideoRepository repository;

  AddVideoUc({required this.repository});

  Future<Either<Failure, int>> call({
    required Video video,
  }) async {
    return await repository.addVideo(
      video: video,
    );
  }
}
