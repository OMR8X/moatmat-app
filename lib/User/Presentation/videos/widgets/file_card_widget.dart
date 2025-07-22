import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/functions/coders/decode.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';

class FileCardWidget extends StatelessWidget {
  const FileCardWidget({
    super.key,
    required this.fileUrl,
    required this.fileNumber,
    required this.onTap,
    this.isLoading = false,
  });

  final String fileUrl;
  final bool isLoading;
  final int fileNumber;
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(SizesResources.s3),
            child: Row(
              children: [
                _FileThumbnail(),
                const SizedBox(width: SizesResources.s3),
                Expanded(
                  child: _FileInfo(fileNumber: fileNumber, fileUrl: fileUrl),
                ),
                _OpenButton(isLoading: isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FileThumbnail extends StatelessWidget {
  const _FileThumbnail({super.key});

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
            ColorsResources.darkPrimary,
            ColorsResources.primary,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf,
            color: ColorsResources.whiteText1,
            size: 28,
          ),
          Positioned(
            bottom: 4,
            left: 4,
            child: Icon(
              Icons.description,
              color: ColorsResources.whiteText1,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _FileInfo extends StatelessWidget {
  const _FileInfo({super.key, required this.fileNumber, required this.fileUrl});

  final int fileNumber;
  final String fileUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          decodeFileName(fileUrl.split("/").last.split(".").first),
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
                  "ملف PDF",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ColorsResources.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SizesResources.s1),
      ],
    );
  }
}

class _OpenButton extends StatelessWidget {
  const _OpenButton({super.key, required this.isLoading});
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SizesResources.s2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorsResources.darkPrimary.withOpacity(0.1),
      ),
      child: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: const CupertinoActivityIndicator(
                color: ColorsResources.darkPrimary,
              ),
            )
          : const Icon(
              Icons.open_in_new,
              color: ColorsResources.primary,
              size: 24,
            ),
    );
  }
}
