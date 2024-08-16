import 'package:flutter/material.dart';

import '../../resources/sizes_resources.dart';
import '../../resources/spacing_resources.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SpacingResources.sidePadding,
        vertical: SizesResources.s2,
      ),
      child: Divider(),
    );
  }
}
