

import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/fonts_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';

class VideoIconsWidget extends StatelessWidget {
  const VideoIconsWidget({
    super.key,
    required this.text1,
    required this.text2,
    required this.icon,
  });

  final String text1;
  final String text2;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column( 
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          Padding(padding: EdgeInsets.only(top: SizesResources.s2)),
          Text(
            text1,
            style: FontsResources.styleMedium(size: 12),
          ),
          Text(
            text2,
            style: FontsResources.styleMedium(size: 12),
          ),
        ],
      ),
    );
  }
}
