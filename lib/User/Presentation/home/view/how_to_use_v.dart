import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Core/resources/texts_resources.dart';

import '../../../Core/resources/colors_r.dart';

class HowToUseAppView extends StatefulWidget {
  const HowToUseAppView({super.key});

  @override
  State<HowToUseAppView> createState() => _HowToUseAppViewState();
}

class _HowToUseAppViewState extends State<HowToUseAppView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppBarTitles.commonQuestions)),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ExpandedPanelWidget(
              title: "ما هي النقاط",
              body: "رصيدك ضمن التطبيق والتي عبرها يمكن فتح الاختبارات التي تحتاج إلى نقاط يمكنك الحصول على النقاط من خلال المكتبات الموجودة عناوينها ضمن خانة مراكز البيع والذهاب إليها و طلب كود تطبيق مؤتمت بالقيمة التي تريدها",
            ),
            ExpandedPanelWidget(
              title: "كيفية شحن النقاط",
              body: "يمكنك شحن النقاط بعدة طرق ، امسح الكود بالكاميرا بعد ان تحصل عليه او ادخل الكود المكتوب باسفل الكود في خانة شحن النقاط",
            ),
            ExpandedPanelWidget(
              title: "ما هي بنوك الأسئلة",
              body:
                  "هي مجموعة من الأسئلة المكثفة والشاملة التي تم وضعها من قبل المدرسين لكل وحدة دراسية الغاية منها التعلم من خلال الحل ولتحاكي الاختبارات النهائية من خلال حرية اختيار الوقت للإختبار والحصول على تصحيح كل سؤال على حدى مع شرح للأسئلة التي تتطلب ذلك",
            ),
            ExpandedPanelWidget(
              title: "ما هي الاختبارات",
              body:
                  "مجموعة من الاختبارات التي تم وضعها من قبل المدرسين وفق شروط الامتحان النهائي حيث يتم ضبط شروطها بعناية لتتناسب مع طبيعة الأسئلة ضمن كل اختبار جميع شروط الاختبار مضبوطة مسبقاً من قبل المدرس ( وقت الاختبار _ عدد الأسئلة _ القدرة على تعديل الاجابة _ امكانية رؤية الاخطاء بنهاية الاختبار وسلم التصحيح ) قد تكون اختبارات لدرس معين او لمجموعة دروس او للمادة بالكامل",
            ),
            ExpandedPanelWidget(
                title: "ما الفرق بين الاختبارات والبنوك",
                body:
                    '''البنك وسيلة مساعدة للطالب تمتع الطالب بحرية حل الأسئلة دون شروط محددة ويمكنه تصفح الأسئلة والشرح ورؤية الإجابات بدون شروط كما يمكن للطالب أن يختبر نفسه وفق شروط يقوم بتحديدها هو أما الاختبارات فهي محاكاة لاختبار حقيقي مضبوط من قبل المدرس ويلتزم الطالب بتلك القواعد : 
-  الوقت 
-  منع التنقل بين الأسئلة 
-  منع مغادرة الاختبار او حتى الخروج من التطبيق او انزال الستار ( وفي حال القيام بذلك تعتبر محاولة غش ويتم انهاء الاختبار )ويحصل الطالب على نتيجته في نهاية الاختبار'''),
            ExpandedPanelWidget(
              title: "هل يمكنني شحن نقاطي اونلاين",
              body: "تواصل معنا على واتساب التطبيق ليتم شحن النقاط لك جميع معلومات التواصل موجودة ضمن خانة ( تواصل معنا )",
            ),
            ExpandedPanelWidget(
              title: "كيف يمكنني مراجعة نتائج اختباراتي",
              body:
                  "يوجد خانة في الأعلى تضم جميع نتائج الاختبارات والبنوك التي قمت بحلهامع تاريخ الحل والوقت الذي استغرقته لإنهاء الاختبار والأسئلة التي اخطأت بها تستطيع العودة لها دوماً لمتابعة تقدمك ومراجعة اخطاءك وتدريب نفسك على حل الاختبارات بوقت أقل",
            ),
            ExpandedPanelWidget(
              title: "من يمكنة الوصول إلى معلوماتي الشخصية",
              body: "جميع بياناتك محفوظة بسرية تامة نتائج اختباراتك محصورة بينك وبين المدرس أما معلوماتك الشخصية فستحفظ في خوادم التطبيق المشفرة",
            ),
            ExpandedPanelWidget(
              title: "من يستطيع استخدام تطبيق مؤتمت",
              body: "تطبيق مؤتمت موجه لجميع طلاب الجمهورية العربية السورية لحل الأسئلة وفق النظام المؤتمت",
            ),
            SizedBox(height: SizesResources.s10 * 2),
          ],
        ),
      ),
    );
  }
}

class ExpandedPanelWidget extends StatefulWidget {
  const ExpandedPanelWidget({
    super.key,
    required this.title,
    required this.body,
    this.isExpanded = false,
  });
  //
  final String title;
  final String body;
  final bool isExpanded;
  //
  @override
  State<ExpandedPanelWidget> createState() => _ExpandedPanelWidgetState();
}

class _ExpandedPanelWidgetState extends State<ExpandedPanelWidget> {
  bool isExpanded = false;
  @override
  void initState() {
    isExpanded = widget.isExpanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SizesResources.s1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
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
                        widget.title,
                        style: TextStyle(
                          color: !isExpanded ? ColorsResources.darkPrimary : ColorsResources.primary,
                        ),
                      ),
                    ),
                    isExpanded: isExpanded,
                    body: Padding(
                      padding: const EdgeInsets.only(
                        right: SizesResources.s4,
                        left: SizesResources.s4,
                        bottom: SizesResources.s6,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: SpacingResources.mainWidth(context) * 0.9,
                            child: Text(
                              widget.body,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
