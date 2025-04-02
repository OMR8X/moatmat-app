import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Presentation/banks/views/bank_tile_w.dart';
import 'package:moatmat_app/User/Presentation/banks/views/banks/setting_up_banke.dart';

import '../../../../Core/resources/sizes_resources.dart';
import '../../../folders/state/cubit/folders_manager_cubit.dart';
import '../../widgets/test_tile_w.dart';
import 'check_if_test_done_v.dart';

class BankSearchingView extends StatefulWidget {
  const BankSearchingView({super.key, required this.banks, required this.onSelect});
  final List<(Bank, int)> banks;
  final Function((Bank, int)) onSelect;
  @override
  State<BankSearchingView> createState() => _BankSearchingViewState();
}

class _BankSearchingViewState extends State<BankSearchingView> {
  final TextEditingController _controller = TextEditingController();
  List<(Bank, int)> result = [];
  String searchedText = "";
  @override
  void initState() {
    result = widget.banks;
    _controller.addListener(() {
      setState(() {
        searchedText = _controller.value.text;
        result = widget.banks.where((e) => e.$1.information.title.contains(searchedText)).toList();
      });
    });
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(SpacingResources.sidePadding),
            child: TextFormField(
              controller: _controller,
              style: const TextStyle(color: ColorsResources.whiteText1),
              decoration: InputDecoration(
                hintText: "البحث عن اختبار",
                border: const OutlineInputBorder(),
                hintStyle: const TextStyle(color: ColorsResources.whiteText1),
                suffixIcon: IconButton(
                  onPressed: () {
                    _controller.clear();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: ColorsResources.whiteText1,
                  ),
                ),
                icon: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: ColorsResources.whiteText1,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: SizesResources.s2,
              ),
              itemCount: result.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BankTileWidget(
                      bank: result[index].$1,
                      afterBuy: () async {
                        await context.read<FoldersManagerCubit>().refresh();
                        setState(() {});
                      },
                      onPick: () async {
                        widget.onSelect(widget.banks[index]);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
