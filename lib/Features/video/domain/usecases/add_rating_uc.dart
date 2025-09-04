import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/video/domain/entites/rating.dart';
import 'package:moatmat_app/Features/video/domain/repository/video_repository.dart';

class AddRatingUc {
  final VideoRepository repository;

  AddRatingUc({required this.repository});

  Future<Either<Failure, Unit>> call({
    required Rating rating,
  }) async {
    return await repository.addRaing(
      rating: rating,
    );
  }
}
