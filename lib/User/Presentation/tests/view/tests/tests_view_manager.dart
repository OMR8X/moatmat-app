import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/texts_resources.dart';
import 'package:moatmat_app/User/Core/widgets/view/pick_category_v.dart.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/User/Presentation/home/view/material_picker_v.dart';
import 'package:moatmat_app/User/Presentation/tests/state/get_test_c/get_test_cubit.dart';
import 'package:moatmat_app/User/Presentation/tests/view/exploring/explore_no_time_v.dart';
import 'package:moatmat_app/User/Presentation/tests/view/exploring/full_time_explore_v.dart';
import 'package:moatmat_app/User/Presentation/tests/view/exploring/per_question_explore_v.dart';
import 'package:moatmat_app/User/Presentation/tests/view/tests/check_if_test_done_v.dart';
import 'package:moatmat_app/User/Presentation/tests/view/tests/pick_test_v.dart';
import 'package:moatmat_app/User/Presentation/tests/view/tests/test_searching_v.dart';

import '../../../../Core/widgets/view/pick_folder_v.dart';
import '../../../banks/views/banks/teacher_searching_v.dart';

class TestsViewManager extends StatefulWidget {
  const TestsViewManager({super.key});

  @override
  State<TestsViewManager> createState() => _TestsViewManagerState();
}

class _TestsViewManagerState extends State<TestsViewManager> {
  @override
  void initState() {
    context.read<GetTestCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GetTestCubit, GetTestState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: SnackBar(content: Text(state.error!)),
            ));
          }
        },
        builder: (context, state) {
          if (state is GetTestSelectMaterial) {
            return MaterialPickerView(
              material: state.materials,
              onPick: (p0) {
                context.read<GetTestCubit>().selecteMaterial(p0);
              },
            );
          } else if (state is GetTestSelectClass) {
            return PickCategoryView(
              title: AppBarTitles.pickClass,
              categories: state.classes.map((e) {
                return e.$1;
              }).toList(),
              subCategories: state.classes.map((e) {
                return "عدد الاختبارات : ${e.$2}";
              }).toList(),
              onPick: (clas) {
                context.read<GetTestCubit>().selecteClass(clas);
              },
              onPop: () {
                context.read<GetTestCubit>().backToMaterials();
              },
            );
          } else if (state is GetTestSelectTeacher) {
            return PickCategoryView(
              title: AppBarTitles.pickTeacher,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TeacherSearchView(
                          teachers: state.teachers,
                          onSelect: (teacherData) {
                            context.read<GetTestCubit>().selectTeacher(
                                  teacherData,
                                );
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.search),
                )
              ],
              categories: state.teachers.map((e) {
                return e.$1.name;
              }).toList(),
              subCategories: state.teachers.map((e) {
                return "عدد الاختبارات : ${e.$2}";
              }).toList(),
              onPick: (clas) {
                context.read<GetTestCubit>().selectTeacher(
                      state.teachers.firstWhere((e) => e.$1.name == clas).$1,
                    );
              },
              onPop: () {
                context.read<GetTestCubit>().backToClasses();
              },
            );
            //
          } else if (state is GetTestSelectFolder) {
            return PickFolderView(
              isTest: true,
              material: state.material,
              teacher: state.teacherData,
              onSearch: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TestSearchingView(
                    tests: state.tests,
                    onSelect: (t) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CheckIfTestDone(
                            test: t.$1,
                          ),
                        ),
                      );
                    },
                  ),
                ));
              },
              onPop: () {
                context.read<GetTestCubit>().backToTeachers();
              },
              afterPick: (t) {
                context.read<GetTestCubit>().selectFolder(t);
              },
            );
          } else if (state is GetTestSelectTest) {
            return PickTestView(
              title: state.title,
              tests: state.tests,
              onPop: () {
                context.read<GetTestCubit>().backToFolders();
              },
              onPick: (b) async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CheckIfTestDone(
                      test: b.$1,
                    ),
                  ),
                );
              },
            );
          }
          return const Scaffold(
            backgroundColor: ColorsResources.primary,
            body: Center(
              child: CupertinoActivityIndicator(
                color: ColorsResources.whiteText1,
              ),
            ),
          );
        },
      ),
    );
  }
}
