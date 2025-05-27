import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/functions/show_alert.dart';
import 'package:moatmat_app/User/Features/banks/domain/use_cases/get_bank_by_id.dart';
import 'package:moatmat_app/User/Features/tests/domain/usecases/get_test_by_id.dart';
import 'package:moatmat_app/User/Presentation/auth/state/auth_c/auth_cubit_cubit.dart';
import 'package:moatmat_app/User/Presentation/auth/view/auth_views_manager.dart';
import 'package:moatmat_app/User/Presentation/banks/views/banks/banks_view_manager.dart';
import 'package:moatmat_app/User/Presentation/banks/views/question_v.dart';
import 'package:moatmat_app/User/Presentation/code/views/add_code_v.dart';
import 'package:moatmat_app/User/Presentation/home/state/cubit/notifications_cubit.dart';
import 'package:moatmat_app/User/Presentation/home/view/deep_link_view.dart';
import 'package:moatmat_app/User/Presentation/home/view/likes_v.dart';
import 'package:moatmat_app/User/Presentation/results/view/my_results_v.dart';
import 'package:moatmat_app/User/Presentation/tests/view/question_v.dart';
import 'package:moatmat_app/User/Presentation/tests/view/tests/tests_view_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../Core/injection/app_inj.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/fonts_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/services/deep_links_s.dart';
import '../../../Features/auth/domain/entites/user_data.dart';
import '../../../Features/purchase/domain/entites/purchase_item.dart';
import '../../code/views/code_views_manager.dart';
import '../../code/views/codes_sellers_v.dart';
import 'notifications_v.dart';
import 'settings_v.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    //
    context.read<NotificationsCubit>().init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DeepLinkService.initDeepLinks(
        onGetLink: ({bankId, testId, questionId}) {
          if (bankId != null) {
            locator<GetBankByIdUC>().call(id: bankId).then((value) {
              value.fold((l) => null, (r) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DeepLinkView(
                      bank: r,
                      questionId: questionId!,
                    ),
                  ),
                );
              });
            });
          } else if (testId != null) {
            locator<GetTestByIdUC>().call(id: testId).then((value) {
              value.fold(
                (l) => null,
                (r) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DeepLinkView(
                        test: r,
                        questionId: questionId!,
                      ),
                    ),
                  );
                },
              );
            });
          }
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      body: Column(
        children: [
          HomeAppBarWidget(
            onOpenSettings: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsView(),
                ),
              );
            },
            onOpenNotifications: () async {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => const NotificationsView(),
                ),
              )
                  .then((value) {
                context.read<NotificationsCubit>().init();
              });
            },
            onOpenLikes: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LikesView(),
                ),
              );
            },
            onOpenResults: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MyResultsView(),
                ),
              );
            },
          ),
          const HomeBodyWidget(),
        ],
      ),
    );
  }
}

class HomeBodyWidget extends StatefulWidget {
  const HomeBodyWidget({
    super.key,
  });

  @override
  State<HomeBodyWidget> createState() => _HomeBodyWidgetState();
}

class _HomeBodyWidgetState extends State<HomeBodyWidget> {
  int _currentPage = 0;
  Timer? _timer;
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  Future<List<String>> getAds() async {
    var res = await Supabase.instance.client.from("ads").select().order("id");
    List<String> ads = res.map((e) => e["image"] as String).toList();
    return ads;
  }

  @override
  void initState() {
    super.initState();
  }

  startTimer(int length) {
    if (_timer?.isActive ?? false) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < length) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(Supabase.instance.client.auth.currentUser?.userMetadata);
    return Expanded(
      flex: 5,
      child: Container(
        decoration: const BoxDecoration(
          color: ColorsResources.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(48),
            topRight: Radius.circular(48),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(width: double.infinity),
              const SizedBox(height: SizesResources.s5),
              FutureBuilder(
                  future: getAds(),
                  builder: (context, future) {
                    if (future.hasData && future.data!.isNotEmpty) {
                      //
                      startTimer(future.data!.length);
                      //
                      return SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: future.data!.length,
                          itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: SizesResources.s2,
                              horizontal: SizesResources.s2,
                            ),
                            height: 190,
                            decoration: BoxDecoration(
                              color: ColorsResources.onPrimary,
                              boxShadow: ShadowsResources.mainBoxShadow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                future.data![index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox(
                                    child: Center(
                                      child: Text("حدث خطا ما اثناء تحميل الصورة"),
                                    ),
                                  );
                                },
                                loadingBuilder: (context, child, p) {
                                  if (p == null) {
                                    return child;
                                  } else {
                                    return SizedBox(
                                      width: SpacingResources.mainWidth(context) - 50,
                                      height: 200,
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey[400]!,
                                        highlightColor: Colors.grey[300]!,
                                        child: Container(
                                          width: 200,
                                          height: 100,
                                          color: ColorsResources.background,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
              const SizedBox(height: SizesResources.s2),
              SizedBox(
                width: SpacingResources.mainWidth(context),
                child: Row(
                  children: [
                    HomeViewItemWidget(
                      color: ColorsResources.homeBanks,
                      tColor: ColorsResources.blueText,
                      image: "assets/images/home/banks.png",
                      title: "بنوك الأسئلة",
                      onTap: () {
                        context.read<AuthCubit>().onCheck(
                          onSignedOut: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const AuthViewsManager(),
                              ),
                            );
                          },
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const BanksViewManager(),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    HomeViewItemWidget(
                      color: ColorsResources.homeTests,
                      tColor: ColorsResources.orangeText,
                      image: "assets/images/home/tests.gif",
                      title: "الاختبارات الالكترونية",
                      onTap: () {
                        context.read<AuthCubit>().onCheck(
                          onSignedOut: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const AuthViewsManager(),
                              ),
                            );
                          },
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const TestsViewManager(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SizesResources.s2),
              SizedBox(
                width: SpacingResources.mainWidth(context),
                child: Row(
                  children: [
                    HomeViewItemWidget(
                      color: ColorsResources.homeCodes,
                      tColor: ColorsResources.redText,
                      image: "assets/images/home/qr.gif",
                      title: "تعبئة نقاط",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CodesViewsManager(),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    HomeViewItemWidget(
                      color: ColorsResources.homeLocations,
                      tColor: ColorsResources.greenText,
                      image: "assets/images/home/locations.gif",
                      title: "مراكز البيع",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CodesSellersView(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SizesResources.s10),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeViewItemWidget extends StatelessWidget {
  const HomeViewItemWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.image,
    required this.color,
    this.tColor,
  });
  final String title, image;
  final Color color;
  final Color? tColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SpacingResources.mainHalfWidth(context),
      height: SpacingResources.mainHalfWidth(context),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: ShadowsResources.mainBoxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: SpacingResources.mainHalfWidth(context) / 3.5,
                backgroundColor: Colors.transparent,
                child: Image.asset(image),
              ),
              const SizedBox(height: SizesResources.s4),
              Text(
                title,
                style: const TextStyle(
                    // color: tColor,
                    // fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeAppBarWidget extends StatelessWidget {
  const HomeAppBarWidget({
    super.key,
    required this.onOpenSettings,
    required this.onOpenNotifications,
    required this.onOpenLikes,
    required this.onOpenResults,
  });
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenNotifications;
  final VoidCallback onOpenLikes;
  final VoidCallback onOpenResults;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: SpacingResources.sidePadding,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorsResources.darkPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onOpenSettings,
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.settings,
                      size: 22,
                      color: ColorsResources.blueText,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: SizesResources.s2),
            Container(
              decoration: BoxDecoration(
                color: ColorsResources.darkPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onOpenNotifications,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Stack(
                      children: [
                        const Icon(
                          Icons.notifications,
                          size: 22,
                          color: ColorsResources.orangeText,
                        ),
                        BlocBuilder<NotificationsCubit, NotificationsState>(
                          builder: (context, state) {
                            if (state is NotificationsInitial) {
                              return Positioned(
                                child: Icon(
                                  Icons.brightness_1,
                                  color: state.newNotifications ? Colors.red : Colors.transparent,
                                  size: 9,
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: SizesResources.s2),
            Container(
              decoration: BoxDecoration(
                color: ColorsResources.darkPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onOpenLikes,
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.favorite,
                      size: 22,
                      color: ColorsResources.redText,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: SizesResources.s2),
            Container(
              decoration: BoxDecoration(
                color: ColorsResources.darkPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onOpenResults,
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.assessment,
                      size: 22,
                      color: ColorsResources.greenText,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CodesViewsManager(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 13,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: ColorsResources.darkPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "نقاطي : ${locator<UserData>().balance}",
                  style: FontsResources.extraBoldStyle().copyWith(
                    color: ColorsResources.whiteText1,
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
