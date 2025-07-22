import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/functions/coders/decode.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/video.dart';

class VideoCardWidget extends StatelessWidget {
  const VideoCardWidget({
    super.key,
    required this.video,
    required this.videoNumber,
    required this.onTap,
    this.isLoading = false,
  });

  final Video video;
  final int videoNumber;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(SizesResources.s3),
            child: Row(
              children: [
                _VideoThumbnail(video: video),
                const SizedBox(width: SizesResources.s3),
                Expanded(
                  child: _VideoInfo(video: video, videoNumber: videoNumber),
                ),
                _PlayButton(isLoading: isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoThumbnail extends StatelessWidget {
  const _VideoThumbnail({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorsResources.primary,
            ColorsResources.darkPrimary,
          ],
        ),
      ),
      child: Icon(
        Icons.play_circle_fill,
        color: ColorsResources.whiteText1,
        size: 30,
      ),
    );
  }
}

class _VideoInfo extends StatelessWidget {
  const _VideoInfo({super.key, required this.video, required this.videoNumber});

  final Video video;
  final int videoNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          decodeFileName(video.url.split("/").last.split(".").first),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorsResources.blackText1,
          ),
        ),
        const SizedBox(height: SizesResources.s1),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SizesResources.s2,
                vertical: SizesResources.s1 / 2,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: ColorsResources.primary.withOpacity(0.1),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: const Text(
                  "مقطع فيديو",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ColorsResources.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: SizesResources.s2),
            if (video.views > 0) ...[
              Text(
                "${video.views} مشاهدة",
                style: const TextStyle(
                  fontSize: 11,
                  color: ColorsResources.blackText2,
                ),
              ),
              const SizedBox(width: SizesResources.s1 / 2),
              Icon(
                Icons.visibility,
                size: 14,
                color: ColorsResources.blackText2,
              ),
            ],
          ],
        ),
        const SizedBox(height: SizesResources.s1),
        if (video.rating > 0) ...[
          Row(
            children: [
              Text(
                "(${video.ratingNum})",
                style: const TextStyle(
                  fontSize: 11,
                  color: ColorsResources.blackText2,
                ),
              ),
              const SizedBox(width: SizesResources.s1),
              ...List.generate(5, (index) {
                return Icon(
                  index < video.rating.floor() ? Icons.star : Icons.star_border,
                  size: 14,
                  color: ColorsResources.darkPrimary,
                );
              }),
            ],
          ),
        ],
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({super.key, required this.isLoading});
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SizesResources.s2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorsResources.primary.withOpacity(0.1),
      ),
      child: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: const CupertinoActivityIndicator(
                color: ColorsResources.darkPrimary,
              ),
            )
          : Transform.flip(
              flipX: true,
              child: const Icon(
                Icons.play_arrow,
                color: ColorsResources.primary,
                size: 24,
              ),
            ),
    );
  }
}
