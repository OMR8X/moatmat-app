import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';

import '../resources/sizes_resources.dart';

showAlert({
  required BuildContext context,
  required String title,
  required String body,
  required VoidCallback onAgree,
  String? agreeBtn,
  String? disagreeBtn,
  IconData? icon,
  Color? iconColor,
}) {
  if (!context.mounted) return;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.warning,
            size: 24,
            color: iconColor ?? ColorsResources.red,
          ),
          const SizedBox(width: SizesResources.s3),
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Text(title),
          ),
        ],
      ),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAgree();
          },
          child: Text(agreeBtn ?? "حسنا"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(disagreeBtn ?? "الغاء"),
        ),
      ],
    ),
  );
}
