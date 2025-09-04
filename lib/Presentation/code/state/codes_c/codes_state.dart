part of 'codes_cubit.dart';

sealed class CodesState extends Equatable {
  const CodesState();

  @override
  List<Object> get props => [];
}

final class CodesLoading extends CodesState {}

final class CodesInitial extends CodesState {
  final String? code;
  final String? msg;

  const CodesInitial({this.code, this.msg});

  @override
  List<Object> get props =>
      code != null ? (msg != null ? [code!, msg!] : [code!]) : [];
}

final class CodesScanning extends CodesState {}
final class CodesSuccesed extends CodesState {}
