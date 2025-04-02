import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Presentation/banks/state/get_bank_c/get_bank_cubit.dart';

import '../../../../Core/resources/sizes_resources.dart';
import '../../widgets/test_tile_w.dart';
import 'check_if_test_done_v.dart';

class TestSearchingView extends StatefulWidget {
  const TestSearchingView({super.key, required this.tests, required this.onSelect});
  final List<(Test, int)> tests;
  final Function((Test, int)) onSelect;
  @override
  State<TestSearchingView> createState() => _TestSearchingViewState();
}

class _TestSearchingViewState extends State<TestSearchingView> {
  final TextEditingController _controller = TextEditingController();
  List<(Test, int)> result = [];
  String searchedText = "";
  @override
  void initState() {
    result = widget.tests;
    _controller.addListener(() {
      setState(() {
        searchedText = _controller.value.text;
        result = widget.tests.where((e) => e.$1.information.title.contains(searchedText)).toList();
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
                    TestTileWidget(
                      test: result[index].$1,
                      onBuy: () {
                        setState(() {});
                      },
                      onPick: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CheckIfTestDone(
                              test: result[index].$1,
                            ),
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
      )),
    );
  }
}
