import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/fonts_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/resources/texts_resources.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';
import '../state/auth_c/auth_cubit_cubit.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _controller = PageController();
  int slidesLenght = 8;
  bool lastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (value) {
                setState(() {
                  lastPage = value == slidesLenght - 1;
                });
              },
              children: const [
                PageSlide(
                  title: "اسئلة منوعة",
                  image: "questions.jpg",
                  body:
                      "تدرب على أسئلة مدرسك المفضل ، واختبر معلوماتك ضمن كل وحدة دراسية بنظام الأسئلة المؤتمت ضمن خانة بنوك الأسئلة للمدرسين",
                ),
                PageSlide(
                  title: "الاختبارات الإلكترونية",
                  image: "electronic-tests.jpg",
                  body:
                      "عش تجربة الاختبارات النوعية المخصصة من مدرسك المفضل من خلال خانة الاختبارات الإلكترونية ، قم بحل الاختبار ضمن شروط وتوقيت محدد من قبل المدرس مما يعزز استعدادك للفحص النهائي بشكل مثالي ويضمن جودة وفعالية الاختبار",
                ),
                PageSlide(
                  title: "تحدى نفسك",
                  image: "chanalnge-your-self.jpg",
                  body:
                      "تحدى نفسك اثناء حلك لبنوك الاسئلة من خلال تحديد وقت لكل سؤال او لاسئلة وحدة ما ، وكرر هذه العملية باستمرار وقيم مدى تحسن سرعتك وتأقلمك مع نظام الاسئلة المؤتمت",
                ),
                PageSlide(
                  title: "النتائج التفصيلية",
                  image: "results.jpg",
                  body:
                      "احصل على درجاتك في نهاية كل اختبار واتطلع على عدد الاسئلة التي اخطأت بها وعدد الأسئلة الصحيحة",
                ),
                PageSlide(
                  title: "شروح توضيحية",
                  image: "shrouh.jpg",
                  body:
                      "انظر إلى شرح الاسئلة التي أخطأت بها ولم تعرف تفسير الاجابة الصحيحة من خلال علامة الاستفهام الموجود إلى جانب السؤال",
                ),
                PageSlide(
                  title: "ميزة الابلاغ",
                  image: "reports.jpg",
                  body:
                      "قم بالابلاغ عن السؤال الذي تظن بأنه يحوي خطأ ما لتتم مراجعته من قبل ادارة التطبيق",
                ),
                PageSlide(
                  title: "شارك رابط الأسئلة مع زملاءك",
                  image: "share.jpg",
                  body:
                      "شارك رابط الأسئلة المميزة مع زملاءك او مع مدرسك من خلال زر المشاركة الموجود جانب السؤال",
                ),
                PageSlide(
                  title: "تواصل معنا",
                  image: "communication.jpg",
                  body:
                      "تواصل معنا لأي استفسار من خلال زر تواصل معنا الموجود ضمن اعدادات التطبيق وقم بمتابعتنا على صفحتنا على فيسبوك وقناتنا على تلغرام لمعرفة التحديثات بشكل مستمر",
                ),
              ],
            ),
          ),
          SizedBox(
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: slidesLenght,
                  effect: const WormEffect(
                    dotColor: ColorsResources.borders,
                    activeDotColor: ColorsResources.primary,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
                const SizedBox(height: SizesResources.s4),
                SizedBox(
                  width: SpacingResources.mainWidth(context) - 30,
                  height: 50,
                  child: ElevatedButtonWidget(
                    text: lastPage ? TextsResources.start : TextsResources.next,
                    onPressed: () {
                      if (lastPage) {
                        onFinish();
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.decelerate,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: SizesResources.s10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onFinish() {
    context.read<AuthCubit>().startAuth();
  }
}

class PageSlide extends StatelessWidget {
  const PageSlide({
    super.key,
    required this.title,
    required this.body,
    required this.image,
  });
  final String title;
  final String body;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: SpacingResources.mainWidth(context) - 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Image.asset(
                    "assets/images/start/$image",
                    fit: BoxFit.cover,
                    width: 250,
                  ),
                ),
              ),
              const SizedBox(height: SizesResources.s10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: FontsResources.boldStyle().copyWith(
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: SizesResources.s3),
              Text(
                body,
                textAlign: TextAlign.center,
                style: FontsResources.reqularStyle().copyWith(
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
