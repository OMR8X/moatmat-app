import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Core/resources/colors_r.dart';
import 'package:moatmat_app/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/Presentation/school/state/cubit/school_cubit.dart';

class ErrorView extends StatefulWidget {
  const ErrorView({super.key, this.error});
  final String? error;
  @override
  State<ErrorView> createState() => _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: SizesResources.s10,
          ),
          const Icon(
            Icons.warning,
            size: SizesResources.s10,
            color: ColorsResources.red,
          ),
          const SizedBox(
            height: SizesResources.s5,
          ),
          Text(
            widget.error ?? "حصل خطا ما اثناء محاولة الاتصال الخادم",
            style: TextStyle(
              color: ColorsResources.whiteText2,
            ),
          ),
          const SizedBox(
            height: SizesResources.s2,
          ),
          TextButton(
            onPressed: () {
              context.read<SchoolCubit>().init();
            },
            child: const Text(
              "اعادة التحميل",
              style: TextStyle(
                color: ColorsResources.whiteText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
