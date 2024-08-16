part of 'get_bank_cubit.dart';

sealed class GetBankState extends Equatable {
  const GetBankState({this.error});
  final String? error;
  @override
  List<Object> get props => error != null ? [error!] : [];
}

final class GetBankLoading extends GetBankState {
  const GetBankLoading({super.error});
}

final class GetBankSelecteMaterial extends GetBankState {
  final List<String> materials;

  const GetBankSelecteMaterial({
    required this.materials,
    super.error,
  });
  @override
  List<Object> get props => [materials];
}

final class GetBankSelecteClass extends GetBankState {
  final List<(String, int)> classes;

  const GetBankSelecteClass({
    required this.classes,
    super.error,
  });
  @override
  List<Object> get props => [classes];
}

final class GetBankSelecteTeacher extends GetBankState {
  final List<(TeacherData, int)> teachers;

  const GetBankSelecteTeacher({
    required this.teachers,
    super.error,
  });
  @override
  List<Object> get props => [teachers];
}

final class GetBankSelecteFolder extends GetBankState {
  final List<String> folders;
  final TeacherData teacherData;

  const GetBankSelecteFolder({
    required this.teacherData,
    required this.folders,
    super.error,
  });
  @override
  List<Object> get props => [folders];
}
final class GetBankSelecteBank extends GetBankState {
  final String title;
  final List<(Bank, int)> banks;

  const GetBankSelecteBank({
    required this.banks,
    required this.title,
    super.error,
  });
  @override
  List<Object> get props => [banks,title];
}

final class GetBankDone extends GetBankState {
  final Bank bank;

  const GetBankDone({
    required this.bank,
    super.error,
  });
  @override
  List<Object> get props => [bank];
}

