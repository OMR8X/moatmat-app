import 'package:moatmat_app/Core/injection/app_inj.dart';
import 'package:moatmat_app/Features/auth/domain/entites/user_data.dart';

import '../../auth/state/auth_c/auth_cubit_cubit.dart';
import '../../../Core/resources/texts_resources.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../state/codes_c/codes_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'code_scanner_v.dart';
import 'add_code_v.dart';

class CodesViewsManager extends StatefulWidget {
  const CodesViewsManager({super.key});

  @override
  State<CodesViewsManager> createState() => _CodesViewsManagerState();
}

class _CodesViewsManagerState extends State<CodesViewsManager> {
  @override
  void initState() {
    context.read<CodesCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppBarTitles.addCode),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "الرصيد الحالي : ${locator<UserData>().balance}",
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
      body: BlocConsumer<CodesCubit, CodesState>(
        listener: (context, state) {
          if (state is CodesInitial) {
            if (state.msg != null) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Text(state.msg!),
                ),
              );
            }
          } else if (state is CodesSuccesed) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 2),
                content: Text("تم إضافة النقاط نجاح"),
              ),
            );
            context.read<AuthCubit>().refresh();
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is CodesInitial) {
            return AddCodeView(
              code: state.code,
            );
          } else if (state is CodesScanning) {
            return const CodeScannerView();
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }
}
