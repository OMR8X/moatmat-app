import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Features/purchase/domain/entites/purchase_item.dart';
import 'package:moatmat_app/Features/purchase/domain/repository/repository.dart';

import '../../../../Core/errors/export_errors.dart';

class PurchaseItemUC {
  final PurchasesRepository repository;

  PurchaseItemUC({required this.repository});
  Future<Either<Failure, Unit>> call({required PurchaseItem item}) async {
    return await repository.purchaseItem(item: item);
  }
}
