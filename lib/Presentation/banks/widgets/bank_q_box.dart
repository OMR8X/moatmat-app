import 'package:flutter/material.dart';

import 'package:moatmat_app/Core/injection/app_inj.dart';
import 'package:moatmat_app/Features/auth/domain/entites/user_data.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/widgets/math/question_body_w.dart';
import '../../../Core/widgets/view/question_explain_v.dart';
import '../../../Features/tests/domain/entities/question.dart';

class BankQuestionBox extends StatefulWidget {
  const BankQuestionBox({
    super.key,
    required this.question,
    this.didAnswer = false,
    this.disableActions = false,
    required this.onLike,
    required this.onShare,
    required this.onReport,
    required this.onShowAnswer,
    required this.bankID,
    required this.onUnLike,
    this.disableExplain = false,
  });
  final int bankID;
  final Question question;
  final bool didAnswer, disableExplain, disableActions;
  final VoidCallback onShare;
  final Function(int id) onReport;
  final VoidCallback onShowAnswer;
  final Function(bool like) onLike;
  final Function(bool like) onUnLike;

  @override
  State<BankQuestionBox> createState() => _BankQuestionBoxState();
}

class _BankQuestionBoxState extends State<BankQuestionBox> {
  bool didAnswer = false;
  bool liked = false;
  @override
  void initState() {
    didAnswer = didAnswer;
    checkLiked();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BankQuestionBox oldWidget) {
    if (didAnswer = widget.didAnswer) return;
    setState(() {
      didAnswer = widget.didAnswer;
    });
    checkLiked();

    super.didUpdateWidget(oldWidget);
  }

  checkLiked() {
    var likes = locator<UserData>().likes;
    bool isLiked = false;
    for (var l in likes) {
      if (l.bQuestion?.id == widget.question.id) {
        if ((l.bankId) == widget.bankID) {
          isLiked = true;
          break;
        }
      }
    }
    setState(() {
      liked = isLiked;
    });
  }

  @override
  void didChangeDependencies() {
    if (didAnswer == widget.didAnswer) return;
    setState(() {
      didAnswer = widget.didAnswer;
    });
    checkLiked();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s2,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: SizesResources.s2,
            horizontal: SpacingResources.sidePadding / 2,
          ),
          width: SpacingResources.mainWidth(context),
          decoration: BoxDecoration(
            color: ColorsResources.onPrimary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: ShadowsResources.mainBoxShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!widget.disableActions)
                TopItems(
                  liked: liked,
                  onShare: widget.onShare,
                  onReport: () {
                    widget.onReport(widget.question.id);
                  },
                  onLike: (b) {
                    if (b) {
                      widget.onLike(b);
                    } else {
                      widget.onUnLike(b);
                    }
                    setState(() {
                      liked = b;
                    });
                  },
                ),
              QuestionBodyWidget(question: widget.question),
              const SizedBox(height: SizesResources.s2),
              if ((didAnswer &&
                          (widget.question.explainImage != null &&
                              widget.question.explainImage!.isNotEmpty) ||
                      (widget.question.explain != null &&
                          widget.question.explain!.isNotEmpty) ||
                      (widget.question.video != null &&
                          widget.question.video!.isNotEmpty &&
                          didAnswer)) &&
                  !widget.disableExplain)
                Column(
                  children: [
                    const SizedBox(height: SizesResources.s2),
                    const Text(
                      "شرح الاجابة : ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorsResources.blackText1,
                      ),
                    ),
                    QuestionExplainMiniView(question: widget.question),
                  ],
                ),
              const SizedBox(height: SizesResources.s2),
            ],
          ),
        ),
      ],
    );
  }
}

class TopItems extends StatelessWidget {
  const TopItems({
    super.key,
    required this.onShare,
    required this.onReport,
    required this.onLike,
    required this.liked,
  });
  final VoidCallback onShare;
  final VoidCallback onReport;
  final Function(bool like) onLike;
  final bool liked;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: onReport,
          icon: const Icon(
            Icons.report_problem_outlined,
            size: 18,
            color: Colors.cyan,
          ),
        ),
        IconButton(
          onPressed: onShare,
          icon: const Icon(
            Icons.share,
            size: 16,
            color: ColorsResources.green,
          ),
        ),
        IconButton(
          onPressed: () {
            onLike(!liked);
          },
          icon: Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            size: 16,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}

class ExploreImage extends StatelessWidget {
  const ExploreImage({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: SpacingResources.mainWidth(context),
          height: MediaQuery.sizeOf(context).height,
          child: InteractiveViewer(
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(100),
            minScale: 0.5,
            maxScale: 2,
            child: Image.network(
              image,
            ),
          ),
        ),
      ),
    );
  }
}
