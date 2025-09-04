import 'package:flutter/material.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';

class FolderItemWidget extends StatelessWidget {
  const FolderItemWidget({
    super.key,
    required this.folder,
    this.onTap,
  });
  final String folder;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s1,
          ),
          width: SpacingResources.mainWidth(context),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                width: 0.5,
                color: ColorsResources.borders,
              ),
            ),
          ),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s4,
                  horizontal: SizesResources.s2,
                ),
                child: Row(
                  children: [
                    //
                    const Icon(
                      Icons.folder,
                      size: 40,
                      color: ColorsResources.primary,
                    ),
                    //
                    const SizedBox(width: SizesResources.s2),
                    //
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        folder,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    //
                    const Spacer(),
                    //
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
