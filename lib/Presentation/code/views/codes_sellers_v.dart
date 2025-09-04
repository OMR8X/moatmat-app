import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moatmat_app/Core/constant/materials.dart';
import 'package:moatmat_app/Core/injection/app_inj.dart';
import 'package:moatmat_app/Core/resources/images_r.dart';
import 'package:moatmat_app/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_app/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/Presentation/code/state/centers/codes_centers_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Core/app/admin_info.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/resources/texts_resources.dart';
import '../widgets/code_center_w.dart';

class CodesSellersView extends StatefulWidget {
  const CodesSellersView({super.key});

  @override
  State<CodesSellersView> createState() => _CodesSellersViewState();
}

class _CodesSellersViewState extends State<CodesSellersView> {
  @override
  void initState() {
    context.read<CodesCentersCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CodesCentersCubit, CodesCentersState>(
        builder: (context, state) {
          if (state is CodesCentersGovernorate) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(AppBarTitles.codesSellers),
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
              body: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: SizesResources.s2,
                  vertical: SizesResources.s2,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: SizesResources.s2,
                  crossAxisSpacing: SizesResources.s2,
                ),
                itemCount: state.governorate.length,
                itemBuilder: (context, index) {
                  return GovernorateWidget(
                    governorate: state.governorate[index],
                    onTap: () {
                      context.read<CodesCentersCubit>().exploreGovernorate(
                            state.governorate[index],
                          );
                    },
                  );
                },
              ),
            );
          } else if (state is CodesCentersExplore) {
            return Scaffold(
              appBar: AppBar(
                title: Text(state.governorate),
                leading: IconButton(
                  onPressed: () {
                    context.read<CodesCentersCubit>().back();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
              body: Column(
                children: [
                  const BuyOnlineWidget(),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpacingResources.sidePadding,
                        vertical: SizesResources.s2,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: SizesResources.s2,
                        crossAxisSpacing: SizesResources.s2,
                      ),
                      itemCount: state.centers.length,
                      itemBuilder: (context, index) {
                        return CodeCenterWidget(center: state.centers[index]);
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is CodesCentersError) {
            return const Center();
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}

class GovernorateWidget extends StatelessWidget {
  const GovernorateWidget({super.key, required this.governorate, required this.onTap});
  final String governorate;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsResources.onPrimary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: ShadowsResources.mainBoxShadow,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: SizesResources.s4),
                SizedBox(
                  width: SpacingResources.mainHalfWidth(context) / 2,
                  child: Image.asset(getImage(governorate)),
                ),
                //
                const SizedBox(height: SizesResources.s4),
                //
                Text(governorate),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getImage(String s) {
    s = s.replaceAll(" ", "-");
    return "assets/images/governorates/$s.png";
  }
}

class BuyOnlineWidget extends StatelessWidget {
  const BuyOnlineWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SpacingResources.mainWidth(context),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ColorsResources.whiteText1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "شراء اكواد اونلاين",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: SizesResources.s1),
          const Text(
            "تواصل معنا على الواتساب لشراء الاكواد اونلاين",
            style: TextStyle(
              fontSize: 12,
              color: ColorsResources.blackText2,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: SizesResources.s4),
          SizedBox(
            height: 40,
            width: SpacingResources.mainWidth(context),
            child: ElevatedButton(
              onPressed: () {
                openWhatsApp(message: "ارغب بشراء كود لتطبيق مؤتمت");
              },
              child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Image.asset(
                          ImagesResources.whatsappImage,
                          width: 25,
                        ),
                      ),
                      const SizedBox(width: SizesResources.s2),
                      const Text(
                        "شراء اكواد اونلاين",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Future openWhatsApp({required String message}) async {
    var phoneUri = Uri(scheme: "tel", path: AdminInfo.whatsapp);
    var whatsappUri = Uri.parse("${AdminInfo.whatsapp}?text=$message");
    //
    if (!(await launchUrl(whatsappUri))) {
      await launchUrl(phoneUri);
    }
  }
}
