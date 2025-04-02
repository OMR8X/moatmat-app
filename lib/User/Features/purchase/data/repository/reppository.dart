import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/purchase/data/datasources/date_source.dart';
import 'package:moatmat_app/User/Features/purchase/data/datasources/purchased_local_datasource.dart';
import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';
import 'package:moatmat_app/User/Features/purchase/domain/repository/repository.dart';

class PurchasesReporisotyrImpl implements PurchasesRepository {
  final PurchasedItemsRemoteDataSource dataSource;
  final PurchasedLocalDatasource localDatasource;

  PurchasesReporisotyrImpl({required this.dataSource, required this.localDatasource});
  @override
  Future<Either<Failure, List<PurchaseItem>>> getUserPurchased() async {
    try {
      //
      final response = await localDatasource.getUserPurchased();
      //
      return right(response);
      //
    } catch (e) {
      debugPrint(e.toString());
      //
      try {
        var list = await dataSource.getUserPurchased();
        return right(list);
      } on Exception {
        return left(const AnonFailure());
      }
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
      return left(const NotEnoughtBalaneFailure());
    } on Exception catch (e) {
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
    } on Exception catch (e) {
      return left(const AnonFailure());
    }
  }
}
