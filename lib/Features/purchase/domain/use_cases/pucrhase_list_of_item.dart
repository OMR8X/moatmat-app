import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/purchase/domain/entites/purchase_item.dart';
import 'package:moatmat_app/Features/purchase/domain/repository/repository.dart';

class PurchaseListOfItemUC {
  final PurchasesRepository repository;

  PurchaseListOfItemUC({required this.repository});
  Future<Either<Failure, Unit>> call({required List<PurchaseItem> items}) async {
    return await repository.purchaseListOfItem(items: items);
  }
}
