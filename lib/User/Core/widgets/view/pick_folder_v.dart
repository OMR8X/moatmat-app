import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_app/User/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/teacher_data.dart';

import '../../../Features/purchase/domain/entites/purchase_item.dart';
import '../../../Features/purchase/domain/use_cases/pucrhase_list_of_item.dart';
import '../../../Presentation/auth/state/auth_c/auth_cubit_cubit.dart';
import '../../../Presentation/banks/state/get_bank_c/get_bank_cubit.dart';
import '../../../Presentation/teachers/view/teacher_profile_v.dart';
import '../../injection/app_inj.dart';
import '../../resources/colors_r.dart';
import '../../resources/shadows_r.dart';
import '../../resources/sizes_resources.dart';
import '../../resources/spacing_resources.dart';

class PickFolderView extends StatefulWidget {
  const PickFolderView({
    super.key,
    required this.folders,
    required this.afterPick,
    required this.teacher,
    required this.onPop,
  });
  final List<String> folders;
  final TeacherData teacher;
  final VoidCallback onPop;
  final Function(String key) afterPick;

  @override
  State<PickFolderView> createState() => _PickFolderViewState();
}

class _PickFolderViewState extends State<PickFolderView> {
  List<(String, int)> folders = [];
  //
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((t) {
      initFolders();
    });
    super.initState();
  }

  initFolders() {
    //
    Map<String, int> foldersData = {};

    for (var f in widget.folders) {
      //
      if (foldersData[f] == null) {
        foldersData[f] = 0;
      }

      foldersData[f] = foldersData[f]! + 1;
    }
    //
    foldersData.forEach((key, value) {
      folders.add((key, value));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        widget.onPop();
      },
      child: Scaffold(
        backgroundColor: ColorsResources.primary,
        appBar: AppBar(
          backgroundColor: ColorsResources.primary,
          foregroundColor: ColorsResources.whiteText1,
          title: Text(
            "مجلدات اختبارات ${widget.teacher.name}",
            style: const TextStyle(
              fontSize: 14,
              color: ColorsResources.whiteText1,
            ),
          ),
          centerTitle: false,
          leading: IconButton(
            onPressed: widget.onPop,
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: SizesResources.s2),
            BuyTeacherWidget(teacher: widget.teacher),
            const SizedBox(height: SizesResources.s2),
            TouchableTileWidget(
              title: "لمحة حول المدرس ${widget.teacher.name}",
              iconData: Icons.arrow_forward_ios,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TeacherProfileView(
                      teacherData: widget.teacher,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: SizesResources.s2),
            Expanded(
              child: ListView.builder(
                itemCount: folders.length,
                itemBuilder: (context, index) {
                  return FolderItemWidget(
                    name: folders[index].$1,
                    onTap: () {
                      widget.afterPick(folders[index].$1);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuyTeacherWidget extends StatefulWidget {
  const BuyTeacherWidget({
    super.key,
    required this.teacher,
  });

  final TeacherData teacher;

  @override
  State<BuyTeacherWidget> createState() => _BuyTeacherWidgetState();
}

class _BuyTeacherWidgetState extends State<BuyTeacherWidget> {
  bool didPurchase = false;
  @override
  void initState() {
    //
    setInfo();
    //
    super.initState();
  }

  setInfo() {
    var items = locator<List<PurchaseItem>>();
    //
    for (var i in items) {
      if (i.itemId == widget.teacher.email && i.itemType == "teacher") {
        didPurchase = true;
      }
    }
    if (widget.teacher.price <= 0) {
      didPurchase = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (didPurchase) {
      return const SizedBox();
    }
    return Container(
      width: SpacingResources.mainWidth(context),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ColorsResources.darkPrimary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "اشترك لدى المدرس ${widget.teacher.name}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.cyan,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SizesResources.s1),
          Text(
            "اشترك لدى المدرس ${widget.teacher.name} للحصول على كامل محتوى المدرس من الاختبارات والبنوك التي ستنشر على مدى العام الدراسي",
            style: const TextStyle(
              fontSize: 12,
              color: ColorsResources.whiteText2,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: SizesResources.s4),
          SizedBox(
            height: 40,
            width: SpacingResources.mainHalfWidth(context),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: BuyTeacherDialogWidget(
                        onUpdate: () {
                          setInfo();
                          setState(() {});
                        },
                        teacher: widget.teacher,
                      ),
                    );
                  },
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  "تفاصيل الاشتراك",
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuyTeacherDialogWidget extends StatefulWidget {
  const BuyTeacherDialogWidget({
    super.key,
    required this.teacher,
    required this.onUpdate,
  });
  final TeacherData teacher;
  final VoidCallback onUpdate;

  @override
  State<BuyTeacherDialogWidget> createState() => _BuyTeacherDialogWidgetState();
}

class _BuyTeacherDialogWidgetState extends State<BuyTeacherDialogWidget> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.75,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        decoration: BoxDecoration(
          color: ColorsResources.darkPrimary,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: SizesResources.s3),
              Text(
                "اشترك لدى المدرس ${widget.teacher.name}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.cyan,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SizesResources.s3),
              Text(
                widget.teacher.purchaseDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: ColorsResources.whiteText2,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: SizesResources.s7),
              Text(
                "السعر : ${widget.teacher.price}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 19,
                  color: ColorsResources.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SizesResources.s7),
              ElevatedButtonWidget(
                text: "اشتراك",
                loading: loading,
                onPressed: loading
                    ? null
                    : () async {
                        setState(() {
                          loading = true;
                        });
                        //
                        List<PurchaseItem> items = [
                          PurchaseItem(
                            amount: widget.teacher.price,
                            itemType: "teacher",
                            itemId: widget.teacher.email,
                          ),
                        ];
                        //
                        await locator<PurchaseListOfItemUC>()
                            .call(items: items)
                            .then((value) {
                          value.fold(
                            (l) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l.text),
                                ),
                              );
                              Navigator.of(context).pop();
                            },
                            (r) {
                              Navigator.of(context).pop();
                              context.read<AuthCubit>().refresh();
                              context.read<GetBankCubit>().refreshBanks();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("تمت عملية الشراء بنجاح"),
                                ),
                              );
                            },
                          );
                        });
                        setState(() {
                          loading = false;
                        });
                        widget.onUpdate();
                      },
                width: SpacingResources.mainHalfWidth(
                  context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FolderItemWidget extends StatelessWidget {
  const FolderItemWidget({
    super.key,
    required this.name,
    this.onTap,
  });
  final String name;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s1,
          ),
          width: SpacingResources.mainWidth(context),
          decoration: BoxDecoration(
            color: ColorsResources.onPrimary,
            boxShadow: ShadowsResources.mainBoxShadow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s4,
                  horizontal: SizesResources.s2,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: SizesResources.s2),
                    //
                    const Icon(
                      Icons.folder,
                      color: ColorsResources.primary,
                    ),
                    //
                    const SizedBox(width: SizesResources.s2),
                    //
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(name),
                    ),
                    //
                    const Spacer(),
                    //
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
