import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_app/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_app/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_app/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/Presentation/folders/view/folders_views_manager.dart';

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
import '../ui/empty_list_text.dart';

class PickFolderView extends StatefulWidget {
  const PickFolderView({
    super.key,
    this.onSearch,
    required this.afterPick,
    required this.teacher,
    this.onPop,
    required this.isTest,
    required this.material,
  });
  final String? material;
  final VoidCallback? onSearch;
  final TeacherData teacher;
  final bool isTest;
  final VoidCallback? onPop;
  final Function(String key) afterPick;

  @override
  State<PickFolderView> createState() => _PickFolderViewState();
}

class _PickFolderViewState extends State<PickFolderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      appBar: AppBar(
        backgroundColor: ColorsResources.primary,
        foregroundColor: ColorsResources.whiteText1,
        title: Text(
          "مجلدات ${widget.isTest ? "اختبارات" : "بنوك"} ${widget.teacher.name}",
          style: const TextStyle(
            fontSize: 14,
            color: ColorsResources.whiteText1,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: widget.onPop ??
              () {
                Navigator.of(context).pop();
              },
          icon: const Icon(Icons.close),
        ),
        actions: [
          if (widget.onSearch != null)
            IconButton(
              onPressed: () {
                widget.onSearch!();
              },
              icon: const Icon(Icons.search),
            ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: SizesResources.s2),
          BuyTeacherWidget(teacher: widget.teacher),
          const SizedBox(height: SizesResources.s2),
          TouchableTileWidget(
            title: "لمحة حول ${widget.teacher.name}",
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
            child: FoldersViewManager(
              title: "",
              teacher: widget.teacher,
              material: widget.material,
              isTest: widget.isTest,
              openContent: (id) {},
              onPop: widget.onPop,
              directories: widget.isTest ? widget.teacher.testsFolders : widget.teacher.banksFolders,
            ),
          ),
        ],
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
            "اشترك لدى  ${widget.teacher.name}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.cyan,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SizesResources.s1),
          Text(
            "اشترك لدى  ${widget.teacher.name} للحصول على كامل محتوى المدرس من الاختبارات والبنوك التي ستنشر على مدى العام الدراسي",
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
        // height: MediaQuery.sizeOf(context).height * 0.50,
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: SizesResources.s3),
                Text(
                  "اشترك لدى  ${widget.teacher.name}",
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
                              userName: locator<UserData>().name,
                              amount: widget.teacher.price,
                              itemType: "teacher",
                              itemId: widget.teacher.email,
                            ),
                          ];
                          //
                          await locator<PurchaseListOfItemUC>().call(items: items).then((value) {
                            value.fold(
                              (l) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l.message),
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
          width: SpacingResources.mainWidth(context),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                width: 0.5,
                color: Colors.white24,
              ),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
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
                      color: ColorsResources.orangeText,
                    ),
                    //
                    const SizedBox(width: SizesResources.s2),
                    //
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          name,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: ColorsResources.whiteText1,
                          ),
                        ),
                      ),
                    ),
                    //
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: ColorsResources.whiteText1,
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
