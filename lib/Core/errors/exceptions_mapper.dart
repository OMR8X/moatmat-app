import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'failures.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'exceptions.dart';

extension ErrorsMapper on Exception {
  Failure get toFailure {
    debugPrint(toString());
    switch (runtimeType) {
      ///
      case DioException():
        return ServerFailure(message: (this as DioException).message);

      ///
      case TimeoutException():
        return TimeOutFailure(message: (this as TimeoutException).message);

      ///
      case ServerException():
        return ServerFailure(message: (this as ServerException).message);

      ///
      case AuthException():
        return AuthFailure(message: (this as AuthException).message);

      ///
      case CacheException():
        return CacheFailure(message: (this as CacheException).message);

      ///
      case FileNotExistsException():
        return FileNotExistsFailure(message: (this as FileNotExistsException).message);

      ///
      case ItemNotExistsException():
        return ItemNotExistsFailure(message: (this as ItemNotExistsException).message);

      ///
      case CacheEmptyException():
        return CacheFailure(message: (this as CacheEmptyException).message);

      ///
      case OfflineException():
        return OfflineFailure(message: (this as OfflineException).message);

      ///
      case NotFoundException():
        return ItemNotExistsFailure(message: (this as NotFoundException).message);

      ///
      case UnknownException():
        return UnknownFailure(message: (this as UnknownException).message);

      ///
      case NotEnoughBalanceException():
        return NotEnoughBalanceFailure(message: (this as NotEnoughBalanceException).message);

      ///
      case CodesUsedException():
        return CodesUsedFailure(message: (this as CodesUsedException).message);

      ///
      case CancelException():
        return CancelFailure(message: (this as CancelException).message);

      ///
      case NoDataException():
        return CacheFailure(message: (this as NoDataException).message);

      ///
      case FileNotFoundException():
        return FileNotFoundFailure(message: (this as FileNotFoundException).message);

      ///
      case UserNotFoundException():
        return MissingUserDataFailure(message: (this as UserNotFoundException).message);

      ///
      case FileAlreadySavedException():
        return FileNotExistsFailure(message: (this as FileAlreadySavedException).message);

      ///
      case EmptyCacheException():
        return CacheFailure(message: (this as EmptyCacheException).message);

      ///
      case LessonsDataBaseException():
        return CacheFailure(message: (this as LessonsDataBaseException).message);

      ///
      case UserAlreadyExcitedException():
        return UserAlreadyExistsFailure(message: (this as UserAlreadyExcitedException).message);

      ///
      case InvalidDataException():
        return InvalidDataFailure(message: (this as InvalidDataException).message);

      ///
      case WrongPasswordException():
        return WrongPasswordFailure(message: (this as WrongPasswordException).message);

      ///
      case CrossMaxSizeException():
        return ServerFailure(message: (this as CrossMaxSizeException).message);

      ///
      case InvalidCacheException():
        return InvalidCacheFailure(message: (this as InvalidCacheException).message);

      ///
      case MissingUserDataException():
        return MissingUserDataFailure(message: (this as MissingUserDataException).message);

      ///
      case AssetCacheException():
        return AssetCacheFailure(message: (this as AssetCacheException).message);

      ///
      case AssetDownloadException():
        return AssetDownloadFailure(message: (this as AssetDownloadException).message);

      ///
      case AssetNotExistsException():
        return AssetNotExistsFailure(message: (this as AssetNotExistsException).message);

      ///
      case AssetFileCorruptedException():
        return AssetFileCorruptedFailure(message: (this as AssetFileCorruptedException).message);

      ///
      case AssetInvalidUrlException():
        return AssetInvalidUrlFailure(message: (this as AssetInvalidUrlException).message);

      ///
      case supabase.PostgrestException():
        if ((this as supabase.PostgrestException).code == "22P02") {
          return InvalidDataFailure(message: (this as supabase.PostgrestException).message);
        } else {
          return ServerFailure(message: (this as supabase.PostgrestException).message);
        }

      ///
      default:
        return UnknownFailure(message: toString());
    }
  }
}
