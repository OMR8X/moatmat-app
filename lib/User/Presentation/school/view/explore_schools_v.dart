import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Presentation/school/state/cubit/school_cubit.dart';
import 'package:moatmat_app/User/Presentation/school/widgets/error_w.dart';
import 'package:moatmat_app/User/Presentation/school/widgets/school_card_w.dart';

class ExploreSchools extends StatefulWidget {
  const ExploreSchools({super.key});

  @override
  State<ExploreSchools> createState() => _ExploreSchoolsState();
}

class _ExploreSchoolsState extends State<ExploreSchools> {
  @override
  void initState() {
    context.read<SchoolCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      body: Padding(
        padding: SpacingResources.mainSidePadding(context) + EdgeInsetsDirectional.only(top: SizesResources.s8, bottom: SizesResources.s4),
        child: BlocConsumer<SchoolCubit, SchoolState>(
          listener: (context, state) {
            if (state is SchoolFailed) {}
          },
          builder: (context, state) {
            if (state is SchoolLoaded) {
              return ListView.builder(
                itemCount: state.schools.length,
                itemBuilder: (context, index) {
                  return SchoolCardWidget(
                    title: state.schools[index].information.name,
                    subtitle: state.schools[index].information.description,
                  );
                },
              );
            } else if (state is SchoolFailed) {
              return ErrorView(error: state.msg);
            }
            return const Center(
              child: CupertinoActivityIndicator(
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}

