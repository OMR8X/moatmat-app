import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Presentation/banks/state/get_bank_c/get_bank_cubit.dart';

class TestSearchingView extends StatefulWidget {
  const TestSearchingView(
      {super.key, required this.tests, required this.onSelect});
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
        result = widget.tests
            .where((e) => e.$1.information.title.contains(searchedText))
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
                hintText: "البحث عن اختبار",
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
              itemBuilder: (context, index) => TouchableTileWidget(
                title: result[index].$1.information.title,
                iconData: Icons.arrow_forward_ios,
                onTap: () {
                  widget.onSelect(result[index]);
                },
              ),
            ),
          ),
        ],
      )),
    );
  }
}
