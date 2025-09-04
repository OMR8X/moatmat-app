import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Core/resources/colors_r.dart';

import 'package:moatmat_app/Core/resources/texts_resources.dart';
import 'package:moatmat_app/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_app/Core/widgets/ui/empty_list_text.dart';
import 'package:moatmat_app/Presentation/banks/state/get_bank_c/get_bank_cubit.dart';

class PickCategoryView extends StatefulWidget {
  const PickCategoryView({
    super.key,
    required this.categories,
    required this.onPick,
    required this.title,
    this.subCategories,
    this.onPop,
    this.actions,
    this.values,
  });
  final String title;
  final List<String>? subCategories;
  final List<String> categories;
  final List<String>? values;
  final Function(String) onPick;
  final VoidCallback? onPop;
  final List<Widget>? actions;
  @override
  State<PickCategoryView> createState() => _PickCategoryViewState();
}

class _PickCategoryViewState extends State<PickCategoryView> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (widget.onPop != null) {
          widget.onPop!();
        } else {
          Navigator.of(context).pop();
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
            ),
          ),
          leading: widget.onPop != null
              ? IconButton(
                  onPressed: widget.onPop,
                  icon: const Icon(Icons.arrow_back_ios),
                )
              : null,
          actions: widget.actions,
        ),
        body: widget.categories.isEmpty
            ? const EmptyListTextWidget()
            : ListView.builder(
                itemCount: widget.categories.length,
                itemBuilder: (context, index) => TouchableTileWidget(
                  title: widget.categories[index],
                  subTitle: widget.subCategories != null ? widget.subCategories![index] : null,
                  iconData: Icons.arrow_forward_ios,
                  onTap: () {
                    if (widget.values != null) {
                      widget.onPick(widget.values![index]);
                    } else {
                      widget.onPick(widget.categories[index]);
                    }
                  },
                ),
              ),
      ),
    );
  }
}
