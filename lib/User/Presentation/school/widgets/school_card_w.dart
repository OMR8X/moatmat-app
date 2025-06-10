import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/fonts_r.dart';
import 'package:moatmat_app/User/Core/resources/images_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';

class SchoolCardWidget extends StatelessWidget {
  const SchoolCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: SpacingResources.mainWidth(context),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: 150,
              width: SpacingResources.mainWidth(context),
              decoration: BoxDecoration(
                color: ColorsResources.onPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: SizesResources.s3,
                children: [
                  Text(''),
                  Text(
                    title,
                    style: FontsResources.styleExtraBold(
                      size: 16,
                      color: ColorsResources.primary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: FontsResources.styleMedium(
                      size: 12,
                      color: ColorsResources.darkPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 25.0,
            right: SpacingResources.mainHalfWidth(context) - (SizesResources.iconSchoolSize / 2),
            child: Container(
              width: SizesResources.iconSchoolSize,
              height: SizesResources.iconSchoolSize,
              decoration: BoxDecoration(
                color: ColorsResources.schoolIconBackground,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(SizesResources.s3),
                child: Image.asset(
                  ImagesResources.schoolIcon,
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
