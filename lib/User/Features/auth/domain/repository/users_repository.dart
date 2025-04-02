import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';

import '../entites/teacher_data.dart';
import '../entites/user_data.dart';

abstract class UserRepository {
  // signIn
  Future<Either<Failure, Unit>> signIn({
    required String email,
    required String password,
  });
  // signUp
  Future<Either<Failure, Unit>> signUp({
    required UserData userData,
    required String password,
  });
  //
  Future<Either<Failure, Unit>> signOut();
  // sign In with google
  Future<Either<Failure, Unit>> startSignInWithGoogle();
  //
  // update User Data
  Future<Either<Failure, Unit>> updateUserData({
    required UserData userData,
  });

  Future<Either<Failure, Unit>> insertUserData({
    required UserData userData,
  });
  //
  // get User Data
  Future<Either<Failure, UserData>> getUserData({
    required String uuid,
    bool update = false,
  });
  //

  //
  // get Teacher Data
  Future<Either<Failure, TeacherData>> getTeacherData();
  //
  // get User Data
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String password,
    required String token,
  });
}
