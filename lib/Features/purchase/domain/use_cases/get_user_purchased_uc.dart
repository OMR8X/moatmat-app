import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Features/purchase/domain/entites/purchase_item.dart';
import 'package:moatmat_app/Features/purchase/domain/repository/repository.dart';

import '../../../../Core/errors/export_errors.dart';

class GetUserPurchasedItemsUC {
  final PurchasesRepository repository;

  GetUserPurchasedItemsUC({required this.repository});
  Future<Either<Failure, List<PurchaseItem>>> call() async {
    return await repository.getUserPurchased();
  }
}
