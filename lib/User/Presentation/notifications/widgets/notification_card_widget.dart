import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/fonts_r.dart';
import 'package:moatmat_app/User/Core/resources/shadows_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import 'package:moatmat_app/User/Features/notifications/domain/entities/app_notification.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  // Test image URL for debugging purposes

  // static const String _testImageUrl = 'https://images.unsplash.com/photo-1742505709415-76b15647ae64?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onLongPress,
  });

  // Helper method for showing full image
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
                errorBuilder: (context, error, stackTrace) => _buildImageError(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build clickable text with link detection
  Widget _buildClickableText(
    BuildContext context,
    String text, {
    required TextStyle textStyle,
    required TextStyle linkStyle,
  }) {
    final List<TextSpan> spans = [];
    final RegExp urlRegExp = RegExp(
      r"https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}(?:/[^\s]*)?",
      caseSensitive: false,
      multiLine: true,
    );

    text.splitMapJoin(
      urlRegExp,
      onMatch: (Match match) {
        final String url = match.group(0)!;
        spans.add(
          TextSpan(
            text: url,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final Uri uri = Uri.parse(url);
                try {
                  await launchUrl(uri);
                } on Exception catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not launch the url\n$e')),
                    );
                  }
                }
              },
          ),
        );
        return '';
      },
      onNonMatch: (String nonMatch) {
        spans.add(TextSpan(text: nonMatch, style: textStyle));
        return '';
      },
    );
    return RichText(text: TextSpan(children: spans));
  }

  // Helper method for image error state
  Widget _buildImageError() {
    return Container(
      color: ColorsResources.cardBackground,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.broken_image,
              size: 48,
              color: ColorsResources.textSecondary,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'تعذر تحميل الصورة',
                style: FontsResources.styleMedium(
                  color: ColorsResources.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get sender name
  String _getSenderDisplayName() {
    if (notification.data == null || notification.data?["sent_by"] == null) {
      return '';
    }
    return notification.data!["sent_by"].toString();
  }

  // Helper method to format time
  String _getFormattedTime() {
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    final now = DateTime.now();
    final difference = now.difference(notification.date);
    final minutes = difference.inMinutes;

    if (minutes < 1) {
      return 'الآن';
    } else if (minutes < 60) {
      return 'منذ $minutes دقيقة';
    } else {
      return timeago.format(notification.date, locale: 'ar');
    }
  }

  // Helper method to build notification icon
  Widget _buildNotificationIcon() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: notification.seen ? ColorsResources.primary.withAlpha(10) : ColorsResources.primary.withAlpha(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.notifications_outlined,
            size: 20,
            color: ColorsResources.primary.withAlpha(150),
          ),
        ],
      ),
    );
  }

  // Helper method to build time container
  Widget _buildTimeContainer(String timeText) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: ColorsResources.grey.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        timeText,
        style: FontsResources.styleRegular(
          size: 11,
          color: ColorsResources.textSecondary,
        ),
      ),
    );
  }

  // Helper method to build image thumbnail
  Widget _buildImageThumbnail(BuildContext context, String imageUrl) {
    return GestureDetector(
      onTap: () => _showFullImage(context, imageUrl),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ColorsResources.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: SizedBox(
            width: 60,
            height: 60,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: ColorsResources.background.withOpacity(0.3),
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 24,
                  color: ColorsResources.textSecondary.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build sender tag
  Widget _buildSenderTag(String senderName) {
    print(senderName);
    Map trSenderName = {
      "admin": "ادارة التطبيق",
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: ColorsResources.grey.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: ColorsResources.grey.withAlpha(200),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              size: 11,
              color: ColorsResources.onPrimary,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                'من : ${trSenderName[senderName.toLowerCase()] ?? senderName}',
                style: FontsResources.styleMedium(
                  size: 11,
                  color: ColorsResources.textPrimary.withAlpha(150),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeText = _getFormattedTime();
    final displayImageUrl = notification.imageUrl;
    final hasImageToDisplay = displayImageUrl?.isNotEmpty ?? false;
    final hasSender = _getSenderDisplayName().isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: SizesResources.s1, vertical: SizesResources.s1),
          width: MediaQuery.sizeOf(context).width - SizesResources.s7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorsResources.borders,
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorsResources.primary.withOpacity(0.08),
                spreadRadius: 0.2,
                blurRadius: 10,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              onLongPress: onLongPress,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SizesResources.s3, vertical: SizesResources.s4),
                child: Column(
                  children: [
                    // Main content row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Notification Icon
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: SizesResources.s2, right: SizesResources.s2),
                              child: _buildNotificationIcon(),
                            ),
                          ],
                        ),

                        // Content section
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                if (notification.title.isNotEmpty)
                                  Text(
                                    notification.title,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),

                                // Spacing between title and body
                                if (notification.title.isNotEmpty && (notification.body?.isNotEmpty ?? false)) SizedBox(height: SizesResources.s1),

                                // Body
                                if (notification.body?.isNotEmpty ?? false)
                                  _buildClickableText(
                                    context,
                                    notification.body!,
                                    textStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      fontFamily: "Tajawal",
                                    ),
                                    linkStyle: TextStyle(
                                      color: ColorsResources.primary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Time and Image column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Time
                            _buildTimeContainer(timeText),

                            // Image
                            if (hasImageToDisplay) ...[
                              const SizedBox(height: 8),
                              _buildImageThumbnail(context, displayImageUrl!),
                            ],
                          ],
                        ),
                      ],
                    ),

                    // Sender tag
                    if (hasSender) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const SizedBox(width: 52), // Align with content after icon
                          Expanded(
                            child: _buildSenderTag(_getSenderDisplayName()),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
