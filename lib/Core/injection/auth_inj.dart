import 'package:moatmat_app/Features/auth/domain/use_cases/get_teacher_data.dart';
import 'package:moatmat_app/Features/auth/domain/use_cases/sign_in_with_google_uc.dart';

import '../../Features/auth/data/data_source/users_local_ds.dart';
import '../../Features/auth/data/data_source/users_remote_ds.dart';
import '../../Features/auth/data/repository/users_repository_impl.dart';
import '../../Features/auth/domain/repository/users_repository.dart';
import '../../Features/auth/domain/use_cases/enter_user_data_uc.dart';
import '../../Features/auth/domain/use_cases/get_user_data.dart';
import '../../Features/auth/domain/use_cases/reset_password_uc.dart';
import '../../Features/auth/domain/use_cases/sign_in_uc.dart';
import '../../Features/auth/domain/use_cases/sign_out_uc.dart';
import '../../Features/auth/domain/use_cases/sign_up_uc.dart';
import '../../Features/auth/domain/use_cases/update_user_data_uc.dart';
import 'app_inj.dart';

injectAuth() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<SignInUC>(
    () => SignInUC(
      repository: locator(),
    ),
  );

  locator.registerFactory<SignInUCWithGoogleUC>(
    () => SignInUCWithGoogleUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<SignUpUC>(
    () => SignUpUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<SignOutUC>(
    () => SignOutUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetUserDataUC>(
    () => GetUserDataUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<UpdateUserDataUC>(
    () => UpdateUserDataUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<ResetPasswordUC>(
    () => ResetPasswordUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetTeacherDataUC>(
    () => GetTeacherDataUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<InsertUserData>(
    () => InsertUserData(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<UsersRemoteDataSource>(
    () => UsersRemoteDataSourceImpl(
      client: locator(),
      cacheManager: locator(),
    ),
  );
  locator.registerFactory<UserLocalDataSource>(
    () => UserLocalDataSourceImplement(
      cacheManager: locator(),
    ),
  );
}
