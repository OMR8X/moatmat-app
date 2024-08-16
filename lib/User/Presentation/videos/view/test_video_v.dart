import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:moatmat_app/User/Core/functions/coders/decode.dart';

import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_app/User/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Presentation/videos/view/video_player_w.dart';
import 'package:video_player/video_player.dart';

import '../../tests/view/exploring/explore_no_time_v.dart';
import '../../tests/view/exploring/full_time_explore_v.dart';
import '../../tests/view/exploring/per_question_explore_v.dart';

class TestVideoView extends StatefulWidget {
  const TestVideoView({
    super.key,
    required this.test,
  });
  final Test test;

  @override
  State<TestVideoView> createState() => _TestVideoViewState();
}

class _TestVideoViewState extends State<TestVideoView> {
  late FlickManager? flickManager;
  late String? video;
  bool shouldNavigate = false;
  @override
  void initState() {
    video = widget.test.information.video;
    if (video != null) {
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(widget.test.information.video!),
        ),
      );
    }
    //

    //
    super.initState();
  }

  @override
  void dispose() {
    if (video != null) {
      flickManager!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.test.information.files);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        //
        final NavigatorState navigator = Navigator.of(context);
        //
        if (didPop) {
          return;
        }
        //
        if (widget.test.information.video == null) {
          navigator.pop();
        }
        //
        if (video == null) {
          navigator.pop();
          return;
        }

        final bool shouldPop =
            flickManager?.flickControlManager?.isFullscreen ?? false;
        if (shouldPop) {
          flickManager?.flickControlManager?.exitFullscreen();
        } else {
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //
            const SizedBox(
              width: double.infinity,
              height: SizesResources.s2,
            ),
            //
            if (video != null) VideoPlayerWidget(flickManager: flickManager!),
            if (widget.test.information.files != null) ...[
              const SizedBox(height: SizesResources.s6),
              //
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Text(
                      "ملفات مرفقة يجب دراستها قبل بدء الاختبار :",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              //
              const SizedBox(height: SizesResources.s2),
              //
              Expanded(
                child: ListView.builder(
                  itemCount: widget.test.information.files!.length,
                  itemBuilder: (context, index) {
                    final file = widget.test.information.files![index];
                    return TouchableTileWidget(
                      title: decodeFileName(
                          file.split("/").last.replaceAll(".pdf", "")),
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 10,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PDFViewerFromUrl(url: file),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ]
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
            bottom: SizesResources.s10,
            left: SizesResources.s2,
            right: SizesResources.s2,
          ),
          child: ElevatedButtonWidget(
            text: "بدء الأختبار",
            onPressed: () async {
              //
              if (video != null) {
                flickManager?.flickControlManager?.pause();
              }
              //
              if (widget.test.information.period == 0 ||
                  widget.test.information.period == null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => TestExploreNoTimeView(
                      test: widget.test,
                    ),
                  ),
                );
              } else {
                if (widget.test.properties.timePerQuestion ?? false) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => TestPerQuestionExploreView(
                        minutes: widget.test.information.period!,
                        test: widget.test,
                      ),
                    ),
                  );
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => TestFullTimeExploreView(
                        minutes: widget.test.information.period!,
                        test: widget.test,
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

class PDFViewerFromUrl extends StatelessWidget {
  const PDFViewerFromUrl({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الملف'),
      ),
      body: const PDF().fromUrl(
        url,
        placeholder: (double progress) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$progress %',
                style: const TextStyle(
                  fontSize: 19,
                ),
              ),
              const SizedBox(height: SizesResources.s4),
              const Text('جار تجهيز الملف'),
              const SizedBox(height: SizesResources.s4),
            ],
          ));
        },
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
