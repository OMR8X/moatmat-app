import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/User/Features/auth/domain/use_cases/update_user_data_uc.dart';
import 'package:moatmat_app/User/Features/purchase/data/models/purchase_item_m.dart';
import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PurchasedItemsDataSource {
  //
  Future<List<PurchaseItem>> getUserPurchased();
  //
  Future<Unit> purchaseItem({required PurchaseItem item});
  //
  Future<Unit> purchaseListOfItem({required List<PurchaseItem> items});
}

class PurchasedItemsDataSourceImpl implements PurchasedItemsDataSource {
  final SupabaseClient client;

  PurchasedItemsDataSourceImpl({required this.client});
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
    items = res.map((e) {
      return PurchaseItemModel.fromJson(e);
    }).toList();
    return items;
  }

  @override
  Future<Unit> purchaseItem({required PurchaseItem item}) async {
    // variables
    var userData = locator<UserData>();
    //
    item = item.copyWith(uuid: userData.uuid);
    //
    Map json = PurchaseItemModel.fromClass(item).toJson();
    //
    if (userData.balance < item.amount) {
      throw NotEnoughBalanceException();
    }
    //
    //  update user data
    userData = userData.copyWith(balance: userData.balance - item.amount);
    //
    await locator<UpdateUserDataUC>().call(userData: userData);
    // insert purchase
    await client.from("purchases").insert(json);

    //
    injectItems(PurchaseItemModel.fromClass(item));
    //
    return unit;
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
