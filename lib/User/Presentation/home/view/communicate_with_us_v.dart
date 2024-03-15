import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/shadows_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Core/resources/texts_resources.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Core/app/admin_info.dart';

class CommunicateWithUsView extends StatefulWidget {
  const CommunicateWithUsView({super.key});

  @override
  State<CommunicateWithUsView> createState() => _CommunicateWithUsViewState();
}

class _CommunicateWithUsViewState extends State<CommunicateWithUsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppBarTitles.communicateWithUs),
      ),
      body: const Center(
        child: Column(
          children: [
            SizedBox(height: SizesResources.s2),
            CommunicateNavigatorWidget(
              title: "فيسبوك",
              link: AdminInfo.facebook,
              icon: "facebook.png",
            ),
            CommunicateNavigatorWidget(
              title: "تلغرام",
              link: AdminInfo.telegram,
              icon: "telegram.png",
            ),
            CommunicateNavigatorWidget(
              title: "واتساب",
              link: AdminInfo.whatsapp,
              icon: "whatsapp.png",
            ),
            CommunicateNavigatorWidget(
              title: "يوتيوب",
              link: AdminInfo.youtube,
              icon: "youtube.png",
            ),
          ],
        ),
      ),
    );
  }
}

class CommunicateNavigatorWidget extends StatelessWidget {
  const CommunicateNavigatorWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.link,
  });
  final String title;
  final String icon;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: SizesResources.s1),
      width: SpacingResources.mainWidth(context),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: ShadowsResources.mainBoxShadow,
        color: ColorsResources.onPrimary,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            openLink(link);
          },
          child: Padding(
            padding: const EdgeInsets.all(SizesResources.s3),
            child: Row(
              children: [
                Text(
                  title,
                ),
                const Spacer(),
                Image.asset(
                  "assets/images/apps/$icon",
                  width: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future openLink(String link) async {
  var whatsappUri = Uri.parse(link);
  await launchUrl(whatsappUri);
}
