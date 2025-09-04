import 'package:moatmat_app/Core/services/cache/cache_manager.dart';

import '../../../../Core/errors/export_errors.dart';
import '../../../../Core/services/cache/cache_constant.dart';
import '../../domain/entites/purchase_item.dart';
import '../models/purchase_item_m.dart';

abstract class PurchasedLocalDatasource {
  //
  Future<List<PurchaseItem>> getUserPurchased();
}

class PurchasedLocalDatasourceImplement implements PurchasedLocalDatasource {
  final CacheManager cacheManager;

  PurchasedLocalDatasourceImplement({required this.cacheManager});

  @override
  Future<List<PurchaseItem>> getUserPurchased() async {
    //
    final valid = await cacheManager.isValid(
      createdKey: CacheConstant.purchasedItemsCreateKey,
      dataKey: CacheConstant.purchasedItemsDataKey,
    );

    if (!valid) {
      throw CacheException();
    }
    //
    final data = await cacheManager().read(CacheConstant.purchasedItemsDataKey);
    //
    if (data == null) {
      throw CacheException();
    }
    //
    List<PurchaseItem> items = data.map<PurchaseItem>((e) {
      return PurchaseItemModel.fromJson(e);
    }).toList();
    //
    return items;
  }
}
