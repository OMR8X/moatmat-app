import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/buckets/domain/requests/retrieve_asset_request.dart';
import 'package:video_player/video_player.dart';

import '../../../Features/buckets/domain/usecases/retrieve_asset_uc.dart';

class ChewiePlayerWidget extends StatefulWidget {
  final String? videoUrl;
  final String? videoPath;

  const ChewiePlayerWidget({
    super.key,
    this.videoUrl,
    this.videoPath,
  });

  @override
  State<ChewiePlayerWidget> createState() => _ChewiePlayerWidgetState();
}

class _ChewiePlayerWidgetState extends State<ChewiePlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _error;
  bool? _isOffline;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializePlayer());
  }

  Future<void> _initializePlayer() async {
    setState(() {
      _error = null;
      _isLoading = true;
    });
    await Future.delayed(Durations.medium4);
    try {
      if (widget.videoPath != null) {
        _videoPlayerController = VideoPlayerController.file(File(widget.videoPath!));
      } else {
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
      }
      await _videoPlayerController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
      );
      setState(() => _isLoading = false);
    } catch (e) {
      if (e is PlatformException) {
        _isOffline = (e.message?.contains("offline") ?? false) || (e.message?.contains("Source error") ?? false);
      }
      setState(() {
        _error = 'فشل تشغيل الفيديو';
        _isLoading = false;
        _isOffline;
      });
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = _isLoading ? 16 / 9 : _videoPlayerController.value.aspectRatio;
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Container(
              color: Colors.black,
              child: const Center(
                child: CupertinoActivityIndicator(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }
    if (_error != null) {
      if ((_isOffline ?? false) && widget.videoUrl != null) {
        return FutureBuilder(
          future: locator<RetrieveAssetUC>().call(request: RetrieveAssetRequest.fromSupabaseLink(widget.videoUrl!)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data?.fold(
                    (l) {
                      return errorWidget(aspectRatio);
                    },
                    (r) => ChewiePlayerWidget(
                      videoPath: r.path,
                    ),
                  ) ??
                  SizedBox();
            }
            return CupertinoActivityIndicator();
          },
        );
      }
      return errorWidget(aspectRatio);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Chewie(controller: _chewieController!),
        ),
      ),
    );
  }

  errorWidget(double aspectRatio) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            color: const Color(0xFF000D24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    _error ?? "حصل خطأ أثناء تحميل الفيديو",
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _initializePlayer,
                    child: const Text(
                      'إعادة التحميل',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
