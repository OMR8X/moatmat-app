import 'package:flutter/material.dart';

import '../resources/colors_r.dart';
import '../resources/sizes_resources.dart';
import '../resources/spacing_resources.dart';

class FeatureCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? borderColor;

  const FeatureCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: SpacingResources.mainWidth(context),
      decoration: BoxDecoration(
        color: (backgroundColor ?? ColorsResources.primary).withAlpha(50),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor ?? ColorsResources.darkPrimary,
          width: 2,
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: _CardContent(
            title: title,
            icon: icon,
            textColor: textColor ?? ColorsResources.primary,
            iconColor: iconColor ?? ColorsResources.primary,
          ),
        ),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color textColor;
  final Color iconColor;

  const _CardContent({
    required this.title,
    required this.icon,
    required this.textColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: SizesResources.s3),
        Icon(
          icon,
          size: 26,
          color: iconColor,
        ),
      ],
    );
  }
}
