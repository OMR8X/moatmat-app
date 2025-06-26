import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/constant/materials.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_app/User/Presentation/home/view/material_picker_v.dart';
import 'package:moatmat_app/User/Presentation/school/state/bloc/school_tests_bloc.dart';
import 'package:moatmat_app/User/Presentation/school/widgets/school_card_w.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/widgets/view/pick_folder_v.dart';

class ExploreSchools extends StatefulWidget {
  const ExploreSchools({super.key});

  @override
  State<ExploreSchools> createState() => _ExploreSchoolsState();
}

class _ExploreSchoolsState extends State<ExploreSchools> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      body: BlocProvider.value(
        value: locator<SchoolTestsBloc>()..add(InitializeSchoolsTestsEvent()),
        child: Padding(
          padding: SpacingResources.mainSidePadding(context),
          child: BlocConsumer<SchoolTestsBloc, SchoolTestsState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is SchoolTestsInitial) {
                return SchoolTestsInitialView(state: state);
              } else if (state is SchoolTestsPickMaterialState) {
                return SchoolTestsPickMaterialStateView();
              } else if (state is PickClassState) {
                return PickClassStateView(state: state);
              } else if (state is PickTeacherState) {
                return PickTeacherStateView(state: state);
              } else if (state is ExploreTeacherState) {
                return ExploreTeacherStateView(state: state);
              }

              return Scaffold(
                backgroundColor: ColorsResources.primary,
                appBar: AppBar(
                  foregroundColor: ColorsResources.whiteText1,
                  backgroundColor: ColorsResources.primary,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
                body: const Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SchoolTestsInitialView extends StatelessWidget {
  const SchoolTestsInitialView({super.key, required this.state});
  final SchoolTestsInitial state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorsResources.whiteText1,
        backgroundColor: ColorsResources.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: ColorsResources.primary,
      body: ListView.builder(
        itemCount: state.schools.length,
        itemBuilder: (context, index) {
          return SchoolCardWidget(
            onTap: () {
              locator<SchoolTestsBloc>().add(
                SetSchoolEvent(
                  school: state.schools[index],
                ),
              );
            },
            school: state.schools[index],
          );
        },
      ),
    );
  }
}

class SchoolTestsPickMaterialStateView extends StatelessWidget {
  const SchoolTestsPickMaterialStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      appBar: AppBar(
        title: Text(
          "اختر مادة للمتابعة",
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: ColorsResources.whiteText1,
        backgroundColor: ColorsResources.primary,
        leading: IconButton(
          onPressed: () {
            locator<SchoolTestsBloc>().add(InitializeSchoolsTestsEvent());
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.only(
          top: SizesResources.s2,
          left: SpacingResources.sidePadding,
          right: SpacingResources.sidePadding,
          bottom: SizesResources.s10 * 2,
        ),
        itemCount: 14,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: SizesResources.s2,
          mainAxisSpacing: SizesResources.s2,
        ),
        itemBuilder: (context, index) {
          return Container(
            width: SpacingResources.mainHalfWidth(context),
            height: SpacingResources.mainHalfWidth(context),
            decoration: BoxDecoration(
              color: ColorsResources.onPrimary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: ShadowsResources.mainBoxShadow,
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  locator<SchoolTestsBloc>().add(SetMaterialEvent(materialName: materialsLst[index]["name"]!));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: SpacingResources.mainHalfWidth(context) / 4,
                      backgroundColor: ColorsResources.background,
                      child: Image.asset(
                        materialsLst[index]["image"]!,
                        color: ColorsResources.onPrimary,
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                    const SizedBox(height: SizesResources.s4),
                    Text(
                      materialsLst[index]["name"]!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ColorsResources.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PickClassStateView extends StatelessWidget {
  const PickClassStateView({super.key, required this.state});
  final PickClassState state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorsResources.whiteText1,
        backgroundColor: ColorsResources.primary,
        leading: IconButton(
          onPressed: () {
            locator<SchoolTestsBloc>().add(InitializeSchoolsTestsEvent());
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: ColorsResources.primary,
      body: ListView.builder(
        itemCount: state.classes.length,
        itemBuilder: (context, index) {
          return TouchableTileWidget(
            title: state.classes[index].$1,
            subTitle: "عدد الاختبارات : ${state.classes[index].$2.toString()}",
            iconData: Icons.arrow_forward_ios,
            onTap: () {
              locator<SchoolTestsBloc>().add(
                SetClassEvent(
                  className: state.classes[index].$1,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PickTeacherStateView extends StatelessWidget {
  const PickTeacherStateView({super.key, required this.state});
  final PickTeacherState state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorsResources.whiteText1,
        backgroundColor: ColorsResources.primary,
        leading: IconButton(
          onPressed: () {
            locator<SchoolTestsBloc>().add(
              SetSchoolEvent(),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: ColorsResources.primary,
      body: ListView.builder(
        itemCount: state.teachers.length,
        itemBuilder: (context, index) {
          return TouchableTileWidget(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => PickFolderView(
                    isTest: true,
                    material: "",
                    teacher: state.teachers[index].$1,
                    afterPick: (t) {},
                  ),
                ),
              );
              // locator<SchoolTestsBloc>().add(
              //   SetTeacherEvent(
              //     teacherData: state.teachers[index].$1,
              //   ),
              // );
            },
            iconData: Icons.arrow_forward_ios,
            title: state.teachers[index].$1.name,
            subTitle: "عدد الاختبارات : ${state.teachers[index].$2.toString()}",
          );
        },
      ),
    );
  }
}

class ExploreTeacherStateView extends StatelessWidget {
  const ExploreTeacherStateView({super.key, required this.state});
  final ExploreTeacherState state;
  @override
  Widget build(BuildContext context) {
    return PickFolderView(
      isTest: true,
      material: "",
      teacher: state.teacher,
      onPop: () {
        locator<SchoolTestsBloc>().add(BackEvent());
      },
      afterPick: (t) {},
    );
  }
}
