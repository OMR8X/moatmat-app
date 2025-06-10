import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/school/domain/entities/school.dart';
import 'package:moatmat_app/User/Features/school/domain/usecases/get_school_uc.dart';

part 'school_state.dart';

class SchoolCubit extends Cubit<SchoolState> {
  SchoolCubit() : super(SchoolInitial());
  init() {
    emit(SchoolLoading());
    locator<GetSchoolUc>().call().then((value) {
      value.fold((l) {
        emit(SchoolFailed(msg: l.text));
      }, (r) {
        emit(SchoolLoaded(schools: r));
      });
    });
  }
}
