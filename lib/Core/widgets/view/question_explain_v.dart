import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/Core/resources/colors_r.dart';
import 'package:moatmat_app/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/Core/widgets/math/math_tex_w.dart';
import 'package:moatmat_app/Features/tests/domain/entities/question.dart';
import 'package:moatmat_app/Presentation/tests/view/question_v.dart';
import 'package:moatmat_app/Presentation/tests/widgets/test_q_box.dart';
import 'package:moatmat_app/Presentation/videos/view/chewie_player_widget.dart';
import 'package:video_player/video_player.dart';

import '../fields/elevated_button_widget.dart';
import '../math/question_body_w.dart';

class QuestionExplainView extends StatefulWidget {
  const QuestionExplainView({super.key, required this.question});
  final Question question;
  @override
  State<QuestionExplainView> createState() => _QuestionExplainViewState();
}

class _QuestionExplainViewState extends State<QuestionExplainView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            if (widget.question.video != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChewiePlayerWidget(videoUrl: widget.question.video!),
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
    );
  }
}

class QuestionExplainMiniView extends StatefulWidget {
  const QuestionExplainMiniView({super.key, required this.question});
  final Question question;
  @override
  State<QuestionExplainMiniView> createState() => _QuestionExplainMiniViewState();
}

class _QuestionExplainMiniViewState extends State<QuestionExplainMiniView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //
          if (widget.question.video != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChewiePlayerWidget(videoUrl: widget.question.video!),
                  ),
                ),
              ],
            ),

          if (widget.question.explainImage != null) ...[
            const SizedBox(height: SizesResources.s4),
            QuestionImageBuilderWidget(image: widget.question.explainImage!),
          ],
          if (widget.question.explain != null) ...[
            const SizedBox(height: SizesResources.s4),
            QuestionTextBuilderWidget(
              text: widget.question.explain!,
              equations: widget.question.equations,
              colors: [],
            ),
          ],
        ],
      ),
    );
  }
}
