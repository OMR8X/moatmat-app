import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/teacher_data.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/images_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';

class TeacherProfileView extends StatelessWidget {
  const TeacherProfileView({
    super.key,
    required this.teacherData,
  });
  final TeacherData teacherData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //
            const SizedBox(
              height: SizesResources.s10,
              width: double.infinity,
            ),
            //
            ClipRRect(
              borderRadius: BorderRadius.circular(360),
              child: CircleAvatar(
                radius: SpacingResources.mainHalfWidth(context) / 1.5,
                backgroundColor: ColorsResources.background,
                child: teacherData.image != null
                    ? Image.network(
                        teacherData.image!,
                        fit: BoxFit.fitWidth,
                      )
                    : Image.asset(
                        ImagesResources.teacherImage,
                      ),
              ),
            ),
            //
            const SizedBox(height: SizesResources.s3),
            //
            Padding(
              padding: const EdgeInsets.symmetric(),
              child: Text(
                "الاستاذ ${teacherData.name}",
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              teacherData.email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: ColorsResources.blackText2,
              ),
            ),
            const SizedBox(height: SizesResources.s2),
            Padding(
              padding: const EdgeInsets.all(SpacingResources.sidePadding),
              child: Text(
                teacherData.description ?? "لا يوجد وصف",
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: SizesResources.s10),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40),
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
    );
  }
}
