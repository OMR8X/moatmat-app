import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/shadows_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/purchase/domain/entites/purchase_item.dart';
import 'package:moatmat_app/User/Features/purchase/domain/use_cases/pucrhase_list_of_item.dart';
import 'package:moatmat_app/User/Presentation/auth/state/auth_c/auth_cubit_cubit.dart';
import 'package:moatmat_app/User/Presentation/banks/state/get_bank_c/get_bank_cubit.dart';

class PickBankView extends StatefulWidget {
  const PickBankView({
    super.key,
    required this.title,
    required this.banks,
    required this.onPick,
  });
  final String title;
  final List<(Bank, int)> banks;
  final Function((Bank, int)) onPick;

  @override
  State<PickBankView> createState() => _PickBankViewState();
}

class _PickBankViewState extends State<PickBankView> {
  List<Bank> banks = [];
  @override
  void initState() {
    banks = widget.banks.map((e) => e.$1).toList();
    super.initState();
  }

  bool showPurchaseAll() {
    var list = banks.where((e) => !e.isPurchased()).toList();
    return list.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.read<GetBankCubit>().backToFolders();
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
                color: ColorsResources.whiteText1,
                fontSize: 14,
              ),
            ),
            centerTitle: false,
            leading: IconButton(
              onPressed: () {
                context.read<GetBankCubit>().backToFolders();
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            actions: showPurchaseAll()
                ? [
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => BuyBanksWidget(
                            banks: widget.banks
                                .map((e) => e.$1)
                                .where((e) => !e.isPurchased())
                                .toList(),
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
                  ]
                : null,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: SizesResources.s2),
                    itemCount: widget.banks.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: SizesResources.s1),
                            width: SpacingResources.mainWidth(context),
                            decoration: BoxDecoration(
                              color: ColorsResources.onPrimary,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: ShadowsResources.mainBoxShadow,
                            ),
                            child: ListTile(
                              title: Text(
                                widget.banks[index].$1.information.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsResources.blackText2,
                                ),
                              ),
                              subtitle: Text(
                                "عدد الاسئلة : ${widget.banks[index].$1.questions.length.toString()}",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: ColorsResources.blackText2,
                                ),
                              ),
                              trailing: FilledButton(
                                onPressed: () {
                                  if (widget.banks[index].$1.isPurchased()) {
                                    widget.onPick(widget.banks[index]);
                                  } else {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => BuyBanksWidget(
                                        banks: [widget.banks[index].$1],
                                      ),
                                    );
                                  }
                                },
                                child: widget.banks[index].$1.isPurchased()
                                    ? const Text(
                                        "فتح",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ColorsResources.whiteText1),
                                      )
                                    : Text(
                                        "${widget.banks[index].$1.information.price} نقطة",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ColorsResources.whiteText1),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuyBanksWidget extends StatefulWidget {
  const BuyBanksWidget({
    super.key,
    required this.banks,
  });
  final List<Bank> banks;
  @override
  State<BuyBanksWidget> createState() => _BuyBanksWidgetState();
}

class _BuyBanksWidgetState extends State<BuyBanksWidget> {
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
                  items = widget.banks.map((e) => e.toPurchaseItem()).toList();
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
                      (r) async {
                        await context.read<AuthCubit>().refresh();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("تمت عملية الشراء بنجاح"),
                          ),
                        );
                        Navigator.of(context).pop();
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
    for (var b in widget.banks) {
      items += " ${b.information.title}";
    }
    return items;
  }

  String getPrice() {
    int price = 0;
    for (var b in widget.banks) {
      price += b.information.price;
    }
    return "$price نقطة";
  }

  String getCount() {
    return "${widget.banks.length} عنصر";
  }
}
