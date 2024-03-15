part of 'exceptions.dart';

abstract class Failure extends Equatable {
  final String text;

  const Failure(this.text);
}

class AnonFailure extends Failure {
  const AnonFailure() : super("حدث خطأ غير معروف");
  @override
  List<Object?> get props => [];
}

class OfflineFailure extends Failure {
  const OfflineFailure() : super("لا يوجد اتصال بالإنترنت.");
  @override
  List<Object?> get props => [];
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure() : super("خطأ في كلمة المرور.");
  @override
  List<Object?> get props => [];
}

class UserAlreadyExcitedFailure extends Failure {
  const UserAlreadyExcitedFailure() : super("الحساب موجود بالفعل.");
  @override
  List<Object?> get props => [];
}

class CodesUsedFailure extends Failure {
  const CodesUsedFailure() : super("تم استخدام الكود مسبقا");
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  const ServerFailure() : super("حدث خطأ أثناء الاتصال بالخادم.");
  @override
  List<Object?> get props => [];
}

class InvalidDataFailure extends Failure {
  const InvalidDataFailure() : super("خطأ في البيانات المدخلة.!");
  @override
  List<Object?> get props => [];
}

class NotEnoughtBalaneFailure extends Failure {
  const NotEnoughtBalaneFailure()
      : super("لا يوجد رصيد كافي لاتمام عملية الشراء.!");
  @override
  List<Object?> get props => [];
}
