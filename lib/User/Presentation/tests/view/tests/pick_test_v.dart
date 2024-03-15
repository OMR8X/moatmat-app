import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/shadows_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Core/resources/texts_resources.dart';
import 'package:moatmat_app/User/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';
import 'package:moatmat_app/User/Features/purchase/domain/use_cases/pucrhase_list_of_item.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Presentation/auth/state/auth_c/auth_cubit_cubit.dart';
import 'package:moatmat_app/User/Presentation/tests/state/get_test_c/get_test_cubit.dart';
import 'package:moatmat_app/User/Presentation/tests/view/tests/test_searching_v.dart';

class PickTestView extends StatefulWidget {
  const PickTestView({
    super.key,
    required this.tests,
    required this.onPick,
    required this.teacher,
    required this.onPop,
  });
  final List<(Test, int)> tests;
  final String teacher;
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${AppBarTitles.pickTest} ${widget.teacher}",
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
                          tests: widget.tests
                              .map((e) => e.$1)
                              .where((e) => !e.isPurchased())
                              .toList(),
                        ),
                      );
                    },
                    child: const Text("شراء الكل"),
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
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            padding: const EdgeInsets.symmetric(vertical: SizesResources.s2),
            itemCount: widget.tests.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: SpacingResources.mainHalfWidth(context),
                      height: SpacingResources.mainHalfWidth(context),
                      padding: const EdgeInsets.symmetric(
                        vertical: SizesResources.s3,
                      ),
                      decoration: BoxDecoration(
                        color: ColorsResources.onPrimary,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: ShadowsResources.mainBoxShadow,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            widget.tests[index].$1.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorsResources.blackText2,
                            ),
                          ),
                          getSubTitle(index),
                          Text(
                            "${widget.tests[index].$1.questions.length.toString()} سؤال",
                            style: const TextStyle(
                              fontSize: 10,
                              color: ColorsResources.blackText2,
                            ),
                          ),
                          FilledButton(
                            onPressed: () {
                              var test = widget.tests[index].$1;
                              if (test.isPurchased()) {
                                //
                                if (test.password != null &&
                                    test.password!.isNotEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        EnterTestPasswordWidget(
                                      password: test.password!,
                                      onOpen: () {
                                        widget.onPick(widget.tests[index]);
                                      },
                                    ),
                                  );
                                } else {
                                  widget.onPick(widget.tests[index]);
                                }
                                //
                              } else {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => BuyTestsWidget(
                                    tests: [test],
                                  ),
                                );
                              }
                            },
                            child: widget.tests[index].$1.isPurchased()
                                ? const Text(
                                    "فتح",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorsResources.whiteText1),
                                  )
                                : Text(
                                    "${widget.tests[index].$1.cost} نقطة",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorsResources.whiteText1),
                                  ),
                          ),
                        ],
                      )),
                ],
              );
            }),
      ),
    );
  }

  Widget getSubTitle(int index) {
    var test = widget.tests[index].$1;
    if (test.password != null && test.password!.isNotEmpty) {
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
  State<EnterTestPasswordWidget> createState() =>
      _EnterTestPasswordWidgetState();
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
      title: const Text("عملية شراء"),
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
                  "الغاء",
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
                        context.read<GetTestCubit>().refreshTests();
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
      items += " ${b.title}";
    }
    return items;
  }

  String getPrice() {
    int price = 0;
    for (var b in widget.tests) {
      price += b.cost ?? 0;
    }
    return "$price نقطة";
  }

  String getCount() {
    return "${widget.tests.length} عنصر";
  }
}
