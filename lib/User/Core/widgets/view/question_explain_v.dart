import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/question.dart';
import 'package:moatmat_app/User/Presentation/tests/view/question_v.dart';
import 'package:moatmat_app/User/Presentation/tests/widgets/test_q_box.dart';
import 'package:moatmat_app/User/Presentation/videos/view/video_player_w.dart';
import 'package:video_player/video_player.dart';

import '../fields/elevated_button_widget.dart';

class QuestionExplainView extends StatefulWidget {
  const QuestionExplainView({super.key, required this.question});
  final Question question;
  @override
  State<QuestionExplainView> createState() => _QuestionExplainViewState();
}

class _QuestionExplainViewState extends State<QuestionExplainView> {
  late FlickManager? _flickManager;
  @override
  void initState() {
    if (widget.question.video != null) {
      _flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(widget.question.video ?? ""),
        ),
      );
    } else {
      _flickManager = null;
    }
    super.initState();
  }

  @override
  void dispose() {
    _flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        final NavigatorState navigator = Navigator.of(context);
        final bool? shouldPop =
            _flickManager?.flickControlManager?.isFullscreen;
        if (shouldPop ?? false) {
          _flickManager?.flickControlManager?.exitFullscreen();
        } else {
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الشرح"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //
              TestQuestionBox(
                question: widget.question,
                onLike: (like) {},
                onShare: () {},
                onReport: () {},
                onShowAnswer: () {},
                disableActions: true,
                disableExplain: true,
                testID: 0,
                onUnLike: (like) {},
              ),
              //
              if (_flickManager != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VideoPlayerWidget(flickManager: _flickManager!),
                  ],
                ),
              if (widget.question.explainImage != null) ...[
                const SizedBox(height: SizesResources.s4),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(19),
                      child: CachedNetworkImage(
                        imageUrl: widget.question.explainImage!,
                        placeholder: (context, url) {
                          return const CupertinoActivityIndicator(
                            color: ColorsResources.primary,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
              if (widget.question.explain != null) ...[
                const SizedBox(height: SizesResources.s4),
                SizedBox(
                  child: Text(
                    widget.question.explain!,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
            bottom: SizesResources.s10,
            left: SizesResources.s2,
            right: SizesResources.s2,
          ),
          child: ElevatedButtonWidget(
            text: "عودة",
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}

class QuestionExplainMiniView extends StatefulWidget {
  const QuestionExplainMiniView({super.key, required this.question});
  final Question question;
  @override
  State<QuestionExplainMiniView> createState() =>
      _QuestionExplainMiniViewState();
}

class _QuestionExplainMiniViewState extends State<QuestionExplainMiniView> {
  late FlickManager? _flickManager;
  @override
  void initState() {
    if (widget.question.video != null) {
      _flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(widget.question.video ?? ""),
        ),
      );
    } else {
      _flickManager = null;
    }
    super.initState();
  }

  @override
  void dispose() {
    _flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.question.explainImage);
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          final NavigatorState navigator = Navigator.of(context);
          final bool? shouldPop =
              _flickManager?.flickControlManager?.isFullscreen;
          if (shouldPop ?? false) {
            _flickManager?.flickControlManager?.exitFullscreen();
          } else {
            navigator.pop();
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //
            if (_flickManager != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: VideoPlayerWidget(
                        flickManager: _flickManager!,
                      ),
                    ),
                  ),
                ],
              ),
            if (widget.question.explainImage != null) ...[
              const SizedBox(height: SizesResources.s4),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(19),
                    child: CachedNetworkImage(
                      imageUrl: widget.question.explainImage!,
                      placeholder: (context, url) {
                        return const CupertinoActivityIndicator(
                          color: ColorsResources.primary,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
            if (widget.question.explain != null) ...[
              const SizedBox(height: SizesResources.s4),
              SizedBox(
                child: Text(
                  widget.question.explain!,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ));
  }
}
