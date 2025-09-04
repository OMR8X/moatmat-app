import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class FileNotExistsFailure extends Failure {
  static const String _defaultMessage = "الملف غير موجود";

  const FileNotExistsFailure({String? message}) : super(message ?? _defaultMessage);
}

class ItemNotExistsFailure extends Failure {
  static const String _defaultMessage = "العنصر غير موجود";

  const ItemNotExistsFailure({String? message}) : super(message ?? _defaultMessage);
}

class CanceledFailure extends Failure {
  static const String _defaultMessage = "تم الغاء العملية";

  const CanceledFailure({String? message}) : super(message ?? _defaultMessage);
}

class UnknownFailure extends Failure {
  static const String _defaultMessage = "حصل خطأ غير معروف";

  const UnknownFailure({String? message}) : super(message ?? _defaultMessage);
}

class CacheFailure extends Failure {
  static const String _defaultMessage = "حصل خطأ أثناء الاتصال بقاعدة البيانات.";

  const CacheFailure({String? message}) : super(message ?? _defaultMessage);
}

class ServerFailure extends Failure {
  static const String _defaultMessage = "حصل خطأ اثناء الاتصال بالخادم";

  const ServerFailure({String? message}) : super(message ?? _defaultMessage);
}

class TimeOutFailure extends Failure {
  static const String _defaultMessage = "انتهت فترة الاتصال بالخادم";

  const TimeOutFailure({String? message}) : super(message ?? _defaultMessage);
}

class AuthFailure extends Failure {
  static const String _defaultMessage = "حصل خطأ في المصادقة";
  const AuthFailure({String? message}) : super(message ?? _defaultMessage);
}

class NoInternetFailure extends Failure {
  static const String _defaultMessage = "لا يوجد اتصال بالانترنت";

  const NoInternetFailure() : super(_defaultMessage);
}

class ExitFailure extends Failure {
  static const String _defaultMessage = "تم الغاء العملية";

  const ExitFailure() : super(_defaultMessage);
}

class MissingPropertiesFailure extends Failure {
  static const String _defaultMessage = "يرجى ملء جميع الخانات المطلوبة";

  const MissingPropertiesFailure() : super(_defaultMessage);
}

class CancelFailure extends Failure {
  static const String _defaultMessage = "تم إلغاء العملية";

  const CancelFailure({String? message}) : super(message ?? _defaultMessage);
  @override
  List<Object?> get props => [];
}

class OfflineFailure extends Failure {
  static const String _defaultMessage = "لا يوجد اتصال بالإنترنت.";

  const OfflineFailure({String? message}) : super(message ?? _defaultMessage);
  @override
  List<Object?> get props => [];
}

class WrongPasswordFailure extends Failure {
  static const String _defaultMessage = "خطأ في كلمة المرور.";

  const WrongPasswordFailure({String? message}) : super(message ?? _defaultMessage);
  @override
  List<Object?> get props => [];
}

class UserAlreadyExistsFailure extends Failure {
  static const String _defaultMessage = "الحساب موجود بالفعل.";

  const UserAlreadyExistsFailure({String? message}) : super(message ?? _defaultMessage);
  @override
  List<Object?> get props => [];
}

class CodesUsedFailure extends Failure {
  static const String _defaultMessage = "تم استخدام الكود مسبقا";

  const CodesUsedFailure({String? message}) : super(message ?? _defaultMessage);
  @override
  List<Object?> get props => [];
}

class InvalidDataFailure extends Failure {
  static const String _defaultMessage = "خطأ في البيانات المدخلة.!";

  const InvalidDataFailure({String? message}) : super(message ?? _defaultMessage);
  @override
  List<Object?> get props => [];
}

class NotEnoughBalanceFailure extends Failure {
  static const String _defaultMessage = "لا يوجد رصيد كافي لاتمام عملية الشراء.!";

  const NotEnoughBalanceFailure({String? message}) : super(message ?? _defaultMessage);
  @override
  List<Object?> get props => [];
}

class MissingUserDataFailure extends Failure {
  static const String _defaultMessage = "لم يتم العثور على معلومات المستخدم.!";

  const MissingUserDataFailure({String? message}) : super(message ?? _defaultMessage);
  @override
  List<Object?> get props => [];
}

class FileNotFoundFailure extends Failure {
  static const String _defaultMessage = "لم يتم العثور على الملف المطلوب.";

  const FileNotFoundFailure({String? message}) : super(message ?? _defaultMessage);
  @override
  List<Object?> get props => [];
}

class AssetNotExistsFailure extends Failure {
  static const String _defaultMessage = "ملف تالف او غير موجود.";

  const AssetNotExistsFailure({String? message}) : super(message ?? _defaultMessage);
  @override
  List<Object?> get props => [];
}

// Asset caching specific failures
class AssetCacheFailure extends Failure {
  static const String _defaultMessage = "حدث خطأ أثناء حفظ الملف في ذاكرة التخزين المؤقت.";

  const AssetCacheFailure({String? message}) : super(message ?? _defaultMessage);
  @override
  List<Object?> get props => [];
}

class AssetDownloadFailure extends Failure {
  static const String _defaultMessage = "حدث خطأ أثناء تحميل الملف من الإنترنت.";

  const AssetDownloadFailure({String? message}) : super(message ?? _defaultMessage);
  @override
  List<Object?> get props => [];
}

class AssetFileCorruptedFailure extends Failure {
  static const String _defaultMessage = "الملف المحفوظ تالف أو غير قابل للقراءة.";

  const AssetFileCorruptedFailure({String? message}) : super(message ?? _defaultMessage);
  @override
  List<Object?> get props => [];
}

class AssetInvalidUrlFailure extends Failure {
  static const String _defaultMessage = "رابط الملف غير صحيح أو غير صالح.";

  const AssetInvalidUrlFailure({String? message}) : super(message ?? _defaultMessage);
  @override
  List<Object?> get props => [];
}

class InvalidCacheFailure extends Failure {
  static const String _defaultMessage = "لم يتم حفظ اي محتويات.";

  const InvalidCacheFailure({String? message}) : super(message ?? _defaultMessage);
  @override
  List<Object?> get props => [];
}
