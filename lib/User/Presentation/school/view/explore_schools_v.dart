import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_app/User/Presentation/school/state/bloc/school_tests_bloc.dart';
import 'package:moatmat_app/User/Presentation/school/widgets/school_card_w.dart';
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
