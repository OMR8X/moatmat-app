import 'package:flutter/material.dart';

class ApiTesting extends StatefulWidget {
  const ApiTesting({super.key});

  @override
  State<ApiTesting> createState() => _APIStapiTesting();
}

class _APIStapiTesting extends State<ApiTesting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {},
              child: const Text("data"),
            )
          ],
        ),
      ),
    );
  }
}
