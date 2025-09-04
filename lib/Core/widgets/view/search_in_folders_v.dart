import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../resources/sizes_resources.dart';
import '../fields/text_input_field.dart';
import '../toucheable_tile_widget.dart';

class SearchInFoldersView extends StatefulWidget {
  const SearchInFoldersView({
    super.key,
    required this.folders,
    required this.onPick,
  });
  final List<String> folders;
  final void Function(String folder) onPick;
  @override
  State<SearchInFoldersView> createState() => _SearchInFoldersViewState();
}

class _SearchInFoldersViewState extends State<SearchInFoldersView> {
  //
  late TextEditingController _controller;
  //
  List<String> folders = [];
  //
  List<String> search = [];
  //
  @override
  void initState() {
    //
    folders = widget.folders.where((e) => e.isNotEmpty).toList();
    //
    search = folders;
    //
    _controller = TextEditingController();
    //
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        search = folders;
      } else {
        search = folders.where((e) {
          return e.split("/").last.contains(_controller.text);
        }).toList();
      }
      //
      setState(() {});
      //
    });
    //
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("البحث عن مجلدات"),
      ),
      body: Column(
        children: [
          //
          const SizedBox(height: SizesResources.s2),
          //
          MyTextFormFieldWidget(
            controller: _controller,
          ),
          //
          const SizedBox(height: SizesResources.s2),
          //
          Expanded(
            child: ListView.builder(
              itemCount: search.length,
              itemBuilder: (context, index) {
                return TouchableTileWidget(
                  title: search[index].split("/").last,
                  iconData: Icons.arrow_forward_ios,
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onPick(search[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
