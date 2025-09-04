import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/Core/constant/governorates_list.dart';
import 'package:moatmat_app/Core/injection/app_inj.dart';
import 'package:moatmat_app/Features/code/domain/entites/code_center.dart';
import 'package:moatmat_app/Features/code/domain/use_cases/get_codes_centers_uc.dart';

part 'codes_centers_state.dart';

class CodesCentersCubit extends Cubit<CodesCentersState> {
  CodesCentersCubit() : super(CodesCentersLoading());

  init() async {
    //
    emit(CodesCentersLoading());
    //
    emit(CodesCentersGovernorate(governorate: governoratesLst));
  }

  back() {
    init();
  }

  exploreGovernorate(String governorate) async {
    //
    emit(CodesCentersLoading());
    //
    var res = await locator<GetCodesCentersUC>().call(governorate: governorate);
    //
    res.fold((l) {
      emit(CodesCentersError(error: l.toString()));
    }, (r) {
      emit(CodesCentersExplore(centers: r, governorate: governorate));
    });
  }
}
