import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:moatmat_app/User/Core/resources/images_r.dart';
import 'package:moatmat_app/User/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_app/User/Features/code/domain/entites/code_center.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';

class CodeCenterView extends StatelessWidget {
  const CodeCenterView({
    super.key,
    required this.center,
  });
  //
  final CodeCenter center;
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(center.name),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(ImagesResources.whatsappImage),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: SizesResources.s10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButtonWidget(
              text: "العودة",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            //
            const SizedBox(height: SizesResources.s10),
            //
            SizedBox(
              width: SpacingResources.mainWidth(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Hero(
                  tag: center.id,
                  child: center.icon != null
                      ? Image.network(
                          center.icon!,
                        )
                      : Image.asset(
                          ImagesResources.codesCenterImage,
                        ),
                ),
              ),
            ),
            //
            const SizedBox(height: SizesResources.s2),
            //
            GestureDetector(
              onPanDown: (details) {
                Clipboard.setData(ClipboardData(text: center.phone)).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تم النسخ"),
                    ),
                  );
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(SpacingResources.sidePadding),
                child: Text(
                  center.phone,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: ColorsResources.darkPrimary,
                  ),
                ),
              ),
            ),
            //
            const SizedBox(height: SizesResources.s2),
            //
            Padding(
              padding: const EdgeInsets.all(SpacingResources.sidePadding),
              child: Text(
                center.description,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
