import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/question.dart';
import 'package:moatmat_app/User/Presentation/videos/view/video_player_w.dart';

class MiniVideoCardWidget extends StatelessWidget {
  const MiniVideoCardWidget({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  Widget build(BuildContext context) {
    // Only show if question has a video
    if (question.video == null || question.video!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: SizesResources.s1,
        horizontal: SpacingResources.sidePadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ColorsResources.onPrimary,
        boxShadow: [
          BoxShadow(
            color: ColorsResources.primary.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _showVideoDialog(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(SizesResources.s2),
            child: Row(
              children: [
                _MiniVideoThumbnail(),
                const SizedBox(width: SizesResources.s2),
                Expanded(
                  child: _MiniVideoInfo(),
                ),
                _MiniPlayButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showVideoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(SizesResources.s2),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: ColorsResources.onPrimary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Dialog header
                Container(
                  padding: const EdgeInsets.all(SizesResources.s3),
                  decoration: const BoxDecoration(
                    color: ColorsResources.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "شرح الإجابة بالفيديو",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorsResources.whiteText1,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: ColorsResources.whiteText1,
                        ),
                      ),
                    ],
                  ),
                ),
                // Video player
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(SizesResources.s2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ChewiePlayerWidget(
                        videoUrl: question.video!,
                      ),
                    ),
                  ),
                ),
                // Dialog footer
                Padding(
                  padding: const EdgeInsets.all(SizesResources.s3),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsResources.primary,
                        foregroundColor: ColorsResources.whiteText1,
                        padding: const EdgeInsets.symmetric(
                          vertical: SizesResources.s2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "إغلاق",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MiniVideoThumbnail extends StatelessWidget {
  const _MiniVideoThumbnail({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorsResources.primary,
            ColorsResources.darkPrimary,
          ],
        ),
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.play_circle_fill,
            color: ColorsResources.whiteText1,
            size: 24,
          ),
          Positioned(
            bottom: 3,
            left: 3,
            child: Icon(
              Icons.videocam,
              color: ColorsResources.whiteText1,
              size: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniVideoInfo extends StatelessWidget {
  const _MiniVideoInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "شرح الإجابة بالفيديو",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ColorsResources.blackText1,
          ),
        ),
        const SizedBox(height: SizesResources.s1 / 2),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SizesResources.s1,
            vertical: SizesResources.s1 / 3,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: ColorsResources.primary.withOpacity(0.1),
          ),
          child: const Text(
            "مقطع فيديو",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: ColorsResources.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniPlayButton extends StatelessWidget {
  const _MiniPlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SizesResources.s1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: ColorsResources.primary.withOpacity(0.1),
      ),
      child: Transform.flip(
        flipX: true,
        child: const Icon(
          Icons.play_arrow,
          color: ColorsResources.primary,
          size: 20,
        ),
      ),
    );
  }
}
