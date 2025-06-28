import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/fonts_r.dart';
import 'package:moatmat_app/User/Core/resources/shadows_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:moatmat_app/User/Features/notifications/domain/entities/app_notification.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onLongPress,
  });

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
                errorBuilder: (context, error, stackTrace) => Container(
                  color: ColorsResources.background,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.broken_image, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          'تعذر تحميل الصورة',
                          style: FontsResources.styleMedium(
                            color: ColorsResources.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
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
    // Set Arabic locale
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    // Calculate minutes difference
    final now = DateTime.now();
    final difference = now.difference(notification.date);
    final minutes = difference.inMinutes;

    String timeText;
    if (minutes < 1) {
      timeText = 'الآن';
    } else if (minutes < 60) {
      timeText =
          'منذ $minutes دقيقة${minutes > 10 ? '' : ''}'; // Arabic pluralization
    } else {
      // Fall back to timeago for longer durations
      timeText = 'منذ ${timeago.format(notification.date, locale: 'ar')}';
    }

    return Container(
      width: SpacingResources.mainWidth(context),
      margin: const EdgeInsets.symmetric(vertical: SizesResources.s1),
      decoration: BoxDecoration(
        color: notification.seen
            ? ColorsResources.onPrimary.withOpacity(0.95)
            : ColorsResources.onPrimary,
        boxShadow: ShadowsResources.mainBoxShadow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(SizesResources.s3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification icon with status indicator
                Container(
                  margin: const EdgeInsets.only(right: SizesResources.s2),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 22,
                        color: notification.seen
                            ? ColorsResources.textSecondary.withOpacity(0.6)
                            : ColorsResources.primary,
                      ),
                      if (!notification.seen)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: ColorsResources.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ColorsResources.onPrimary,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Main content column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: FontsResources.styleMedium(
                                size: 16,
                                color: notification.seen
                                    ? ColorsResources.textPrimary
                                        .withOpacity(0.9)
                                    : ColorsResources.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      // Body text
                      if (notification.body != null &&
                          notification.body!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            notification.body!,
                            style: FontsResources.styleRegular(
                              color: notification.seen
                                  ? ColorsResources.textSecondary
                                      .withOpacity(0.7)
                                  : ColorsResources.textSecondary,
                              size: 14,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      // Metadata row (time and type)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            // Time ago
                            Text(
                              timeText,
                              style: FontsResources.styleRegular(
                                size: 12,
                                color: ColorsResources.textSecondary
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Image thumbnail (if exists)
                if (notification.imageUrl != null &&
                    notification.imageUrl!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: GestureDetector(
                      onTap: () =>
                          _showFullImage(context, notification.imageUrl!),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorsResources.borders.withOpacity(0.1),
                              width: 0.5,
                            ),
                          ),
                          child: Image.network(
                            notification.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: ColorsResources.background,
                                child: const Icon(Icons.broken_image, size: 24),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
