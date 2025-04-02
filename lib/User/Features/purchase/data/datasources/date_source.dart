import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/services/cache/cache_manager.dart';
import 'package:moatmat_app/User/Features/auth/data/models/user_data_m.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/User/Features/auth/domain/use_cases/update_user_data_uc.dart';
import 'package:moatmat_app/User/Features/purchase/data/models/purchase_item_m.dart';
import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/services/cache/cache_constant.dart';

abstract class PurchasedItemsRemoteDataSource {
  //
  Future<List<PurchaseItem>> getUserPurchased();
  //
  Future<Unit> purchaseItem({required PurchaseItem item});
  //
  Future<Unit> purchaseListOfItem({required List<PurchaseItem> items});
}

class PurchasedItemsRemoteDataSourceImpl implements PurchasedItemsRemoteDataSource {
  final CacheManager cacheManager;
  final SupabaseClient client;

  PurchasedItemsRemoteDataSourceImpl({
    required this.client,
    required this.cacheManager,
  });
  @override
  Future<List<PurchaseItem>> getUserPurchased() async {
    List<PurchaseItem> items = [];
    //
    String? uuid = client.auth.currentUser?.id;
    //
    if (uuid == null) throw Exception();
    //
    var query = client.from("purchases").select().eq("uuid", uuid);
    var res = await query;
    //
    //
    await cacheManager().write(
      CacheConstant.purchasedItemsDataKey,
      res,
    );
    await cacheManager().write(
      CacheConstant.purchasedItemsCreateKey,
      DateTime.now().toString(),
    );
    //
    items = res.map((e) {
      return PurchaseItemModel.fromJson(e);
    }).toList();
    return items;
  }

  @override
  Future<Unit> purchaseItem({required PurchaseItem item}) async {
    //
    try {
      await cacheManager().remove(CacheConstant.purchasedItemsDataKey);
      await cacheManager().remove(CacheConstant.purchasedItemsCreateKey);
      //
      //
      Map json = PurchaseItemModel.fromClass(item.copyWith(uuid: locator<UserData>().uuid)).toJson();
      //
      final response = await Supabase.instance.client.rpc("purchase_item", params: {
        "purchase_item_key": json,
      });
      //
      if (response['status']) {
        //
        await locator<UpdateUserDataUC>().call(
          userData: UserDataModel.fromJson(
            response["user_data"],
          ),
        );
        //
        injectItems(PurchaseItemModel.fromClass(item));
        //
        return unit;
      } else {
        throw AnonException();
      }
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<Unit> purchaseListOfItem({required List<PurchaseItem> items}) async {
    //
    var userData = locator<UserData>();
    //
    int price = 0;
    //
    for (var i in items) {
      price += i.amount;
    }
    //
    if (userData.balance < price) {
      throw NotEnoughBalanceException();
    } else {
      //
      for (var i in items) {
        await purchaseItem(item: i);
      }
      return unit;
    }
  }

  injectItems(PurchaseItem item) {
    List<PurchaseItem> items = [];
    items = locator<List<PurchaseItem>>().cast<PurchaseItem>();
    items.add(item);
    GetIt.instance.unregister<List<PurchaseItem>>();
    locator.registerFactory<List<PurchaseItem>>(() => items);
  }
}
