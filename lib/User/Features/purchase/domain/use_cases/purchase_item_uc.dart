import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';
import 'package:moatmat_app/User/Features/purchase/domain/repository/repository.dart';

import '../../../../Core/errors/exceptions.dart';

class PurchaseItemUC {
  final PurchasesRepository repository;

  PurchaseItemUC({required this.repository});
  Future<Either<Failure, Unit>> call({required PurchaseItem item}) async {
    return await repository.purchaseItem(item: item);
  }
}
