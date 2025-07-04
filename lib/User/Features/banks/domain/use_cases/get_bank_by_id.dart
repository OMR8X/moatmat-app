import 'package:dartz/dartz.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/banks/domain/repository/repository.dart';

import '../../../../Core/errors/exceptions.dart';

class GetBankByIdUC {
  final BanksRepository repository;

  GetBankByIdUC({required this.repository});
  Future<Either<Failure, Bank>> call({required int id}) async {
    return repository.getBankById(id: id);
  }
}
