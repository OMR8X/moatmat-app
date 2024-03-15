import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/texts_resources.dart';

class HowToUseAppView extends StatelessWidget {
  const HowToUseAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppBarTitles.howToUseApp)),
    );
  }
}
