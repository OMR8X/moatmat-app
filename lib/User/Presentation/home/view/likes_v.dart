import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/shadows_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/texts_resources.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_like.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank_information.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank_properties.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank_q.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/question.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test_information.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test_properties.dart';
import 'package:moatmat_app/User/Presentation/banks/views/question_v.dart';
import 'package:moatmat_app/User/Presentation/tests/view/question_v.dart';
import 'package:moatmat_app/User/Presentation/tests/widgets/question_body_w.dart';
import 'package:moatmat_app/User/Presentation/tests/widgets/test_q_box.dart';

import '../../../Core/widgets/math/question_body_w.dart';
import '../../../Core/widgets/ui/empty_list_text.dart';
import '../../auth/state/auth_c/auth_cubit_cubit.dart';
import '../../banks/widgets/bank_q_box.dart';

class LikesView extends StatefulWidget {
  const LikesView({super.key});

  @override
  State<LikesView> createState() => _LikesViewState();
}

class _LikesViewState extends State<LikesView> {
  List<(Question, int)> bQuestions = [];
  List<(Question, int)> tQuestions = [];
  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() {
    bQuestions = [];
    tQuestions = [];
    for (var l in locator<UserData>().likes) {
      if (l.bankId != null) {
        bQuestions.add((l.bQuestion!, l.bankId!));
      }
      if (l.testId != null) {
        tQuestions.add((l.tQuestion!, l.testId!));
      }
    }
  }

  removeBankQ((Question, int) bQuestion) async {
    var like = UserLike(
      id: 0,
      bankId: bQuestion.$2,
      testId: null,
      bQuestion: bQuestion.$1,
      tQuestion: null,
    );
    context.read<AuthCubit>().unLike(like: like);
    initData();
    setState(() {});
  }

  removeTestQ((Question, int) tQuestions) async {
    var like = UserLike(
      id: 0,
      bankId: null,
      testId: tQuestions.$2,
      bQuestion: null,
      tQuestion: tQuestions.$1,
    );
    context.read<AuthCubit>().unLike(like: like);
    initData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorsResources.background,
        appBar: AppBar(
          title: const Text(AppBarTitles.likes),
          bottom: const TabBar(
            tabs: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("الاختبارات الالكترونية"),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("بنوك الأسئلة"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            tQuestions.isEmpty
                ? const EmptyListTextWidget()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: SizesResources.s2),
                    scrollDirection: Axis.vertical,
                    itemCount: tQuestions.length,
                    itemBuilder: (context, index) {
                      var question = tQuestions[index].$1;
                      int? selected;
                      for (int i = 0; i < question.answers.length; i++) {
                        if (question.answers[i].trueAnswer ?? false) {
                          selected = i;
                        }
                      }
                      return Container(
                        margin: const EdgeInsets.all(SizesResources.s2),
                        decoration: BoxDecoration(
                          color: ColorsResources.onPrimary,
                          boxShadow: ShadowsResources.mainBoxShadow,
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TestQuestionView(
                                    canExit: true,
                                    onExit: () {
                                      print("object");
                                      Navigator.of(context).pop();
                                    },
                                    question: question,
                                    selected: selected,
                                    onAnswer: (question, selected) {},
                                    onPop: () {
                                      Navigator.of(context).pop();
                                      initData();
                                      setState(() {});
                                    },
                                    onNext: () {},
                                    onPrevious: () {},
                                    title: "سؤال محفوظ",
                                    disableActions: true,
                                    test: Test(
                                      id: tQuestions[index].$2,
                                      teacherEmail: "",
                                      questions: [],
                                      information: TestInformation(
                                        title: "",
                                        classs: "",
                                        material: "",
                                        teacher: "",
                                        price: null,
                                        password: null,
                                        period: 0,
                                        video: [],
                                        files: [],
                                        images: [],
                                        previous: null,
                                      ),
                                      properties: TestProperties(
                                        exploreAnswers: null,
                                        showAnswers: null,
                                        timePerQuestion: null,
                                        repeatable: null,
                                        visible: null,
                                        scrollable: null,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(SizesResources.s4),
                              child: Row(
                                children: [
                                  QuestionBodyWidget(
                                    question: tQuestions[index].$1,
                                    disableOpenImage: true,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      removeTestQ(tQuestions[index]);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: ColorsResources.red,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            bQuestions.isEmpty
                ? const EmptyListTextWidget()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: SizesResources.s2),
                    scrollDirection: Axis.vertical,
                    itemCount: bQuestions.length,
                    itemBuilder: (context, index) {
                      var question = bQuestions[index].$1;
                      int? selected;
                      for (int i = 0; i < question.answers.length; i++) {
                        if (question.answers[i].trueAnswer ?? false) {
                          selected = i;
                        }
                      }
                      return Container(
                        margin: const EdgeInsets.all(SizesResources.s2),
                        decoration: BoxDecoration(
                            color: ColorsResources.onPrimary,
                            boxShadow: ShadowsResources.mainBoxShadow,
                            borderRadius: BorderRadius.circular(
                              12,
                            )),
                        child: Material(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BankQuestionView(
                                    canExit: true,
                                    bank: Bank(
                                      id: bQuestions[index].$2,
                                      teacherEmail: "",
                                      information: BankInformation(
                                        title: "",
                                        classs: "",
                                        material: "",
                                        teacher: "",
                                        price: 0,
                                        images: [],
                                        video: [],
                                        files: [],
                                      ),
                                      properties: BankProperties(
                                        scrollable: false,
                                        visible: false,
                                      ),
                                      questions: [],
                                    ),
                                    question: question,
                                    selected: selected,
                                    onAnswer: (question, selected) {},
                                    onPop: () {
                                      Navigator.of(context).pop();
                                      initData();
                                      setState(() {});
                                    },
                                    onNext: () {},
                                    onPrevious: () {},
                                    title: "سؤال محفوظ",
                                    disableActions: true,
                                    onExit: () {},
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(SizesResources.s4),
                              child: Row(
                                children: [
                                  QuestionBodyWidget(
                                    question: bQuestions[index].$1,
                                    disableOpenImage: true,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      removeBankQ(bQuestions[index]);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: ColorsResources.red,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
