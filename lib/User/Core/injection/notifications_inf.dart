import 'package:moatmat_app/User/Features/notifications/data/datasources/ds.dart';
import 'package:moatmat_app/User/Features/notifications/data/repository/repository.dart';
import 'package:moatmat_app/User/Features/notifications/domain/repository/repository.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/get_notifications_uc.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/is_there_new_notifications_uc.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/read_notifications_uc.dart';
import 'app_inj.dart';

injectNotifications() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<GetNotificationsUC>(
    () => GetNotificationsUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<IsThereNewNotificationsUC>(
    () => IsThereNewNotificationsUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<ReadNotificationsUC>(
    () => ReadNotificationsUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<NotificationsRepository>(
    () => NotificationsRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<NotificationsDataSource>(
    () => NotificationsDataSourceImpl(client: locator(), sp: locator()),
  );
}
