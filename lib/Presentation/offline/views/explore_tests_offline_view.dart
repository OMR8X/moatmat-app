import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Core/functions/show_alert.dart';
import 'package:moatmat_app/Core/injection/app_inj.dart';
import 'package:moatmat_app/Core/resources/colors_r.dart';
import 'package:moatmat_app/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/Core/constant/materials.dart';
import 'package:moatmat_app/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/Presentation/offline/states/offline_tests_bloc.dart';
import 'package:moatmat_app/Presentation/home/view/material_picker_v.dart';
import 'package:moatmat_app/Presentation/tests/view/exploring/explore_no_time_v.dart';
import 'package:moatmat_app/Presentation/tests/view/exploring/full_time_explore_v.dart';
import 'package:moatmat_app/Presentation/tests/view/exploring/per_question_explore_v.dart';
import 'package:moatmat_app/Presentation/tests/view/tests/check_if_test_done_v.dart';
import 'package:moatmat_app/Presentation/tests/widgets/test_tile_w.dart';
import 'package:moatmat_app/Presentation/videos/view/test_assets_v.dart';

class ExploreTestsOfflineView extends StatelessWidget {
  const ExploreTestsOfflineView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<OfflineTestsBloc>()..add(InitializeOfflineTests()),
      child: const ExploreTestsOfflineViewBody(),
    );
  }
}

class ExploreTestsOfflineViewBody extends StatelessWidget {
  const ExploreTestsOfflineViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      appBar: AppBar(
        backgroundColor: ColorsResources.primary,
        foregroundColor: ColorsResources.whiteText1,
        actions: [
          BlocBuilder<OfflineTestsBloc, OfflineTestsState>(
            builder: (context, state) {
              // Show change material button when in initial state
              if (state is OfflineTestsInitial) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.cachedTests.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          showAlert(
                            context: context,
                            title: "حذف جميع الاختبارات",
                            body: "هل تريد حذف جميع الاختبارات المحفوظة؟\nلن يمكنك التراجع عن هذا الإجراء.",
                            icon: Icons.delete_sweep,
                            iconColor: ColorsResources.red,
                            agreeBtn: "حذف الكل",
                            disagreeBtn: "إلغاء",
                            onAgree: () {
                              context.read<OfflineTestsBloc>().add(
                                    ClearAllCachedTests(),
                                  );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete_sweep),
                        tooltip: "حذف جميع الاختبارات",
                      ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<OfflineTestsBloc, OfflineTestsState>(
        builder: (context, state) {
          if (state is OfflineTestsMaterialPicker) {
            return OfflineTestsMaterialPickerWidget();
          }

          if (state is OfflineTestsLoading) {
            return const OfflineTestsLoadingWidget();
          }

          if (state is OfflineTestsInitial) {
            return OfflineTestsInitialWidget(state: state);
          }

          return const Center(
            child: Text(
              "حدث خطأ غير متوقع",
              style: TextStyle(
                color: ColorsResources.red,
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}

class OfflineTestsMaterialPickerWidget extends StatelessWidget {
  const OfflineTestsMaterialPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract material names from the materials list
    final materialNames = materialsLst.map((material) => material["name"]!).toList();

    return MaterialPickerView(
      hideAppBar: true,
      material: materialNames,
      onPick: (selectedMaterial) {
        context.read<OfflineTestsBloc>().add(
              SelectMaterial(material: selectedMaterial),
            );
      },
    );
  }
}

class OfflineTestsLoadingWidget extends StatelessWidget {
  const OfflineTestsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: ColorsResources.primary,
      ),
    );
  }
}

class OfflineTestsInitialWidget extends StatelessWidget {
  final OfflineTestsInitial state;

  const OfflineTestsInitialWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state.cachedTests.isEmpty) {
      return _buildEmptyState(context, state.message);
    }

    return Column(
      children: [
        // Show selected material info
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorsResources.onPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorsResources.onPrimary.withOpacity(0.3),
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              context.read<OfflineTestsBloc>().add(ResetToMaterialPicker());
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.subject,
                    color: ColorsResources.whiteText1,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "اختبارات مادة ${state.selectedMaterial}",
                    style: const TextStyle(
                      color: ColorsResources.whiteText1,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: SizesResources.s2,
            ),
            itemCount: state.cachedTests.length,
            itemBuilder: (context, index) {
              final test = state.cachedTests[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onLongPress: () {
                          showAlert(
                            context: context,
                            title: "تأكيد الحذف",
                            body: 'هل تريد حذف "${test.information.title}" من الاختبارات المحفوظة؟',
                            icon: Icons.delete,
                            iconColor: ColorsResources.red,
                            agreeBtn: "حذف",
                            disagreeBtn: "إلغاء",
                            onAgree: () {
                              context.read<OfflineTestsBloc>().add(
                                    DeleteTestFromCache(testId: test.id),
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('تم حذف "${test.information.title}"'),
                                  backgroundColor: ColorsResources.primary,
                                ),
                              );
                            },
                          );
                        },
                        child: TestTileWidget(
                          test: test,
                          isCached: true,
                          onDelete: () {
                            context.read<OfflineTestsBloc>().add(
                                  DeleteTestFromCache(testId: test.id),
                                );
                          },
                          onPick: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CheckIfTestDone(
                                  test: test,
                                  isOffline: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: SizesResources.s4),
          Text(
            message ?? "لا توجد اختبارات محفوظة",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SizesResources.s2),
          Text(
            "يمكنك تحميل الاختبارات من قائمة الرئيسية\nللوصول إليها بدون انترنت",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
