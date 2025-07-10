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

import '../../../../Core/functions/coders/decode.dart';
import '../../../../Core/widgets/toucheable_tile_widget.dart';
import '../../../tests/widgets/test_q_box.dart';
import '../../../videos/view/test_assets_v.dart';
import '../../../videos/view/video_play_view.dart';
import '../../../videos/view/chewie_player_widget.dart';
import '../exploring/explore_no_time_v.dart';

class SettingUpBankView extends StatefulWidget {
  const SettingUpBankView({super.key, required this.bank});
  final Bank bank;

  @override
  State<SettingUpBankView> createState() => _SettingUpBankViewState();
}

class _SettingUpBankViewState extends State<SettingUpBankView> {
  //
  final _formKey = GlobalKey<FormState>();
  bool isExpanded = false;
  bool perQuestions = false;
  int minutes = 0;
  int seconds = 0;
  //

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
              "عدد الأسئلة : ${widget.bank.questions.length}",
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
              if (widget.bank.information.images?.isNotEmpty ?? false) ...[
                const MiniBankTitleWidget(title: "صور يجب الاطلاع عليها قبل حل الاختبار"),
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: SpacingResources.sidePadding),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.bank.information.images!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: SizesResources.s2,
                    crossAxisSpacing: SizesResources.s2,
                    childAspectRatio: 4 / 2,
                  ),
                  itemBuilder: (context, index) {
                    final image = widget.bank.information.images![index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ExploreImage(image: image),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(
                              image,
                              fit: BoxFit.fill,
                              width: 500,
                            ),
                            Container(
                              color: Colors.black.withOpacity(0.3),
                            ),
                            const Icon(
                              Icons.visibility,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(
                width: double.infinity,
                height: SizesResources.s4,
              ),
              if (widget.bank.information.videos?.isNotEmpty ?? false) ...[
                const MiniBankTitleWidget(title: "مقاطع فيديو يجب الاطلاع عليها قبل حل الاختبار"),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.bank.information.videos!.length,
                  itemBuilder: (context, index) {
                    final video = widget.bank.information.videos![index].url;
                    return MediaTileWidget(
                      file: video,
                      type: "MP4",
                      color: ColorsResources.blueText,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoPlayerView(link: video)));
                      },
                    );
                  },
                ),
              ],
              const SizedBox(
                width: double.infinity,
                height: SizesResources.s4,
              ),
              if (widget.bank.information.files?.isNotEmpty ?? false) ...[
                const MiniBankTitleWidget(title: "ملفات PDF يجب الاطلاع عليها قبل حل الاختبار"),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.bank.information.files!.length,
                  itemBuilder: (context, index) {
                    final file = widget.bank.information.files![index];
                    return MediaTileWidget(
                      file: decodeFileName(file.split("/").last.split("?").first.replaceAll(".pdf", "")),
                      type: "PDF",
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PDFViewerFromUrl(url: file),
                          ),
                        );
                      },
                      color: ColorsResources.orangeText,
                    );
                  },
                ),
              ],
              const SizedBox(height: SizesResources.s2),
              const MiniBankTitleWidget(title: "اعدادات البنك "),
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
                                    color: isExpanded ? null : ColorsResources.borders,
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
                                  width: SpacingResources.mainWidth(context) - 50,
                                  hintText: "الوقت ( ${perQuestions ? "بالثواني" : "بالدقائق"} )",
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
                                        "إلغاء",
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
                text: "تصفح بنك الأسئلة",
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

class MiniBankTitleWidget extends StatelessWidget {
  const MiniBankTitleWidget({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: SizesResources.s1),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ColorsResources.whiteText1,
            ),
          ),
        ],
      ),
    );
  }
}
