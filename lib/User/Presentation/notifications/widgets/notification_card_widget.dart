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

  static const String _testImageUrl = 'https://images.unsplash.com/photo-1742505709415-76b15647ae64?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

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
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not launch $url')),
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
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: notification.seen ? ColorsResources.background.withOpacity(0.3) : ColorsResources.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification.seen ? ColorsResources.borders.withOpacity(0.4) : ColorsResources.primary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            notification.seen ? Icons.notifications_outlined : Icons.notifications_active_rounded,
            size: 24,
            color: notification.seen ? ColorsResources.textSecondary.withOpacity(0.8) : ColorsResources.primary,
          ),
          if (!notification.seen)
            Positioned(
              right: -1,
              top: -1,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: ColorsResources.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorsResources.cardBackground,
                    width: 2.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to build time container
  Widget _buildTimeContainer(String timeText) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: notification.seen ? ColorsResources.grey.withOpacity(0.2) : ColorsResources.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          timeText,
          style: FontsResources.styleRegular(
            size: 11,
            color: notification.seen ? ColorsResources.textSecondary : ColorsResources.textPrimary.withOpacity(0.7),
          ),
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
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: ColorsResources.primary.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorsResources.primary.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.5),
          child: SizedBox(
            width: 72,
            height: 72,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: ColorsResources.background.withOpacity(0.3),
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 32,
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: ColorsResources.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: ColorsResources.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              size: 14,
              color: ColorsResources.onPrimary,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'من: $senderName',
                style: FontsResources.styleMedium(
                  size: 13,
                  color: ColorsResources.primary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build content section
  Widget _buildContentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            notification.title,
            style: FontsResources.styleMedium(
              size: 16,
              color: notification.seen ? ColorsResources.textPrimary.withOpacity(0.8) : ColorsResources.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Body
        if (notification.body?.isNotEmpty ?? false) ...[
          const SizedBox(height: 6),
          _buildClickableText(
            context,
            notification.body!,
            textStyle: FontsResources.styleRegular(
              size: 14,
              color: notification.seen ? ColorsResources.textSecondary.withOpacity(0.7) : ColorsResources.textSecondary,
            ),
            linkStyle: FontsResources.styleMedium(
              size: 14,
              color: ColorsResources.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeText = _getFormattedTime();

    // Determine which image URL to display for testing purposes
    String? displayImageUrl = notification.imageUrl;
    if ((displayImageUrl == null || displayImageUrl.isEmpty) && kDebugMode) {
      displayImageUrl = _testImageUrl;
    }

    final hasImageToDisplay = displayImageUrl?.isNotEmpty ?? false; // Check if there's *any* image to display
    final hasSender = _getSenderDisplayName().isNotEmpty;

    return Container(
      width: SpacingResources.mainWidth(context),
      margin: const EdgeInsets.symmetric(
        vertical: SizesResources.s1,
        horizontal: SizesResources.s2,
      ),
      decoration: BoxDecoration(
        color: notification.seen ? ColorsResources.cardBackground : ColorsResources.onPrimary,
        boxShadow: [
          BoxShadow(
            color: notification.seen ? ColorsResources.borders.withOpacity(0.15) : ColorsResources.primary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
        ],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: notification.seen ? ColorsResources.borders.withOpacity(0.25) : ColorsResources.primary.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(SizesResources.s4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row with Icon, Content, Time and Image
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notification Icon
                    _buildNotificationIcon(),

                    const SizedBox(width: 14),

                    // Content
                    Expanded(child: _buildContentSection(context)),

                    const SizedBox(width: 10),

                    // Time and Image Column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Time Display
                        _buildTimeContainer(timeText),

                        // Image Thumbnail
                        if (hasImageToDisplay) ...[
                          const SizedBox(height: 10),
                          _buildImageThumbnail(context, displayImageUrl!),
                        ],
                      ],
                    ),
                  ],
                ),

                // Sender Tag
                if (hasSender) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const SizedBox(width: 62), // Align with content after icon
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
    );
  }
}
