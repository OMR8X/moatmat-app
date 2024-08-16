import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/teacher_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../domain/entites/user_data.dart';
import '../../domain/repository/users_repository.dart';
import '../data_source/users_ds.dart';

class UserRepositoryImpl implements UserRepository {
  final UsersDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, UserData>> getUserData({required String uuid}) async {
    try {
      var res = await dataSource.getUserData(uuid: uuid);
      return right(res);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, UserData>> signIn({
    required String email,
    required String password,
  }) async {
    //
    try {
      var res = await dataSource.signIn(
        email: email,
        password: password,
      );
      return right(res);
    } on AuthException catch (e) {
      if (e.message == "Invalid login credentials") {
        return left(const InvalidDataFailure());
      }
      return left(const AnonFailure());
    } on Exception {
      return left(const AnonFailure());
    }
    //
  }

  @override
  Future<Either<Failure, UserData>> signUp({
    required UserData userData,
    required String password,
  }) async {
    //
    try {
      var res = await dataSource.signUp(
        userData: userData,
        password: password,
      );
      //
      return right(res);
    } on AuthException catch (e) {
      print(e);
      if (e.message.contains("User already registered")) {
        return left(const UserAlreadyExcitedFailure());
      } else if (e.message.contains("invalid format")) {
        return left(const InvalidDataFailure());
      }
      return left(const AnonFailure());
    } on Exception catch (e) {
      print(e);
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUserData({
    required UserData userData,
  }) async {
    try {
      var res = await dataSource.updateUserData(userData: userData);
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
      var res = await dataSource.resetPassword(
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
      var res = await dataSource.getTeacherData();
      return right(res);
    } on Exception {
      return left(const AnonFailure());
    }
  }
}
