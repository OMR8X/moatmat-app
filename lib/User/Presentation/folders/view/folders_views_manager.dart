import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';

import '../state/cubit/folders_manager_cubit.dart';
import 'sub_folders_v.dart';

class FoldersViewManager extends StatefulWidget {
  const FoldersViewManager({
    super.key,
    required this.isTest,
    required this.material,
    required this.title,
    required this.openContent,
    required this.directories,
    this.onPop,
  });

  final String title, material;
  final Map<String, dynamic> directories;
  final bool isTest;
  final void Function(int id) openContent;
  final VoidCallback? onPop;
  @override
  State<FoldersViewManager> createState() => _FoldersViewManagerState();
}

class _FoldersViewManagerState extends State<FoldersViewManager> {
  @override
  void initState() {
    context.read<FoldersManagerCubit>().init(isTest: widget.isTest, directories: widget.directories, material: widget.material);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      body: BlocBuilder<FoldersManagerCubit, FoldersManagerState>(
        builder: (context, state) {
          final cubit = context.read<FoldersManagerCubit>();
          if (state is FoldersManagerExploreFolder) {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (state.canPop) {
                  cubit.popBack();
                } else {
                  widget.onPop?.call();
                }
              },
              child: SubFoldersView(
                folders: state.folders,
                banks: state.banks,
                tests: state.tests,
                openDirectory: (index) {
                  cubit.exploreDirectory(index);
                },
                onPop: state.canPop
                    ? () {
                        cubit.popBack();
                      }
                    : null,
              ),
            );
          } else if (state is FoldersManagerError) {
            return Center(
              child: Text(state.error),
            );
          }
          return const Center(
            child: CupertinoActivityIndicator(
              color: ColorsResources.whiteText1,
            ),
          );
        },
      ),
    );
  }
}
