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

class CacheFailure extends Failure {
  const CacheFailure() : super("حدث خطأ أثناء الاتصال بقاعدة البيانات.");
  @override
  List<Object?> get props => [];
}

class CancelFailure extends Failure {
  const CancelFailure() : super("تم إلغاء العملية");
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
  const NotEnoughtBalaneFailure() : super("لا يوجد رصيد كافي لاتمام عملية الشراء.!");
  @override
  List<Object?> get props => [];
}

class MissingUserDataFailure extends Failure {
  const MissingUserDataFailure() : super("لم يتم العثور على معلومات المستخدم.!");
  @override
  List<Object?> get props => [];
}

class FileNotFoundFailure extends Failure {
  const FileNotFoundFailure() : super("لم يتم العثور على الملف المطلوب.");
  @override
  List<Object?> get props => [];
}

class AssetNotExistsFailure extends Failure {
  const AssetNotExistsFailure() : super("ملف تالف او غير موجود.");
  @override
  List<Object?> get props => [];
}

// Asset caching specific failures
class AssetCacheFailure extends Failure {
  const AssetCacheFailure() : super("حدث خطأ أثناء حفظ الملف في ذاكرة التخزين المؤقت.");
  @override
  List<Object?> get props => [];
}

class AssetDownloadFailure extends Failure {
  const AssetDownloadFailure() : super("حدث خطأ أثناء تحميل الملف من الإنترنت.");
  @override
  List<Object?> get props => [];
}

class AssetFileCorruptedFailure extends Failure {
  const AssetFileCorruptedFailure() : super("الملف المحفوظ تالف أو غير قابل للقراءة.");
  @override
  List<Object?> get props => [];
}

class AssetInvalidUrlFailure extends Failure {
  const AssetInvalidUrlFailure() : super("رابط الملف غير صحيح أو غير صالح.");
  @override
  List<Object?> get props => [];
}

class InvalidCacheFailure extends Failure {
  const InvalidCacheFailure() : super("لم يتم حفظ اي محتويات.");
  @override
  List<Object?> get props => [];
}
