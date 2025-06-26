import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/school/domain/usecases/get_school_uc.dart';
import 'package:moatmat_app/User/Features/tests/domain/usecases/get_school_test_classes_uc.dart';
import 'package:moatmat_app/User/Features/tests/domain/usecases/get_school_tests_teacher_uc.dart';
import 'package:moatmat_app/User/Presentation/school/state/bloc/school_tests_bloc.dart';

injectControllers() {
  locator.registerSingleton(
    SchoolTestsBloc(
      locator<GetSchoolUc>(),
      locator<GetSchoolTestClassesUC>(),
      locator<GetSchoolTestsTeacherUC>(),
    ),
  );
}
