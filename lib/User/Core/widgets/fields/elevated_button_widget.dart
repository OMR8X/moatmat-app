import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../resources/colors_r.dart';
import '../../resources/spacing_resources.dart';

class ElevatedButtonWidget extends StatelessWidget {
  const ElevatedButtonWidget({
    super.key,
    this.onPressed,
    required this.text,
    this.isWhite = false,
    this.loading = false, this.width,
  });
  final String text;
  final bool isWhite, loading;
  final void Function()? onPressed;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:width?? SpacingResources.mainWidth(context),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          backgroundColor: isWhite ? ColorsResources.whiteText1 : null,
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : Text(
                text,
                style: TextStyle(
                  color: isWhite
                      ? ColorsResources.darkPrimary
                      : ColorsResources.whiteText1,
                ),
              ),
      ),
    );
  }
}
