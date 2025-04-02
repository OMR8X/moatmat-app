import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/fonts_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
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
  List<Color> textColors = [
    ColorsResources.blueText,
    ColorsResources.orangeText,
    ColorsResources.greenText,
    ColorsResources.redText,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
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
              children: [
                PageSlide(
                  color: textColors[0],
                  content: Image.asset("assets/images/boarding/1.png"),
                  text: "اسئلة منوعة شاملة ومتخصصة بكل وحدة دراسية وفق اختياراتك",
                ),
                PageSlide(
                  color: textColors[1],
                  content: Image.asset("assets/images/boarding/2.png"),
                  text: "اختبر نفسك وفق شروط الامتحان النهائي في منزلك بأسهل وامتع طريقة",
                ),
                PageSlide(
                  color: textColors[2],
                  content: Image.asset("assets/images/boarding/3.png"),
                  text: "درب نفسك على الحل السريع في بنوك الأسئلة بالوقت الذي تحدده في كل مرة",
                ),
                PageSlide(
                  color: textColors[3],
                  content: Image.asset("assets/images/boarding/4.png"),
                  text: "احصل على درجتك في نهاية كل اختبار وراجع اخطائك واحاباتك الصحيحة",
                ),
                PageSlide(
                  color: textColors[0],
                  content: Image.asset("assets/images/boarding/5.png"),
                  text: "اضغط على الرمز جانب السؤال طلع على الشرح التوضيحيوتفسير الاجابة الصحيحة",
                ),
                PageSlide(
                  color: textColors[1],
                  content: Image.asset("assets/images/boarding/6.png"),
                  text: "ابلغ ولا تتعب نفسك مع أي سؤال خاطئ الكتابة",
                ),
                PageSlide(
                  color: textColors[2],
                  content: Image.asset("assets/images/boarding/7.png"),
                  text: "شارك الأسئلة مع زملاءك ومدرسك من خلال زر المشاركة جانب كل سؤال",
                ),
                PageSlide(
                  color: textColors[3],
                  content: Image.asset("assets/images/boarding/8.png"),
                  text: "تواصل معنا لايصال اقتراحاتك البناءة او لأي استفسار قد يخطر لك واحصل على المكافآت",
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: SizesResources.s8,
              left: SizesResources.s8,
              right: SizesResources.s8,
            ),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: slidesLenght,
                    effect: const WormEffect(
                      dotColor: ColorsResources.borders,
                      activeDotColor: ColorsResources.darkPrimary,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    child: IconButton(
                      icon: const Icon(
                        Icons.navigate_next,
                        color: ColorsResources.darkPrimary,
                      ),
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
    required this.text,
    required this.content,
    required this.color,
  });
  final String text;
  final Widget content;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: SizesResources.s10 * 2),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: content,
            ),
          ),
          const SizedBox(height: SizesResources.s10 * 2),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: SizesResources.s3,
              horizontal: SizesResources.s3,
            ),
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: FontsResources.regularStyle().copyWith(
                height: 1.2,
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 19,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
