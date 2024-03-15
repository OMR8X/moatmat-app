import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';
import 'package:moatmat_app/User/Features/purchase/domain/repository/repository.dart';

import '../../../../Core/errors/exceptions.dart';

class GetUserPurchasedItemsUC {
  final PurchasesRepository repository;

  GetUserPurchasedItemsUC({required this.repository});
  Future<Either<Failure, List<PurchaseItem>>> call() async {
    return await repository.getUserPurchased();
  }
}
