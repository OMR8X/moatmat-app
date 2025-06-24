import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/notifications2/data/datasources/ds.dart';
import 'package:moatmat_app/User/Features/notifications2/domain/entities/notifications_data.dart';
import 'package:moatmat_app/User/Features/notifications2/domain/repository/repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsDataSource dataSource;

  NotificationsRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<NotificationData>>> getNotifications() async {
    try {
      var res = await dataSource.getNotifications();
      return right(res);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  bool isThereNewNotifications(
    List<NotificationData> notifications,
  ) {
    var res = dataSource.isThereNewNotifications(notifications);
    return (res);
  }

  @override
  void readNotifications(List<NotificationData> notifications) {
    dataSource.readNotifications(notifications);
  }
}
