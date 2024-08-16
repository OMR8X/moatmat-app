import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/images_r.dart';
import 'package:moatmat_app/User/Core/resources/shadows_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Features/code/domain/entites/code_center.dart';
import 'package:moatmat_app/User/Presentation/code/views/code_center_v.dart';

class CodeCenterWidget extends StatelessWidget {
  const CodeCenterWidget({super.key, required this.center});
  final CodeCenter center;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: SpacingResources.mainHalfWidth(context),
          decoration: BoxDecoration(
            boxShadow: ShadowsResources.mainBoxShadow,
            borderRadius: BorderRadius.circular(10),
            color: ColorsResources.onPrimary,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CodeCenterView(center: center),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //
                    const SizedBox(height: SizesResources.s6),
                    //
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: SizesResources.s7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Hero(
                            tag: center.id,
                            child: center.icon != null
                                ? Image.network(
                                    center.icon!,
                                    fit: BoxFit.cover,
                                    width: 1000,
                                  )
                                : Image.asset(
                                    ImagesResources.codesCenterImage,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    //
                    const SizedBox(height: SizesResources.s3),
                    //
                    Text(
                      center.name,
                      textAlign: TextAlign.center,
                    ),
                    //
                    const SizedBox(height: SizesResources.s2),
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
