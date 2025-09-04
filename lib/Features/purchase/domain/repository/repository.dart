import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/purchase/domain/entites/purchase_item.dart';

abstract class PurchasesRepository {
  //
  Future<Either<Failure, List<PurchaseItem>>> getUserPurchased();
  //
  Future<Either<Failure, Unit>> purchaseItem({
    required PurchaseItem item,
  });
  //
  Future<Either<Failure, Unit>> purchaseListOfItem({
    required List<PurchaseItem> items,
  });
}
