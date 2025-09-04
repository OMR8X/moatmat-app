import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Core/functions/report.dart';
import 'package:moatmat_app/Core/functions/show_answer.dart';
import 'package:moatmat_app/Core/resources/colors_r.dart';
import 'package:moatmat_app/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_app/Features/auth/domain/entites/user_like.dart';
import 'package:moatmat_app/Features/tests/domain/entities/question.dart';
import 'package:moatmat_app/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/Presentation/banks/widgets/explore_question_appbar_w.dart';
import 'package:moatmat_app/Presentation/tests/widgets/answer_w.dart';
import 'package:moatmat_app/Presentation/tests/widgets/test_q_box.dart';

import '../../../Core/functions/show_alert.dart';
import '../../../Core/services/deep_links_s.dart';
import '../../auth/state/auth_c/auth_cubit_cubit.dart';

class TestQuestionsView extends StatefulWidget {
  const TestQuestionsView({
    super.key,
    required this.questions,
    required this.onAnswer,
    required this.onPop,
    required this.onNext,
    required this.onFinish,
    required this.onPrevious,
    this.showNext,
    this.showPrevious,
    this.disableActions,
    this.enableActions,
    required this.title,
    this.time,
    this.disableExplain,
    required this.test,
    required this.onExit,
    this.canExit = false,
  });

  final Test test;
  final String title;
  final Duration? time;
  final List<(Question, int?)> questions;
  final bool? showNext, showPrevious, disableActions, enableActions, disableExplain;
  final VoidCallback onPop;
  final VoidCallback onNext;
  final VoidCallback onFinish;
  final VoidCallback onPrevious;
  final Function(int index, Question question, int? selected) onAnswer;
  final VoidCallback onExit;
  final bool canExit;
  @override
  State<TestQuestionsView> createState() => _TestQuestionsViewState();
}

class _TestQuestionsViewState extends State<TestQuestionsView> with WidgetsBindingObserver {
  bool submit = true;
  bool didWarn = false;
  //
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive && !widget.canExit) {
      showWarning();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  showWarning() {
    if (didWarn) {
      widget.onExit();
    } else {
      setState(() {
        didWarn = true;
      });
      showAlert(
        context: context,
        title: "تحذير",
        agreeBtn: "انهاء الاختبار",
        disagreeBtn: "اكمال الاختبار",
        body: "تكرار محاولة الغش مرة اخرى سيؤدي إلى انهاء الاختبار ، هل انت متأكد من انك تريد انهاء الاختبار؟",
        onAgree: () {
          setState(() {
            submit = false;
          });
          widget.onExit();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.canExit,
      onPopInvoked: (didPop) {
        if (submit && !widget.canExit && !didPop) {
          showAlert(
            context: context,
            title: "تحذير",
            agreeBtn: "انهاء الاختبار",
            disagreeBtn: "اكمال الاختبار",
            body: "سيؤدي هذا إلى إنهاء الاختبار هل انت متأكد من ذلك ؟",
            onAgree: () {
              widget.onExit();
            },
          );
          return;
        }
        if (widget.canExit && !didPop) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: ColorsResources.primary,
        body: Column(
          children: [
            ExploreQuestionAppBarWidget(
              onPop: () {
                if (submit && !widget.canExit) {
                  showAlert(
                    context: context,
                    title: "تحذير",
                    agreeBtn: "انهاء الاختبار",
                    disagreeBtn: "اكمال الاختبار",
                    body: "سيؤدي هذا إلى إنهاء الاختبار هل انت متأكد من ذلك ؟",
                    onAgree: () {
                      widget.onExit();
                    },
                  );
                  return;
                }
                if (widget.canExit) {
                  widget.onExit();
                }
              },
              title: widget.title,
              time: widget.time,
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(
                  color: ColorsResources.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(48),
                    topRight: Radius.circular(48),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(48),
                    topRight: Radius.circular(48),
                  ),
                  child: ListView.builder(
                    itemCount: widget.questions.length,
                    itemBuilder: (context, index) {
                      final lastQuestionIndex = widget.questions.length - 1;
                      final question = widget.questions[index].$1;
                      final selected = widget.questions[index].$2;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Divider(
                            height: SizesResources.s10,
                          ),
                          SizedBox(
                            width: SpacingResources.mainWidth(context),
                            child: Row(
                              children: [
                                Text("سؤال : ${index + 1}"),
                              ],
                            ),
                          ),
                          TestQuestionBodyElements(
                            test: widget.test,
                            question: question,
                            selected: selected,
                            onNext: () {
                              widget.onFinish();
                            },
                            onPrevious: () {},
                            showNext: lastQuestionIndex == index,
                            showPrevious: false,
                            disableActions: lastQuestionIndex != index,
                            disableExplain: widget.disableExplain ?? true,
                            enableActions: widget.enableActions,
                            onAnswer: (selected) {
                              widget.onAnswer(index, question, selected);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestQuestionBodyElements extends StatelessWidget {
  const TestQuestionBodyElements({
    super.key,
    required this.question,
    this.selected,
    required this.onAnswer,
    required this.onNext,
    required this.onPrevious,
    this.showNext,
    this.showPrevious,
    this.disableActions,
    required this.test,
    this.disableExplain = false,
    this.showIsTrue = false,
    this.enableActions = true,
  });
  final Test test;
  final int? selected;
  final Question question;
  final Function(int selected) onAnswer;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool? showNext, showPrevious, disableActions, enableActions;
  final bool disableExplain, showIsTrue;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: SizesResources.s6),
      itemCount: question.answers.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              TestQuestionBox(
                disableExplain: disableExplain,
                testID: test.id,
                question: question,
                onUnLike: (v) {
                  var like = UserLike(
                    id: 0,
                    bankId: null,
                    testId: test.id,
                    bQuestion: null,
                    tQuestion: question,
                  );
                  context.read<AuthCubit>().unLike(like: like);
                },
                onLike: (v) {
                  var like = UserLike(
                    id: 0,
                    bankId: null,
                    testId: test.id,
                    bQuestion: null,
                    tQuestion: question,
                  );
                  context.read<AuthCubit>().like(like: like);
                },
                onShare: () async {
                  await DeepLinkService.createDynamicLink(
                    testId: test.id,
                    context: context,
                    questionId: question.id,
                  );
                },
                onReport: () {
                  reportOnQuestion(
                    context: context,
                    id: test.id,
                    tQuestion: question,
                    teacherEmail: test.teacherEmail,
                    name: test.information.title,
                  );
                },
                onShowAnswer: () {
                  showExplain(question, context);
                },
                didAnswer: selected != null,
              ),
              TestQuestionAnswerWidget(
                canChange: question.editable ?? false,
                showIsTrue: showIsTrue,
                answer: question.answers[index],
                onAnswer: () {
                  onAnswer(index);
                },
                selected: selected != null ? selected == index : null,
              ),
            ],
          );
        } else {
          if (index == question.answers.length - 1) {
            return Column(
              children: [
                TestQuestionAnswerWidget(
                  showIsTrue: showIsTrue,
                  canChange: question.editable ?? false,
                  answer: question.answers[index],
                  onAnswer: () {
                    onAnswer(index);
                  },
                  selected: selected != null ? selected == index : null,
                ),
                getActions(selected != null, context),
              ],
            );
          } else {
            return TestQuestionAnswerWidget(
              showIsTrue: showIsTrue,
              canChange: question.editable ?? false,
              answer: question.answers[index],
              onAnswer: () {
                onAnswer(index);
              },
              selected: selected != null ? selected == index : null,
            );
          }
        }
      },
    );
  }

  Widget getActions(bool didAnswer, BuildContext context) {
    if (disableActions == true) return const SizedBox();
    if (didAnswer || (enableActions ?? false)) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: SizesResources.s4),
        child: SizedBox(
          width: SpacingResources.mainWidth(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButtonWidget(
                text: "السابق",
                width: SpacingResources.mainHalfWidth(context),
                onPressed: showPrevious == true ? onPrevious : null,
              ),
              const Spacer(),
              ElevatedButtonWidget(
                text: "التالي",
                width: SpacingResources.mainHalfWidth(context),
                onPressed: showNext == true ? onNext : null,
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

class TopElements extends StatelessWidget {
  const TopElements({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.transparent,
      ),
    );
  }
}
