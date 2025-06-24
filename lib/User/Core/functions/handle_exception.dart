import 'package:moatmat_app/User/Core/errors/exceptions.dart';

Failure handleException(Exception exception) {
  if (exception is OfflineException) {
    return const OfflineFailure();
  } else if (exception is WrongPasswordException) {
    return const WrongPasswordFailure();
  } else if (exception is UserAlreadyExcitedException) {
    return const UserAlreadyExcitedFailure();
  } else if (exception is CodesUsedException) {
    return const CodesUsedFailure();
  } else if (exception is ServerException) {
    return const ServerFailure();
  } else if (exception is InvalidDataException) {
    return const InvalidDataFailure();
  } else if (exception is NotEnoughBalanceException) {
    return const NotEnoughtBalaneFailure();
  } else if (exception is MissingUserDataException) {
    return const MissingUserDataFailure();
  } else if (exception is CancelException) {
    return const CancelFailure();
  } else if (exception is UserNotFoundException) {
    return const MissingUserDataFailure();
  } else {
    return const AnonFailure();
  }
}

