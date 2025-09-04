import 'package:dartz/dartz.dart';
import 'package:moatmat_app/Features/reports/domain/repository/reports_repository.dart';
import '../../../../Core/errors/export_errors.dart';
import '../entities/reposrt_data.dart';

class GetReportsUC {
  final ReportsRepository repository;

  GetReportsUC({required this.repository});
  Future<Either<Failure, List<ReportData>>> call() async {
    return await repository.getReports();
  }
}
