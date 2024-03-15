import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank_q.dart';
import 'package:moatmat_app/User/Presentation/banks/views/question_v.dart';

import '../../../../Core/resources/colors_r.dart';
import '../../../../Core/resources/fonts_r.dart';
import '../../../../Core/resources/shadows_r.dart';
import '../../../../Core/resources/sizes_resources.dart';
import '../../../../Core/resources/spacing_resources.dart';
import '../../../home/view/deep_link_view.dart';

class BankQuestionSearchView extends StatefulWidget {
  const BankQuestionSearchView({
    super.key,
    required this.questions,
    required this.onPick,
  });
  final List<BankQuestion> questions;
  final Function(BankQuestion question) onPick;
  @override
  State<BankQuestionSearchView> createState() => _BankQuestionSearchViewState();
}

class _BankQuestionSearchViewState extends State<BankQuestionSearchView> {
  final TextEditingController _controller = TextEditingController();
  List<BankQuestion> result = [];
  String searchedText = "";
  @override
  void initState() {
    result = widget.questions;
    _controller.addListener(() {
      setState(() {
        searchedText = _controller.value.text;
        result = widget.questions
            .where((e) => (e.question?.contains(searchedText) ?? false))
            .toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(SpacingResources.sidePadding),
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "البحث عن اختبارات استاذ",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _controller.clear();
                  },
                  icon: const Icon(Icons.replay),
                ),
                icon: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: SizesResources.s1),
                        width: SpacingResources.mainWidth(context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: ShadowsResources.mainBoxShadow,
                          color: ColorsResources.onPrimary,
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.of(context).pop();
                              widget.onPick(result[index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(SizesResources.s4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        result[index].question ?? "",
                                        style: FontsResources.lightStyle()
                                            .copyWith(
                                          color: ColorsResources.blackText1,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: ColorsResources.blackText2,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ],
      )),
    );
  }
}
