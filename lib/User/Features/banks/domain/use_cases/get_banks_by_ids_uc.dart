import 'package:dartz/dartz.dart';

import '../entites/bank.dart';
import '../repository/repository.dart';

class GetBanksByIdsUC {
  final BanksRepository repository;

  GetBanksByIdsUC({required this.repository});

  Future<Either<Exception, List<Bank>>> call({
    required List<int> ids,
  }) async {
    return await repository.getBanksByIds(
      ids: ids,
    );
  }
}
