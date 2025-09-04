import 'package:flutter/material.dart';
import 'package:moatmat_app/Core/resources/texts_resources.dart';
import 'package:moatmat_app/Presentation/home/view/how_to_use_v.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppBarTitles.aboutUs),
      ),
      body: const Column(
        children: [
          ExpandedPanelWidget(
            title: "تطبيق تعليمي متخصص بالإختبارات المؤتمتة",
            body:
                "يقدم مؤتمت العديد من الخدمات التعليمية والتي تقدم للطلاب تجربة مشابهة لشروط الامتحان النهائي بأسهل وأضمن الطرق.",
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}
