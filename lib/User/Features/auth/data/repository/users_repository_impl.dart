import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_app/User/Features/auth/data/data_source/users_local_ds.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/teacher_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../main.dart';
import '../../../../Core/errors/exceptions.dart';
import '../../domain/entites/user_data.dart';
import '../../domain/repository/users_repository.dart';
import '../data_source/users_remote_ds.dart';

class UserRepositoryImpl implements UserRepository {
  final UsersRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({required this.remoteDataSource, required this.localDataSource});
  @override
  Future<Either<Failure, UserData>> getUserData({
    required String uuid,
    bool update = false,
    bool force = false,
  }) async {
    try {
      //
      if (update) throw Exception();
      //
      final response = await localDataSource.getUserData(uuid: uuid, force: force);
      //
      return right(response);
      //
    } catch (e) {
      //
      try {
        //
        var res = await remoteDataSource.getUserData(uuid: uuid);
        //
        return right(res);
      } on MissingUserDataException {
        return left(const MissingUserDataFailure());
      } on Exception catch (e) {
        debugPrint(e.toString());
        return left(const AnonFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      var res = await remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return right(res);
    } on AuthException catch (e) {
      if (e.message == "Invalid login credentials") {
        return left(const InvalidDataFailure());
      }
      return left(const AnonFailure());
    } on MissingUserDataException {
      return left(const MissingUserDataFailure());
    } on Exception {
      return left(const AnonFailure());
    }
    //
  }

  @override
  Future<Either<Failure, Unit>> signUp({
    required UserData userData,
    required String password,
  }) async {
    //
    try {
      var res = await remoteDataSource.signUp(
        userData: userData,
        password: password,
      );
      //
      return right(res);
    } on AuthException catch (e) {
      if (e.message.contains("User already registered")) {
        return left(const UserAlreadyExcitedFailure());
      } else if (e.message.contains("invalid format")) {
        return left(const InvalidDataFailure());
      }
      return left(const AnonFailure());
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUserData({
    required UserData userData,
  }) async {
    try {
      var res = await remoteDataSource.updateUserData(userData: userData);
      return right(res);
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String password,
    required String token,
  }) async {
    try {
      var res = await remoteDataSource.resetPassword(
        email: email,
        password: password,
        token: token,
      );
      return right(res);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, TeacherData>> getTeacherData() async {
    try {
      var res = await remoteDataSource.getTeacherData();
      return right(res);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> insertUserData({required UserData userData}) async {
    try {
      var res = await remoteDataSource.insertUserData(userData: userData);
      return right(res);
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> startSignInWithGoogle() async {
    try {
      var res = await remoteDataSource.startSignInWithGoogle();
      return right(res);
    } on CancelException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return left(const CancelFailure());
    } on MissingUserDataException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return left(const MissingUserDataFailure());
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      var res = await remoteDataSource.signOut();
      return right(res);
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }
}
