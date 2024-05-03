import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/purchase/data/datasources/date_source.dart';
import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';
import 'package:moatmat_app/User/Features/purchase/domain/repository/repository.dart';

class PurchasesReporisotyrImpl implements PurchasesRepository {
  final PurchasedItemsDataSource dataSource;

  PurchasesReporisotyrImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<PurchaseItem>>> getUserPurchased() async {
    try {
      var list = await dataSource.getUserPurchased();
      return right(list);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> purchaseItem({
    required PurchaseItem item,
  }) async {
    try {
      var res = await dataSource.purchaseItem(item: item);
      return right(res);
    } on NotEnoughBalanceException catch (e) {
      print(e);
      return left(const NotEnoughtBalaneFailure());
    } on Exception catch (e) {
      print(e);
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> purchaseListOfItem({
    required List<PurchaseItem> items,
  }) async {
    try {
      var res = await dataSource.purchaseListOfItem(items: items);
      return right(res);
    } on NotEnoughBalanceException {
      return left(const NotEnoughtBalaneFailure());
    } on Exception {
      return left(const AnonFailure());
    }
  }
}
