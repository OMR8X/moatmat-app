import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';
import 'package:moatmat_app/User/Features/purchase/domain/use_cases/pucrhase_list_of_item.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Presentation/auth/state/auth_c/auth_cubit_cubit.dart';
import 'package:moatmat_app/User/Presentation/tests/view/tests/test_searching_v.dart';
import 'package:moatmat_app/User/Presentation/tests/widgets/test_tile_w.dart';

class PickTestView extends StatefulWidget {
  const PickTestView({
    super.key,
    required this.tests,
    required this.onPick,
    required this.onPop,
    required this.title,
  });
  final List<(Test, int)> tests;
  final String title;
  final Function((Test, int)) onPick;
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
          backgroundColor: ColorsResources.primary,
          appBar: AppBar(
            backgroundColor: ColorsResources.primary,
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
                backgroundColor: ColorsResources.primary,
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
          color: ColorsResources.primary,
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
                            content: Text(l.text),
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
  const BuyTestWidget({super.key, required this.test, this.onPick});
  final Test test;
  final VoidCallback? onPick;
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
            Text(
              "المدة : ${getPeriodText()}",
              style: const TextStyle(
                color: ColorsResources.blackText1,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),

            ///
            const SizedBox(height: SizesResources.s1),

            ///
            Text(
              parsOptionAvailabilityText("تصفح الأسئلة بعد الاختبار", widget.test.properties.exploreAnswers == true),
              style: const TextStyle(
                color: ColorsResources.blackText1,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),

            ///
            const SizedBox(height: SizesResources.s1),

            ///
            Text(
              parsOptionAvailabilityText("عرض الإجابات الصحيحة", widget.test.properties.showAnswers == true),
              style: const TextStyle(
                color: ColorsResources.blackText1,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),

            ///
            const SizedBox(height: SizesResources.s1),

            ///
            Text(
              parsOptionAbalebliltyText("قابل للاعادة", widget.test.properties.repeatable == true),
              style: const TextStyle(
                color: ColorsResources.blackText1,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),

            ///
            const SizedBox(height: SizesResources.s1),

            ///
            Text(
              parsOptionExcitabilityText("يوجد اختبار شرطي", widget.test.information.previous != null),
              style: const TextStyle(
                color: ColorsResources.blackText1,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),

            ///
            const SizedBox(height: SizesResources.s1),

            ///
            Text(
              "مقاطع فيديو : ${widget.test.information.video?.length ?? 0}",
              style: const TextStyle(
                color: ColorsResources.blackText1,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),

            ///
            Text(
              "ملفات : ${widget.test.information.files?.length ?? 0}",
              style: const TextStyle(
                color: ColorsResources.blackText1,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),

            ///
            Text(
              "صور : ${widget.test.information.images?.length ?? 0}",
              style: const TextStyle(
                color: ColorsResources.blackText1,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),

            ///
            const SizedBox(height: SizesResources.s3),

            ///
            if ((widget.onPick != null))
              Row(
                children: [
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onPick!();
                    },
                    child: const Text(
                      "فتح",
                      style: TextStyle(fontWeight: FontWeight.bold, color: ColorsResources.whiteText1),
                    ),
                  ),
                ],
              )

            ///
            else
              Row(
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: ColorsResources.red,
                    ),
                    onPressed: loading
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                    child: const Text(
                      "إلغاء",
                    ),
                  ),
                  const SizedBox(width: SizesResources.s2),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: ColorsResources.green,
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
                                      content: Text(l.text),
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
                        ? const CupertinoActivityIndicator()
                        : const Text(
                            "شراء",
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
}
