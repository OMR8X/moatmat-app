import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/fonts_r.dart';
import 'package:moatmat_app/User/Core/resources/images_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';

import '../../../Features/school/domain/entities/school.dart';

class SchoolCardWidget extends StatelessWidget {
  const SchoolCardWidget({
    super.key,
    required this.school,
    this.onTap,
  });
  final School school;
  final void Function()? onTap;

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
            child: SizedBox(
              height: 150,
              width: SpacingResources.mainWidth(context),
              child: Card(
                child: InkWell(
                  onTap: onTap,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: SizesResources.s3,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        school.information.name,
                        style: FontsResources.styleExtraBold(
                          size: 16,
                          color: ColorsResources.primary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: SizesResources.s5, vertical: 1),
                        child: Text(
                          school.information.description,
                          textAlign: TextAlign.center,
                          style: FontsResources.styleMedium(
                            size: 12,
                            color: ColorsResources.darkPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                child: Icon(
                  Icons.school,
                  color: ColorsResources.darkPrimary,
                  size: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
