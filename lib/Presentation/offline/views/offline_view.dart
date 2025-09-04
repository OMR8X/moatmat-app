import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/Presentation/code/views/code_views_manager.dart';
import 'package:moatmat_app/Presentation/home/view/my_qr_code_view.dart';
import 'package:moatmat_app/Presentation/offline/views/explore_tests_offline_view.dart';

import '../../../Core/injection/app_inj.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/fonts_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../auth/state/auth_c/auth_cubit_cubit.dart';
import '../../home/view/home_v.dart';

class OfflineView extends StatefulWidget {
  const OfflineView({super.key});

  @override
  State<OfflineView> createState() => _OfflineViewState();
}

class _OfflineViewState extends State<OfflineView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      body: Column(
        children: [
          OfflineAppBarWidget(),
          const OfflineBodyWidget(),
        ],
      ),
    );
  }
}

class OfflineAppBarWidget extends StatelessWidget {
  const OfflineAppBarWidget({super.key});

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
          spacing: SizesResources.s2,
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
                  onTap: () {
                    context.read<AuthCubit>().init();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.refresh,
                      size: 22,
                      color: ColorsResources.blueText,
                    ),
                  ),
                ),
              ),
            ),
            // Offline mode indicator
            Container(
              decoration: BoxDecoration(
                color: ColorsResources.darkPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.wifi_off,
                      size: 22,
                      color: ColorsResources.orangeText,
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

class OfflineBodyWidget extends StatelessWidget {
  const OfflineBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: SizesResources.s10),
              SizedBox(
                width: SpacingResources.mainWidth(context),
                child: Row(
                  children: [
                    HomeViewItemWidget(
                      color: ColorsResources.homeCodes,
                      tColor: ColorsResources.redText,
                      image: "assets/images/home/qr.gif",
                      title: "رمز الحضور",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MyQrCodeView(),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    HomeViewItemWidget(
                      color: ColorsResources.homeTests,
                      tColor: ColorsResources.orangeText,
                      image: "assets/images/home/tests.gif",
                      title: "الاختبارات المحفوظة",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ExploreTestsOfflineView(),
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
