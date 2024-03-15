import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/resources/texts_resources.dart';
import 'package:moatmat_app/User/Presentation/banks/state/get_bank_c/get_bank_cubit.dart';
import 'package:moatmat_app/User/Core/widgets/view/pick_category_v.dart.dart';
import 'package:moatmat_app/User/Presentation/banks/views/banks/pick_bank_v.dart';
import 'package:moatmat_app/User/Presentation/banks/views/banks/setting_up_banke.dart';
import 'package:moatmat_app/User/Presentation/banks/views/banks/teacher_searching_v.dart';
import 'package:moatmat_app/User/Presentation/home/view/material_picker_v.dart';

class BanksViewManager extends StatefulWidget {
  const BanksViewManager({super.key});

  @override
  State<BanksViewManager> createState() => _BanksViewManagerState();
}

class _BanksViewManagerState extends State<BanksViewManager> {
  @override
  void initState() {
    context.read<GetBankCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GetBankCubit, GetBankState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: SnackBar(content: Text(state.error!)),
            ));
          }
        },
        builder: (context, state) {
          if (state is GetBankSelecteMaterial) {
            return MaterialPickerView(
              material: state.materials,
              onPick: (p0) {
                context.read<GetBankCubit>().selecteMaterial(p0);
              },
            );
          } else if (state is GetBankSelecteClass) {
            return PickCategoryView(
              title: AppBarTitles.pickClass,
              categories: state.classes.map((e) {
                return e.$1;
              }).toList(),
              subCategories: state.classes.map((e) {
                return "عدد الاختبارات : ${e.$2}";
              }).toList(),
              onPick: (clas) {
                context.read<GetBankCubit>().selecteClass(clas);
              },
              onPop: () {
                context.read<GetBankCubit>().backToMaterials();
              },
            );
          } else if (state is GetBankSelecteTeacher) {
            return PickCategoryView(
              title: AppBarTitles.pickTeacher,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TeacherSearchView(
                          teachers: state.teachers,
                          onSelect: (s) {
                            context.read<GetBankCubit>().selecteTeacher(
                                  s,
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
                return e.$1;
              }).toList(),
              subCategories: state.teachers.map((e) {
                return "عدد الاختبارات : ${e.$2}";
              }).toList(),
              onPick: (clas) {
                context.read<GetBankCubit>().selecteTeacher(clas);
              },
              onPop: () {
                context.read<GetBankCubit>().backToClasses();
              },
            );
            //
          } else if (state is GetBankSelecteBank) {
            return PickBankView(
              teacher: state.teacher,
              banks: state.banks,
              onPick: (b) {
                context.read<GetBankCubit>().selecteBank(b.$1);
              },
            );
          } else if (state is GetBankDone) {
            return SettingUpBankView(bank: state.bank);
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}
