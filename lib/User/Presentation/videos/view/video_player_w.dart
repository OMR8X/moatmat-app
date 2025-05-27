import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:video_player/video_player.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/spacing_resources.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.flickManager,
    this.width,
  });

  final FlickManager flickManager;
  final double? width;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.flickManager.flickVideoManager?.videoPlayerController?.addListener(_checkForError);
  }

  Future<void> _checkForError() async {
    final error = widget.flickManager.flickVideoManager?.videoPlayerController?.value.errorDescription;

    if (error != null && error.isNotEmpty) {
 
      setState(() {
        _error = error;
        _isLoading = false;
      });
    }
  }

  Future<void> _retryPlayback() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final oldController = widget.flickManager.flickVideoManager?.videoPlayerController;
      if (oldController == null) {
        throw Exception('Video controller is null');
      }

      // Get the data source from the current controller
      final dataSource = oldController.dataSource;
      final dataSourceType = oldController.dataSourceType;

      // Create a new controller with the same data source
      final newController = VideoPlayerController.networkUrl(Uri.parse(dataSource));

      // Initialize the new controller
      await newController.initialize();

      // Update the FlickManager with the new controller
      await widget.flickManager.handleChangeVideo(newController);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to reload video. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildErrorOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: ColorsResources.onPrimary,
              size: 48,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'حدث خطأ اثناء محاولة تحميل الفيديو',
                style: const TextStyle(
                  color: ColorsResources.onPrimary,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 40,
                  child: _isLoading
                      ? CupertinoActivityIndicator()
                      : ElevatedButton(
                          onPressed: _isLoading ? null : _retryPlayback,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsResources.darkPrimary,
                            foregroundColor: ColorsResources.onPrimary,
                          ),
                          child: Text('اعادة التحميل'),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: ShadowsResources.mainBoxShadow,
          color: ColorsResources.blackText1,
          borderRadius: BorderRadius.circular(12),
        ),
        width: widget.width ?? SpacingResources.mainWidth(context),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: SafeArea(
            child: Center(
              child: Stack(
                children: [
                  FlickVideoPlayer(
                    flickManager: widget.flickManager,
                    flickVideoWithControls: FlickVideoWithControls(
                      playerErrorFallback: SizedBox(),
                      controls: IconTheme(
                        data: const IconThemeData(color: ColorsResources.onPrimary),
                        child: AspectRatio(
                          aspectRatio: widget.flickManager.flickVideoManager?.videoPlayerController?.value.aspectRatio ?? 16 / 9,
                          child: FlickPortraitControls(
                            progressBarSettings: FlickProgressBarSettings(
                              bufferedColor: ColorsResources.borders,
                              playedColor: ColorsResources.darkPrimary,
                              handleColor: ColorsResources.darkPrimary,
                              backgroundColor: ColorsResources.borders,
                            ),
                          ),
                        ),
                      ),
                    ),
                    flickVideoWithControlsFullscreen: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Container(
                        color: Colors.black,
                        child: SafeArea(
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: widget.flickManager.flickVideoManager?.videoPlayerController?.value.aspectRatio ?? 16 / 9,
                              child: FlickVideoWithControls(
                                controls: IconTheme(
                                  data: const IconThemeData(color: ColorsResources.onPrimary),
                                  child: FlickPortraitControls(
                                    progressBarSettings: FlickProgressBarSettings(
                                      bufferedColor: ColorsResources.borders,
                                      playedColor: ColorsResources.darkPrimary,
                                      handleColor: ColorsResources.darkPrimary,
                                      backgroundColor: ColorsResources.borders,
                                      padding: const EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_error != null || _isLoading)
                    Positioned.fill(
                      child: _buildErrorOverlay(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.flickManager.flickVideoManager?.videoPlayerController?.removeListener(_checkForError);
    super.dispose();
  }
}
