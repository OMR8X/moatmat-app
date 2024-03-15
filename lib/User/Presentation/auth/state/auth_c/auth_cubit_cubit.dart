import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_like.dart';
import 'package:moatmat_app/User/Features/auth/domain/use_cases/update_user_data_uc.dart';
import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';
import 'package:moatmat_app/User/Features/purchase/domain/use_cases/get_user_purchased_uc.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/auth/domain/entites/user_data.dart';
import '../../../../Features/auth/domain/use_cases/get_user_data.dart';

part 'auth_cubit_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthLoading());
  init() async {
    var user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      emit(AuthOnBoarding());
    } else {
      emit(AuthLoading());
      locator<GetUserDataUC>().call(uuid: user.id).then((value) {
        value.fold(
          (l) {
            emit(AuthError());
          },
          (r) async {
            injectUserData(r);
            var res = await locator<GetUserPurchasedItemsUC>().call();
            res.fold(
              (l) {
                emit(AuthError());
              },
              (r) {
                injectPurchasedItems(r);
                emit(AuthDone());
              },
            );
          },
        );
      });
    }
  }

  refresh() async {
    emit(AuthLoading());
    var user = Supabase.instance.client.auth.currentUser;
    locator<GetUserDataUC>().call(uuid: user!.id).then((value) {
      value.fold(
        (l) {
          emit(AuthError());
        },
        (r) async {
          injectUserData(r);
          var res = await locator<GetUserPurchasedItemsUC>().call();
          res.fold(
            (l) {
              emit(AuthError());
            },
            (r) {
              if (!GetIt.instance.isRegistered<List<PurchaseItem>>()) {
                locator.registerFactory<List<PurchaseItem>>(() => r);
              } else {
                GetIt.instance.unregister<List<PurchaseItem>>();
                locator.registerFactory<List<PurchaseItem>>(() => r);
              }
              emit(AuthDone());
            },
          );
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
    emit(AuthStartAuth());
  }

  //
  startSignIn() async {
    emit(AuthSignIn());
  }

  //
  startSignUp() async {
    emit(AuthSignUP());
  }

  //
  startRessetPassword() async {
    emit(AuthResetPassword());
  }

  //
  startSignOut() async {
    emit(AuthLoading());
    await locator<SupabaseClient>().auth.signOut();
    startAuth();
  }

  //
  finishAuth() {
    init();
  }
}
