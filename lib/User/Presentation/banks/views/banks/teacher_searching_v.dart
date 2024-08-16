import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_app/User/Presentation/banks/state/get_bank_c/get_bank_cubit.dart';

class TeacherSearchView extends StatefulWidget {
  const TeacherSearchView(
      {super.key, required this.teachers, required this.onSelect});
  final List<(TeacherData, int)> teachers;
  final Function(TeacherData) onSelect;
  @override
  State<TeacherSearchView> createState() => _TeacherSearchViewState();
}

class _TeacherSearchViewState extends State<TeacherSearchView> {
  final TextEditingController _controller = TextEditingController();
  List<TeacherData> result = [];
  String searchedText = "";
  @override
  void initState() {
    result = widget.teachers.map((e) => e.$1).toList();
    _controller.addListener(() {
      setState(() {
        searchedText = _controller.value.text;
        result = widget.teachers
            .map((e) => e.$1)
            .where((e) => e.name.contains(searchedText))
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
              itemBuilder: (context, index) => TouchableTileWidget(
                title: result[index].name,
                iconData: Icons.arrow_forward_ios,
                onTap: () {
                  widget.onSelect(result[index]);
                  context.read<GetBankCubit>().selectTeacher(
                        result[index],
                      );
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      )),
    );
  }
}
