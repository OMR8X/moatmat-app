import 'dart:core';

class ServerException implements Exception {
  final String? message;
  const ServerException({this.message});
}

class AuthException implements Exception {
  final String? message;
  const AuthException({this.message});
}

class FileNotExistsException implements Exception {
  final String? message;
  const FileNotExistsException({this.message});
}

class ItemNotExistsException implements Exception {
  final String? message;
  const ItemNotExistsException({this.message});
}

class CacheException implements Exception {
  final String? message;
  const CacheException({this.message});
}

class CacheEmptyException implements Exception {
  final String? message;
  const CacheEmptyException({this.message});
}

class OfflineException implements Exception {
  final String? message;
  const OfflineException({this.message});
}

class NotFoundException implements Exception {
  final String? message;
  const NotFoundException({this.message});
}

class AnonException implements Exception {
  final String? message;
  const AnonException({this.message});
}

class NotEnoughBalanceException implements Exception {
  final String? message;
  const NotEnoughBalanceException({this.message});
}

class CodesUsedException implements Exception {
  final String? message;
  const CodesUsedException({this.message});
}

class CancelException implements Exception {
  final String? message;
  const CancelException({this.message});
}

class NoDataException implements Exception {
  final String? message;
  const NoDataException({this.message});
}

class FileNotFoundException implements Exception {
  final String? message;
  const FileNotFoundException({this.message});
}

class UserNotFoundException implements Exception {
  final String? message;
  const UserNotFoundException({this.message});
}

class FileAlreadySavedException implements Exception {
  final String? message;
  const FileAlreadySavedException({this.message});
}

class EmptyCacheException implements Exception {
  final String? message;
  const EmptyCacheException({this.message});
}

class LessonsDataBaseException implements Exception {
  final String? message;
  const LessonsDataBaseException({this.message});
}

class UserAlreadyExcitedException implements Exception {
  final String? message;
  const UserAlreadyExcitedException({this.message});
}

class InvalidDataException implements Exception {
  final String? message;
  const InvalidDataException({this.message});
}

class WrongPasswordException implements Exception {
  final String? message;
  const WrongPasswordException({this.message});
}

class CrossMaxSizeException implements Exception {
  final String? message;
  const CrossMaxSizeException({this.message});
}

class InvalidCacheException implements Exception {
  final String? message;
  const InvalidCacheException({this.message});
}

class MissingUserDataException implements Exception {
  final String? message;
  const MissingUserDataException({this.message});
}

class AssetCacheException implements Exception {
  final String? message;
  const AssetCacheException({this.message});
}

class AssetDownloadException implements Exception {
  final String? message;
  const AssetDownloadException({this.message});
}

class AssetNotExistsException implements Exception {
  final String? message;
  const AssetNotExistsException({this.message});
}

class AssetFileCorruptedException implements Exception {
  final String? message;
  const AssetFileCorruptedException({this.message});
}

class AssetInvalidUrlException implements Exception {
  final String? message;
  const AssetInvalidUrlException({this.message});
}
