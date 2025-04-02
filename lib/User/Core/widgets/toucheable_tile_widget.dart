import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/functions/coders/decode.dart';

import '../resources/colors_r.dart';
import '../resources/fonts_r.dart';
import '../resources/shadows_r.dart';
import '../resources/sizes_resources.dart';
import '../resources/spacing_resources.dart';

class TouchableTileWidget extends StatelessWidget {
  const TouchableTileWidget({
    super.key,
    required this.title,
    this.iconData,
    this.onTap,
    this.subTitle,
    this.subTitle2,
    this.icon,
  });
  final String title;
  final String? subTitle;
  final String? subTitle2;
  final IconData? iconData;
  final Widget? icon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: SizesResources.s1),
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
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(SizesResources.s4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (title),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: FontsResources.styleLight().copyWith(
                              color: ColorsResources.blackText1,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          if (subTitle != null) ...[
                            const SizedBox(height: SizesResources.s2),
                            Text(
                              subTitle!,
                              textAlign: TextAlign.start,
                              style: FontsResources.styleRegular().copyWith(
                                color: ColorsResources.blackText2,
                                fontSize: 12,
                              ),
                            ),
                          ],
                          if (subTitle2 != null) ...[
                            const SizedBox(height: SizesResources.s2),
                            Text(
                              subTitle2!,
                              textAlign: TextAlign.start,
                              style: FontsResources.styleRegular().copyWith(
                                color: ColorsResources.blackText2,
                                fontSize: 12,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    Icon(
                      iconData,
                      color: ColorsResources.blackText2,
                      size: 12,
                    ),
                    if (icon != null) icon!,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
