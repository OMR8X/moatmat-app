import 'package:flutter/material.dart';
import 'package:moatmat_app/Core/resources/colors_r.dart';

class EmptyListTextWidget extends StatefulWidget {
  const EmptyListTextWidget({super.key});

  @override
  State<EmptyListTextWidget> createState() => _EmptyListTextWidgetState();
}

class _EmptyListTextWidgetState extends State<EmptyListTextWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "لا يوحد عناصر لعرضها",
        style: TextStyle(
          color: ColorsResources.whiteText1,
        ),
      ),
    );
  }
}
