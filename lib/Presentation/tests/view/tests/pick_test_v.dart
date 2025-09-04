import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Core/injection/app_inj.dart';
import 'package:moatmat_app/Core/resources/colors_r.dart';
import 'package:moatmat_app/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_app/Features/purchase/domain/entites/purchase_item.dart';
import 'package:moatmat_app/Features/purchase/domain/use_cases/pucrhase_list_of_item.dart';
import 'package:moatmat_app/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/Presentation/auth/state/auth_c/auth_cubit_cubit.dart';
import 'package:moatmat_app/Presentation/tests/view/tests/test_searching_v.dart';
import 'package:moatmat_app/Presentation/tests/widgets/test_tile_w.dart';

class PickTestView extends StatefulWidget {
  const PickTestView({
    super.key,
    required this.tests,
    required this.onPick,
    required this.onPop,
    required this.title,
    required this.onDownload,
  });
  final List<(Test, int)> tests;
  final String title;
  final Function((Test, int)) onPick;
  final Function(int) onDownload;
  final VoidCallback onPop;

  @override
  State<PickTestView> createState() => _PickTestViewState();
}

class _PickTestViewState extends State<PickTestView> {
  List<Test> tests = [];
  @override
  void initState() {
    tests = widget.tests.map((e) => e.$1).toList();
    super.initState();
  }

  bool showPurchaseAll() {
    var list = tests.where((e) => !e.isPurchased()).toList();
    return list.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        widget.onPop();
      },
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthDone) {
            setState(() {});
          }
        },
        child: Scaffold(
          backgroundColor: ColorsResources.darkPrimary,
          appBar: AppBar(
            backgroundColor: ColorsResources.darkPrimary,
            foregroundColor: ColorsResources.whiteText1,
            title: Text(
              widget.title,
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
            actions: showPurchaseAll()
                ? [
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => BuyTestsWidget(
                            tests: widget.tests.map((e) => e.$1).where((e) => !e.isPurchased()).toList(),
                          ),
                        );
                      },
                      child: const Text(
                        "شراء الكل",
                        style: TextStyle(
                          color: ColorsResources.whiteText2,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TestSearchingView(
                                  tests: widget.tests,
                                  onSelect: (t) {
                                    Navigator.of(context).pop();
                                    widget.onPick(t);
                                  },
                                )));
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ]
                : [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TestSearchingView(
                                  tests: widget.tests,
                                  onSelect: (t) {
                                    Navigator.of(context).pop();
                                    widget.onPick(t);
                                  },
                                )));
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ],
          ),
          body: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: SizesResources.s2,
                  ),
                  itemCount: widget.tests.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TestTileWidget(
                          test: widget.tests[index].$1,
                          onPick: () {
                            showDialog(
                              context: context,
                              builder: (context) => BuyTestWidget(
                                test: widget.tests[index].$1,
                                onPick: () {
                                  widget.onPick(widget.tests[index]);
                                },
                                onDownload: (testId) {
                                  widget.onDownload(testId);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSubTitle(int index) {
    var test = widget.tests[index].$1;
    if (test.information.password != null && test.information.password!.isNotEmpty) {
      return const Text(
        "كلمة السر مطلوبة",
        style: TextStyle(
          fontSize: 10,
          color: ColorsResources.darkPrimary,
        ),
      );
    }
    return const Text(
      "كلمة السر غير مطلوبة",
      style: TextStyle(
        fontSize: 10,
        color: ColorsResources.borders,
      ),
    );
  }
}

class EnterTestPasswordWidget extends StatefulWidget {
  const EnterTestPasswordWidget({
    super.key,
    required this.password,
    required this.onOpen,
  });
  final String password;
  final VoidCallback onOpen;
  @override
  State<EnterTestPasswordWidget> createState() => _EnterTestPasswordWidgetState();
}

class _EnterTestPasswordWidgetState extends State<EnterTestPasswordWidget> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.symmetric(),
      title: const Text("ادخال كلمة المرور"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextFormFieldWidget(
              width: SpacingResources.mainHalfWidth(
                context,
              ),
              validator: (p0) {
                if (p0 == null) {
                  return "لا يمكن ترك الحقل فارغ";
                }
                if (p0.isEmpty) {
                  return "لا يمكن ترك الحقل فارغ";
                }
                if (p0 != widget.password) {
                  return "كلمة المرور غير مطابقة";
                }
                return null;
              },
            ),
            const SizedBox(height: SizesResources.s4),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: ColorsResources.darkPrimary,
              ),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();
                  widget.onOpen();
                }
              },
              child: const Text(
                "فتح الاختبار",
              ),
            ),
          ],
        ),
      ),
      actions: const [],
    );
  }
}

class BuyTestsWidget extends StatefulWidget {
  const BuyTestsWidget({
    super.key,
    required this.tests,
  });
  final List<Test> tests;
  @override
  State<BuyTestsWidget> createState() => _BuyTestsWidgetState();
}

class _BuyTestsWidgetState extends State<BuyTestsWidget> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "عملية شراء",
        style: TextStyle(
          color: ColorsResources.darkPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: Text("نوع العنصر : ${getItems()}"),
          ),
          SizedBox(
            child: Text("تكلفة العنصر : ${getPrice()}"),
          ),
          SizedBox(
            child: Text("العدد : ${getCount()}"),
          ),
        ],
      ),
      actions: loading
          ? [
              const Center(
                child: CupertinoActivityIndicator(),
              )
            ]
          : [
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: ColorsResources.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "إلغاء",
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: ColorsResources.green,
                ),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  //
                  List<PurchaseItem> items = [];
                  //
                  items = widget.tests.map((e) => e.toPurchaseItem()).toList();
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
                      (r) async {
                        //
                        await context.read<AuthCubit>().refresh();
                        //
                        Navigator.of(context).pop();
                        //
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("تمت عملية الشراء بنجاح"),
                          ),
                        );
                      },
                    );
                  });
                },
                child: const Text(
                  "شراء",
                ),
              ),
            ],
    );
  }

  String getItems() {
    String items = "";
    for (var b in widget.tests) {
      items += " ${b.information.title}";
    }
    return items;
  }

  String getPrice() {
    int price = 0;
    for (var b in widget.tests) {
      price += b.information.price ?? 0;
    }
    return "$price نقطة";
  }

  String getCount() {
    return "${widget.tests.length} عنصر";
  }
}

class BuyTestWidget extends StatefulWidget {
  const BuyTestWidget({super.key, required this.test, this.onPick, this.onDownload});
  final Test test;
  final VoidCallback? onPick;
  final Function(int)? onDownload;
  @override
  State<BuyTestWidget> createState() => _BuyTestWidgetState();
}

class _BuyTestWidgetState extends State<BuyTestWidget> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ///
            const SizedBox(height: SizesResources.s3),

            ///
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: "Tajawal",
                      ),
                      children: [
                        TextSpan(
                          text: widget.test.information.title,
                          style: const TextStyle(
                            color: ColorsResources.blackText1,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: "  ${widget.test.questions.length} سؤال",
                          style: const TextStyle(
                            color: ColorsResources.blackText2,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            ///
            const SizedBox(height: SizesResources.s3),

            ///
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ColorsResources.primary.withAlpha(20),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_filled,
                    size: 18,
                    color: ColorsResources.darkPrimary,
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      "المدة : ${getPeriodText()}",
                      style: const TextStyle(
                        color: ColorsResources.blackText1,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ///
            const SizedBox(height: SizesResources.s2),

            ///
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: ColorsResources.primary.withAlpha(20),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildOptionRow(
                    icon: widget.test.properties.exploreAnswers == true ? Icons.visibility : Icons.visibility_off,
                    color: widget.test.properties.exploreAnswers == true ? ColorsResources.darkPrimary : ColorsResources.borders,
                    text: parsOptionAvailabilityText("تصفح الأسئلة بعد الاختبار", widget.test.properties.exploreAnswers == true),
                    isEnabled: widget.test.properties.exploreAnswers == true,
                  ),
                  const SizedBox(height: 10),
                  _buildOptionRow(
                    icon: widget.test.properties.showAnswers == true ? Icons.quiz : Icons.quiz_outlined,
                    color: widget.test.properties.showAnswers == true ? ColorsResources.darkPrimary : ColorsResources.borders,
                    text: parsOptionAvailabilityText("عرض الإجابات الصحيحة", widget.test.properties.showAnswers == true),
                    isEnabled: widget.test.properties.showAnswers == true,
                  ),
                  const SizedBox(height: 10),
                  _buildOptionRow(
                    icon: widget.test.properties.repeatable == true ? Icons.refresh : Icons.block,
                    color: widget.test.properties.repeatable == true ? ColorsResources.darkPrimary : ColorsResources.borders,
                    text: parsOptionAbalebliltyText("قابل للاعادة", widget.test.properties.repeatable == true),
                    isEnabled: widget.test.properties.repeatable == true,
                  ),
                  const SizedBox(height: 10),
                  _buildOptionRow(
                    icon: widget.test.information.previous != null ? Icons.link : Icons.link_off,
                    color: widget.test.information.previous != null ? ColorsResources.darkPrimary : ColorsResources.borders,
                    text: parsOptionExcitabilityText("يوجد اختبار شرطي", widget.test.information.previous != null),
                    isEnabled: widget.test.information.previous != null,
                  ),
                  const SizedBox(height: 10),
                  _buildOptionRow(
                    icon: widget.test.properties.downloadable == true ? Icons.download_rounded : Icons.download_outlined,
                    color: widget.test.properties.downloadable == true ? ColorsResources.darkPrimary : ColorsResources.borders,
                    text: parsOptionExcitabilityText("يمكن تنزيل الاختبار", widget.test.properties.downloadable != null),
                    isEnabled: widget.test.properties.downloadable != null,
                  ),
                ],
              ),
            ),

            ///
            const SizedBox(height: SizesResources.s3),

            ///
            if (_hasAnyAssets())
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ColorsResources.darkPrimary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    if (_hasVideos())
                      _buildOptionRow(
                        icon: Icons.video_library,
                        color: ColorsResources.blueText,
                        text: "مقاطع فيديو : ${widget.test.information.videos?.length ?? 0}",
                        isEnabled: true,
                      ),
                    if (_hasVideos() && (_hasFiles() || _hasImages())) const SizedBox(height: SizesResources.s1),
                    if (_hasFiles())
                      _buildOptionRow(
                        icon: Icons.attach_file,
                        color: ColorsResources.orangeText,
                        text: "ملفات : ${widget.test.information.files?.length ?? 0}",
                        isEnabled: true,
                      ),
                    if (_hasFiles() && _hasImages()) const SizedBox(height: SizesResources.s1),
                    if (_hasImages())
                      _buildOptionRow(
                        icon: Icons.image,
                        color: ColorsResources.greenText,
                        text: "صور : ${widget.test.information.images?.length ?? 0}",
                        isEnabled: true,
                      ),
                  ],
                ),
              ),

            ///
            const SizedBox(height: SizesResources.s3),

            ///
            if ((widget.onPick != null))
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: ColorsResources.primary,
                        foregroundColor: ColorsResources.whiteText1,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onPick!();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.play_arrow_rounded,
                            size: 18,
                            color: ColorsResources.whiteText1,
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: const Text(
                              "فتح الاختبار",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                        ],
                      ),
                    ),
                  ),
                  if (_isDownloadable()) ...[
                    const SizedBox(height: SizesResources.s1),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColorsResources.primary,
                          backgroundColor: ColorsResources.primary.withAlpha(10),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: ColorsResources.primary.withAlpha(60),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onDownload?.call(widget.test.id);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.download_rounded,
                              size: 18,
                              color: ColorsResources.primary.withAlpha(200),
                            ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                "تنزيل الاختبار",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: ColorsResources.primary.withAlpha(200),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                          ],
                        ),
                      ),
                    ),
                  ]
                ],
              )

            ///
            else
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: ColorsResources.primary,
                        foregroundColor: ColorsResources.whiteText1,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: loading
                          ? null
                          : () async {
                              setState(() {
                                loading = true;
                              });

                              //
                              await locator<PurchaseListOfItemUC>().call(items: [widget.test.toPurchaseItem()]).then((value) {
                                value.fold(
                                  (l) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l.message),
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  (r) async {
                                    //
                                    await context.read<AuthCubit>().refresh();
                                    //
                                    Navigator.of(context).pop();
                                    //
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("تمت عملية الشراء بنجاح"),
                                      ),
                                    );
                                  },
                                );
                              });
                            },
                      child: loading
                          ? const CupertinoActivityIndicator(color: ColorsResources.whiteText1)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.shopping_cart_rounded,
                                  size: 18,
                                  color: ColorsResources.whiteText1,
                                ),
                                const SizedBox(width: 8),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    "شراء الاختبار - ${widget.test.information.price ?? 0} نقطة",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: SizesResources.s2),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorsResources.primary,
                        backgroundColor: ColorsResources.primary.withOpacity(0.04),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: ColorsResources.primary.withOpacity(0.6),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: loading
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: ColorsResources.blackText2,
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: const Text(
                              "إلغاء",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String getPeriodText() {
    if (widget.test.information.period == null) {
      return "وقت مفتوح";
    }
    return "  ${widget.test.information.period! ~/ 60} دقيقة";
  }

  String parsOptionAvailabilityText(String text, bool allowed) {
    String result = allowed ? "يسمح ب" : "غير مسموح ب";
    return result + text;
  }

  String parsOptionAbalebliltyText(String text, bool allowed) {
    String result = allowed ? "" : "غير ";
    return result + text;
  }

  String parsOptionExcitabilityText(String text, bool allowed) {
    String result = allowed ? "" : "لا ";
    return result + text;
  }

  Widget _buildOptionRow({
    required IconData icon,
    required Color color,
    required String text,
    required bool isEnabled,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              text,
              style: TextStyle(
                color: isEnabled ? ColorsResources.blackText1 : ColorsResources.blackText2,
                fontWeight: isEnabled ? FontWeight.w500 : FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _isDownloadable() {
    // if (kDebugMode) return true;
    return widget.test.properties.downloadable == true;
  }

  bool _hasVideos() {
    return widget.test.information.videos != null && widget.test.information.videos!.isNotEmpty;
  }

  bool _hasFiles() {
    return widget.test.information.files != null && widget.test.information.files!.isNotEmpty;
  }

  bool _hasImages() {
    return widget.test.information.images != null && widget.test.information.images!.isNotEmpty;
  }

  bool _hasAnyAssets() {
    return (_hasVideos() || _hasFiles() || _hasImages());
  }
}
