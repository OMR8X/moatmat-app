import 'package:flutter/material.dart';
import 'package:moatmat_app/Presentation/questions/widgets/question_item_widget.dart';

import '../../../../Core/resources/colors_r.dart';
import '../../../../Core/resources/fonts_r.dart';
import '../../../../Core/resources/shadows_r.dart';
import '../../../../Core/resources/sizes_resources.dart';
import '../../../../Core/resources/spacing_resources.dart';
import '../../../../Core/widgets/ui/empty_list_text.dart';
import '../../../../Features/tests/domain/entities/question.dart';

class BankQuestionSearchView extends StatefulWidget {
  const BankQuestionSearchView({
    super.key,
    required this.questions,
    required this.onPick,
  });
  final List<Question> questions;
  final Function(Question question) onPick;
  @override
  State<BankQuestionSearchView> createState() => _BankQuestionSearchViewState();
}

class _BankQuestionSearchViewState extends State<BankQuestionSearchView> {
  final TextEditingController _controller = TextEditingController();
  List<Question> result = [];
  String searchedText = "";
  @override
  void initState() {
    result = widget.questions;
    _controller.addListener(() {
      setState(() {
        searchedText = _controller.value.text;
        result = widget.questions.where((e) {
          if (e.upperImageText?.contains(searchedText) ?? false) {
            return true;
          }
          if (e.lowerImageText?.contains(searchedText) ?? false) {
            return true;
          }
          return false;
        }).toList();
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
            child: result.isEmpty
                ? const EmptyListTextWidget()
                : ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          QuestionItemWidget(
                            question: result[index],
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
