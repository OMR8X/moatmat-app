import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Core/services/cache/cache_manager.dart';
import 'package:moatmat_app/User/Core/services/device_s.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_like.dart';
import 'package:moatmat_app/User/Features/auth/domain/use_cases/sign_in_with_google_uc.dart';
import 'package:moatmat_app/User/Features/auth/domain/use_cases/sign_out_uc.dart';
import 'package:moatmat_app/User/Features/auth/domain/use_cases/update_user_data_uc.dart';
import 'package:moatmat_app/User/Features/notifications/domain/requests/register_device_token_request.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/get_device_token_usecase.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/register_device_token_usecase.dart';
import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';
import 'package:moatmat_app/User/Features/purchase/domain/use_cases/get_user_purchased_uc.dart';
import 'package:moatmat_app/User/Features/update/domain/entites/update_info.dart';
import 'package:moatmat_app/User/Features/update/domain/usecases/check_update_state_uc.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/auth/domain/entites/user_data.dart';
import '../../../../Features/auth/domain/use_cases/get_user_data.dart';
part 'auth_cubit_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthLoading());
  //
  bool didCheckUpdate = false;
  Timer? timer;
  //
  init() async {
    //
    emit(AuthLoading());
    //
    if (timer != null && (timer?.isActive ?? false)) {
      timer?.cancel();
    }
    timer = Timer.periodic(
      const Duration(seconds: 60),
      (t) {
        onCheck();
      },
    );

    //
    var user = Supabase.instance.client.auth.currentUser;
    //
    if (didCheckUpdate) {
      if (user == null) {
        //
        emit(AuthOnBoarding());
        //
      } else {
        //
        refresh();
        //
      }
      return;
    }
    //
    // if (kDebugMode) {
    //   emit(const AuthOfflineMode());
    //   return;
    // }
    //
    final res = await locator<CheckUpdateStateUC>().call();
    //
    res.fold(
      (l) {
        debugPrint((l.toString().contains("Failed host lookup")).toString());
        if (l.toString().contains("Failed host lookup")) {
          startOfflineMode();
        } else {
          emit(const AuthError(error: "لا يوجد اتصال بالانترنت"));
        }
      },
      (r) {
        injectUpdateInfo(r);
        if (r.appVersion < r.currentVersion ||
            r.appVersion < r.minimumVersion) {
          emit(AuthUpdate(updateInfo: r));
        } else {
          //
          didCheckUpdate = true;
          //
          if (user == null) {
            emit(AuthOnBoarding());
          } else {
            //
            refresh();
            //
          }
        }
      },
    );
    //
  }

  onCheck({VoidCallback? onSignedOut}) {
    //
    var user = Supabase.instance.client.auth.currentUser;
    //
    if (user == null) return;
    //
    locator<GetUserDataUC>().call(uuid: user.id, update: true).then((value) {
      value.fold(
        (l) {
          debugPrint(l.toString());
        },
        (userData) async {
          if (userData.deviceId == DeviceService().deviceId ||
              userData.deviceId.isEmpty) {
            injectUserData(userData);
          } else {
            if (timer != null && (timer?.isActive ?? false)) {
              timer?.cancel();
            }
            //
            startSignOut(forced: true);
            //
            if (onSignedOut != null) {
              onSignedOut();
            }
          }
        },
      );
    });
  }

  void skipUpdate() {
    refresh();
  }

  Future refresh() async {
    //
    emit(AuthLoading());
    //
    var user = Supabase.instance.client.auth.currentUser;
    //
    await locator<GetUserDataUC>().call(uuid: user!.id).then((value) {
      value.fold(
        (l) {
          if (l is MissingUserDataFailure) {
            emit(EnterUserData());
          } else {
            emit(AuthError(error: l.text));
          }
        },
        (userData) async {
          if (userData.deviceId == DeviceService().deviceId ||
              userData.deviceId.isEmpty) {
            injectUserData(userData);
            var res = await locator<GetUserPurchasedItemsUC>().call();
            res.fold(
              (l) {
                emit(AuthError(error: l.text));
              },
              (r) async {
                //
                injectPurchasedItems(r);
                //
                await locator<CacheManager>().uploadResults();
                //
                await registerDeviceToken();
                //
                emit(AuthDone());
              },
            );
          } else {
            startSignOut(forced: true);
          }
        },
      );
    });
  }

  updateUserLikes(List<UserLike> likes) async {
    var userData = locator<UserData>();
    userData = userData.copyWith(likes: likes);
    await updateUserData(userData);
  }

  updateUserData(UserData userData) {
    injectUserData(userData);
    locator<UpdateUserDataUC>().call(userData: userData).then((value) {
      value.fold(
        (l) => null,
        (r) {
          injectUserData(userData);
        },
      );
    });
  }

  like({required UserLike like}) async {
    var likes = locator<UserData>().likes;
    likes.add(like);
    await updateUserLikes(likes);
  }

  unLike({required UserLike like}) async {
    var likes = locator<UserData>().likes;
    likes.removeWhere((e) {
      bool remove = false;
      if (like.bankId != null) {
        if (e.bankId == like.bankId) {
          if (e.bQuestion?.id == like.bQuestion?.id) {
            remove = true;
          }
        }
      }
      if (like.testId != null) {
        if (e.testId == like.testId) {
          if (e.tQuestion?.id == like.tQuestion?.id) {
            remove = true;
          }
        }
      }
      return remove;
    });
    //
    updateUserLikes(likes);
  }

  injectUserData(UserData userData) {
    if (!GetIt.instance.isRegistered<UserData>()) {
      locator.registerFactory<UserData>(() => userData);
    } else {
      GetIt.instance.unregister<UserData>();
      locator.registerFactory<UserData>(() => userData);
    }
  }

  injectUpdateInfo(UpdateInfo info) {
    if (!GetIt.instance.isRegistered<UpdateInfo>()) {
      locator.registerFactory<UpdateInfo>(() => info);
    } else {
      GetIt.instance.unregister<UpdateInfo>();
      locator.registerFactory<UpdateInfo>(() => info);
    }
  }

  injectPurchasedItems(List<PurchaseItem> items) {
    if (!GetIt.instance.isRegistered<List<PurchaseItem>>()) {
      locator.registerFactory<List<PurchaseItem>>(() => items);
    } else {
      GetIt.instance.unregister<List<PurchaseItem>>();
      locator.registerFactory<List<PurchaseItem>>(() => items);
    }
  }

  //
  startAuth() async {
    emit(AuthLoading());
    await locator<SignOutUC>().call();
    emit(AuthStartAuth());
  }

  //
  startSignIn() async {
    emit(AuthSignIn());
  }

  startSignInWithGoogle() async {
    //
    //
    emit(AuthLoading());
    //
    //
    final response = await locator<SignInUCWithGoogleUC>().call();
    //
    response.fold(
      (l) {
        if (l is MissingUserDataFailure) {
          emit(EnterUserData());
        } else {
          emit(AuthError(error: l.text));
        }
      },
      (r) {
        init();
      },
    );
  }

  //
  startSignUp() async {
    emit(AuthSignUP());
  }

  //
  startResetPassword() async {
    emit(AuthResetPassword());
  }

  //
  startSignOut({bool forced = false}) async {
    //
    timer?.cancel();
    //
    emit(AuthLoading());
    //
    await locator<SignOutUC>().call();
    //
    emit(AuthSignedOut(forced: forced));
  }

  //
  finishAuth() async {
    await registerDeviceToken();
    await init();
  }

  //
  startOfflineMode() async {
    final response = await locator<GetUserDataUC>()
        .call(uuid: Supabase.instance.client.auth.currentUser!.id, force: true);
    response.fold(
      (l) {
        emit(const AuthError(error: "لا يوجد اتصال بالانترنت"));
      },
      (r) {
        injectUserData(r);
        emit(const AuthOfflineMode());
      },
    );
  }

  registerDeviceToken() async {
    final platform = Platform.isAndroid ? 'android' : 'ios';
    final deviceTokenResult = await locator<GetDeviceTokenUsecase>().call();
    await deviceTokenResult.fold(
      (l) async => debugPrint('Failed to get device token: $l'),
      (deviceToken) async {
        await locator<RegisterDeviceTokenUseCase>().call(
          RegisterDeviceTokenRequest(
            deviceToken: deviceToken,
            platform: platform,
          ),
        );
      },
    );
  }
}
