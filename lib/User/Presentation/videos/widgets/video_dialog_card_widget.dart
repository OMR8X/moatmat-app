import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Presentation/videos/view/chewie_player_widget.dart';

class VideoDialogCardWidget extends StatelessWidget {
  const VideoDialogCardWidget({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  final String videoUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: SizesResources.s1,
        horizontal: SizesResources.s2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorsResources.onPrimary,
        boxShadow: [
          BoxShadow(
            color: ColorsResources.primary.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () => _showVideoDialog(context),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(SizesResources.s2),
            child: Row(
              children: [
                const _VideoIconContainer(),
                const SizedBox(width: SizesResources.s2),
                _VideoInfoSection(title: title),
                const _OpenVideoIcon(),
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
        return _VideoDialog(
          videoUrl: videoUrl,
          title: title,
        );
      },
    );
  }
}

class _VideoIconContainer extends StatelessWidget {
  const _VideoIconContainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.flip(
            flipX: true,
            child: const Icon(
              Icons.play_arrow,
              color: ColorsResources.whiteText1,
              size: 24,
            ),
          ),
          const Positioned(
            bottom: 4,
            left: 4,
            child: Icon(
              Icons.videocam,
              color: ColorsResources.whiteText1,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoInfoSection extends StatelessWidget {
  const _VideoInfoSection({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: ColorsResources.blackText1,
            ),
          ),
          const SizedBox(height: SizesResources.s1 / 2),
          _buildWatchButton(),
        ],
      ),
    );
  }

  Widget _buildWatchButton() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SizesResources.s1,
        vertical: SizesResources.s1 / 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: ColorsResources.primary.withOpacity(0.1),
      ),
      child: const Text(
        "اضغط للمشاهدة",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: ColorsResources.primary,
        ),
      ),
    );
  }
}

class _OpenVideoIcon extends StatelessWidget {
  const _OpenVideoIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.open_in_new,
      color: ColorsResources.primary,
      size: 18,
    );
  }
}

class _VideoDialog extends StatelessWidget {
  const _VideoDialog({
    required this.videoUrl,
    required this.title,
  });

  final String videoUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(SizesResources.s2),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: ColorsResources.onPrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _VideoDialogHeader(title: title),
            _VideoDialogBody(videoUrl: videoUrl),
            const _VideoDialogFooter(),
          ],
        ),
      ),
    );
  }
}

class _VideoDialogHeader extends StatelessWidget {
  const _VideoDialogHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SizesResources.s2),
      decoration: const BoxDecoration(
        color: ColorsResources.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
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
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoDialogBody extends StatelessWidget {
  const _VideoDialogBody({required this.videoUrl});

  final String videoUrl;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(SizesResources.s1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ChewiePlayerWidget(
            videoUrl: videoUrl,
          ),
        ),
      ),
    );
  }
}

class _VideoDialogFooter extends StatelessWidget {
  const _VideoDialogFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SizesResources.s2),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsResources.primary,
            foregroundColor: ColorsResources.whiteText1,
            padding: const EdgeInsets.symmetric(
              vertical: SizesResources.s1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            "إغلاق",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
