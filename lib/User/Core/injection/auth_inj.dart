
import '../../Features/auth/data/data_source/users_ds.dart';
import '../../Features/auth/data/repository/users_repository_impl.dart';
import '../../Features/auth/domain/repository/users_repository.dart';
import '../../Features/auth/domain/use_cases/get_user_data.dart';
import '../../Features/auth/domain/use_cases/reset_password_uc.dart';
import '../../Features/auth/domain/use_cases/sign_in_uc.dart';
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
  locator.registerFactory<SignUpUC>(
    () => SignUpUC(
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
}

void injectRepo() {
  locator.registerFactory<UserRepository>(
    () => UserRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<UsersDataSource>(
    () => UsersDataSourceImpl(client: locator()),
  );
}
