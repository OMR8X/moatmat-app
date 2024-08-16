import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/shadows_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Core/resources/texts_resources.dart';
import 'package:moatmat_app/User/Core/validators/mintes_v.dart';
import 'package:moatmat_app/User/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_app/User/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank.dart';
import 'package:moatmat_app/User/Presentation/banks/views/banks/bank_q_search_v.dart';
import 'package:moatmat_app/User/Presentation/banks/views/banks/do_bank_question.dart';
import 'package:moatmat_app/User/Presentation/banks/views/exploring/full_time_explore_v.dart';
import 'package:moatmat_app/User/Presentation/banks/views/exploring/per_question_explore_v.dart';
import 'package:video_player/video_player.dart';

import '../../../../Core/widgets/toucheable_tile_widget.dart';
import '../../../videos/view/test_video_v.dart';
import '../../../videos/view/video_player_w.dart';
import '../exploring/explore_no_time_v.dart';

class SettingUpBankView extends StatefulWidget {
  const SettingUpBankView({super.key, required this.bank});
  final Bank bank;

  @override
  State<SettingUpBankView> createState() => _SettingUpBankViewState();
}

class _SettingUpBankViewState extends State<SettingUpBankView> {
  //
  FlickManager? flickManager;

  //
  final _formKey = GlobalKey<FormState>();
  bool isExpanded = false;
  bool perQuestions = false;
  int minutes = 0;
  int seconds = 0;
  //
  @override
  void initState() {
    String? link = widget.bank.information.video;
    if (link != null) {
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(link),
        ),
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      appBar: AppBar(
        backgroundColor: ColorsResources.primary,
        foregroundColor: ColorsResources.whiteText1,
        title: const Text(
          AppBarTitles.settingUpBank,
          style: TextStyle(
            color: ColorsResources.whiteText1,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: null,
            child: Text(
              "عدد الاسئلة : ${widget.bank.questions.length}",
              style: const TextStyle(
                color: ColorsResources.whiteText2,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(width: double.infinity),
              if (widget.bank.information.video != null) ...[
                const SizedBox(height: SizesResources.s4),
                VideoPlayerWidget(
                  flickManager: flickManager!,
                ),
              ],
              if (widget.bank.information.files != null) ...[
                const SizedBox(height: SizesResources.s6),
                //
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Text(
                        "ملفات مرفقة يجب دراستها قبل بدء الاختبار :",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                //
                const SizedBox(height: SizesResources.s2),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.bank.information.files!.length,
                  itemBuilder: (context, index) {
                    final file = widget.bank.information.files![index];
                    return TouchableTileWidget(
                      title: file.split("/").last.replaceAll(".pdf", ""),
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
              ],
              const SizedBox(height: SizesResources.s2),
              Container(
                decoration: BoxDecoration(
                  boxShadow: ShadowsResources.mainBoxShadow,
                  color: ColorsResources.onPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: SpacingResources.mainWidth(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ExpansionPanelList(
                    expansionCallback: (panelIndex, isExpanded) {
                      setState(() {
                        this.isExpanded = isExpanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                          backgroundColor: ColorsResources.onPrimary,
                          headerBuilder: (context, isExpanded) => ListTile(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    this.isExpanded = !this.isExpanded;
                                  });
                                },
                                title: Text(
                                  "اعدادات الوقت",
                                  style: TextStyle(
                                    color: isExpanded
                                        ? null
                                        : ColorsResources.borders,
                                  ),
                                ),
                              ),
                          isExpanded: isExpanded,
                          body: SizedBox(
                            width: SpacingResources.mainWidth(context) - 25,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyTextFormFieldWidget(
                                  width:
                                      SpacingResources.mainWidth(context) - 50,
                                  hintText:
                                      "الوقت ( ${perQuestions ? "بالثواني" : "بالدقائق"} )",
                                  keyboardType: TextInputType.number,
                                  validator: minutesValidator,
                                  maxLength: 3,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  onSaved: (p0) {
                                    minutes = int.tryParse(p0!) ?? 1;
                                    seconds = int.tryParse(p0) ?? 1;
                                  },
                                ),
                                const SizedBox(height: SizesResources.s2),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: perQuestions,
                                      onChanged: (v) {
                                        setState(() {
                                          perQuestions = true;
                                        });
                                      },
                                    ),
                                    const Text(
                                      "تعيين وقت للسؤال الواحد",
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: !perQuestions,
                                      onChanged: (v) {
                                        setState(() {
                                          perQuestions = false;
                                        });
                                      },
                                    ),
                                    const Text(
                                      "تعيين وقت لكامل الاختبار",
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: SizesResources.s2),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          isExpanded = false;
                                        });
                                      },
                                      child: const Text(
                                        "الغاء",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: SizesResources.s8),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: SizesResources.s4),
              ElevatedButtonWidget(
                text: "تصفح بنك الاسئلة",
                onPressed: () {
                  //
                  if (isExpanded) {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      if (perQuestions) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => PerQuestionExploreView(
                              bank: widget.bank,
                              seconds: seconds,
                            ),
                          ),
                        );
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => FullTimeExploreView(
                              bank: widget.bank,
                              minutes: seconds,
                            ),
                          ),
                        );
                      }
                    }
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ExploreNoTimeView(
                          bank: widget.bank,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: SizesResources.s2),
              TextButton(
                child: const Text(
                  "البحث عن سؤال ضمن البنك",
                  style: TextStyle(
                    color: ColorsResources.whiteText2,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => BankQuestionSearchView(
                        questions: widget.bank.questions,
                        onPick: (question) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DoBankQuestionView(
                                bank: widget.bank,
                                question: question,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
