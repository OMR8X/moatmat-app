import 'package:flutter/material.dart';

import 'User/Core/widgets/fields/elevated_button_widget.dart';

class CreatingWidgets extends StatefulWidget {
  const CreatingWidgets({super.key});

  @override
  State<CreatingWidgets> createState() => _CreatingWidgetsState();
}

class _CreatingWidgetsState extends State<CreatingWidgets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("صنع ويدجيتس"),
      ),
      body: Column(
        children: [
          ElevatedButtonWidget(
            text: 'النص',
            isWhite: false,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
