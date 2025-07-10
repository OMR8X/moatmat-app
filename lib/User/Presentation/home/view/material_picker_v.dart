import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/constant/materials.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';

class MaterialPickerView extends StatefulWidget {
  const MaterialPickerView({
    super.key,
    required this.material,
    required this.onPick,
  });
  final List<String> material;
  final Function(String) onPick;
  @override
  State<MaterialPickerView> createState() => _MaterialPickerViewState();
}

class _MaterialPickerViewState extends State<MaterialPickerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      appBar: AppBar(
        title: Text(
          "اختر مدرسك بحسب كل مادة",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorsResources.whiteText1,
          ),
        ),
        backgroundColor: ColorsResources.primary,
        foregroundColor: ColorsResources.whiteText1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     SizedBox(
            //       width: SpacingResources.mainWidth(context) - 5,
            //       child: Text(
            //         "المنابر التعليمية :",
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w500,
            //           color: ColorsResources.whiteText1,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // GridView.builder(
            //   physics: NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   padding: const EdgeInsets.only(
            //     top: SizesResources.s2,
            //     left: SpacingResources.sidePadding,
            //     right: SpacingResources.sidePadding,
            //     bottom: SizesResources.s2,
            //   ),
            //   itemCount: materialsLst.length - 14,
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     childAspectRatio: 1.2,
            //     crossAxisSpacing: SizesResources.s2,
            //     mainAxisSpacing: SizesResources.s2,
            //   ),
            //   itemBuilder: (context, index) {
            //     index = index + 14;
            //     return Container(
            //       width: SpacingResources.mainHalfWidth(context) * 0.75,
            //       height: SpacingResources.mainHalfWidth(context) * 0.75,
            //       decoration: BoxDecoration(
            //           color: ColorsResources.onPrimary,
            //           borderRadius: BorderRadius.circular(36),
            //           border: Border.all(
            //             color: ColorsResources.darkPrimary,
            //           )),
            //       child: Material(
            //         color: Colors.transparent,
            //         borderRadius: BorderRadius.circular(12),
            //         child: InkWell(
            //           borderRadius: BorderRadius.circular(12),
            //           onTap: () {
            //             widget.onPick(widget.material[index]);
            //           },
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               ClipRRect(
            //                 borderRadius: BorderRadius.circular(100),
            //                 child: CircleAvatar(
            //                   radius: SpacingResources.mainHalfWidth(context) / 5,
            //                   backgroundColor: ColorsResources.background,
            //                   child: Image.asset(
            //                     materialsLst[index]["image"]!,
            //                     color: ColorsResources.onPrimary,
            //                     colorBlendMode: BlendMode.darken,
            //                   ),
            //                 ),
            //               ),
            //               const SizedBox(height: SizesResources.s4),
            //               Text(
            //                 materialsLst[index]["name"]!,
            //                 style: const TextStyle(
            //                   fontSize: 11,
            //                   fontWeight: FontWeight.w600,
            //                   color: ColorsResources.primary,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // ),
            // Divider(
            //   endIndent: SpacingResources.sidePadding,
            //   indent: SpacingResources.sidePadding,
            //   color: Colors.white12,
            //   height: SizesResources.s4,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     SizedBox(
            //       width: SpacingResources.mainWidth(context) - 5,
            //       child: Text(
            //         "اختر مدرسك بحسب كل مادة :",
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w500,
            //           color: ColorsResources.whiteText1,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: SizesResources.s2),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                top: SizesResources.s2,
                left: SpacingResources.sidePadding,
                right: SpacingResources.sidePadding,
                bottom: SizesResources.s10 * 2,
              ),
              itemCount: 14,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: SizesResources.s2,
                mainAxisSpacing: SizesResources.s2,
              ),
              itemBuilder: (context, index) {
                return Container(
                  width: SpacingResources.mainHalfWidth(context),
                  height: SpacingResources.mainHalfWidth(context),
                  decoration: BoxDecoration(
                    color: ColorsResources.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: ShadowsResources.mainBoxShadow,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        widget.onPick(widget.material[index]);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: SpacingResources.mainHalfWidth(context) / 4,
                            backgroundColor: ColorsResources.background,
                            child: Image.asset(
                              materialsLst[index]["image"]!,
                              color: ColorsResources.onPrimary,
                              colorBlendMode: BlendMode.darken,
                            ),
                          ),
                          const SizedBox(height: SizesResources.s4),
                          Text(
                            materialsLst[index]["name"]!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ColorsResources.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
