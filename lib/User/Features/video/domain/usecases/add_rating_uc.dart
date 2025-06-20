import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/rating.dart';
import 'package:moatmat_app/User/Features/video/domain/repository/video_repository.dart';

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
