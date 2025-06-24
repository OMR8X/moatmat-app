import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/fonts_r.dart';
import 'package:moatmat_app/User/Core/resources/shadows_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';

import 'package:moatmat_app/User/Features/notifications/domain/entities/app_notification.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;

  const NotificationCard({super.key, required this.notification});

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(SizesResources.s4),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(SizesResources.s2),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Text('تعذر تحميل الصورة'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SpacingResources.mainWidth(context),
      margin: const EdgeInsets.symmetric(vertical: SizesResources.s2),
      padding: const EdgeInsets.symmetric(
        vertical: SizesResources.s3,
        horizontal: SizesResources.s3,
      ),
      decoration: BoxDecoration(
        color: ColorsResources.onPrimary,
        boxShadow: ShadowsResources.mainBoxShadow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: FontsResources.styleMedium(size: 16),
                ),
                if (notification.body != null && notification.body!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: SizesResources.s1),
                    child: Text(
                      notification.body!,
                      style: FontsResources.styleRegular(
                        color: ColorsResources.textSecondary,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Image (if available)
          if (notification.imageUrl != null &&
              notification.imageUrl!.isNotEmpty)
            GestureDetector(
              onTap: () => _showFullImage(context, notification.imageUrl!),
              child: Padding(
                padding: const EdgeInsets.only(left: SizesResources.s3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(SizesResources.s2),
                  child: Image.network(
                    notification.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 80);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
