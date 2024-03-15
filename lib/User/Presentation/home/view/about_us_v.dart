import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/texts_resources.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppBarTitles.aboutUs),
      ),
    );
  }
}
