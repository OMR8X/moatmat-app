import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/code/domain/use_cases/scan_code_uc.dart';
part 'codes_state.dart';

class CodesCubit extends Cubit<CodesState> {
  CodesCubit() : super(const CodesInitial());
  init({String? code, String? msg}) {
    emit(CodesLoading());
    emit(CodesInitial(code: code, msg: msg));
  }

  useCode(String code) async {
    emit(CodesLoading());
    var query = locator<UseCodeUC>().call(code: code);
    await query.then((value) {
      value.fold(
        (l) {
          emit(CodesInitial(code: code, msg: l.text));
        },
        (r) async {
          emit(CodesSuccesed());
        },
      );
    });

    emit(const CodesInitial());
  }

  scanCode() {
    emit(CodesScanning());
  }
}
