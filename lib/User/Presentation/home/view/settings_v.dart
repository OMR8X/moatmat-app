import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_app/User/Features/update/domain/entites/update_info.dart';
import 'package:moatmat_app/User/Presentation/home/view/about_us_v.dart';
import 'package:moatmat_app/User/Presentation/home/view/communicate_with_us_v.dart';
import 'package:moatmat_app/User/Presentation/home/view/how_to_use_v.dart';
import '../../../Core/injection/app_inj.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/texts_resources.dart';
import '../../../Features/auth/domain/entites/user_data.dart';
import '../../auth/state/auth_c/auth_cubit_cubit.dart';
import '../../auth/view/change_password_v.dart';
import '../../auth/view/update_user_data_v.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppBarTitles.settings),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: SizesResources.s1),
            TouchableTileWidget(
              title: "تحديث بيانات المستخدم",
              iconData: Icons.refresh_rounded,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UpdateUserDataView(
                      userData: locator<UserData>(),
                    ),
                  ),
                );
              },
            ),
            TouchableTileWidget(
              title: "تغيير كلمة السر",
              iconData: Icons.password_outlined,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordView(
                      userData: locator<UserData>(),
                    ),
                  ),
                );
              },
            ),
            TouchableTileWidget(
              title: AppBarTitles.commonQuestions,
              iconData: Icons.account_tree_rounded,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HowToUseAppView(),
                  ),
                );
              },
            ),
            TouchableTileWidget(
              title: "حولنا",
              iconData: Icons.info_outline,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AboutUsView(),
                  ),
                );
              },
            ),
            TouchableTileWidget(
              title: "تواصل معنا",
              iconData: Icons.support,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CommunicateWithUsView(),
                  ),
                );
              },
            ),
            TouchableTileWidget(
              title: "تسجيل الخروج",
              iconData: Icons.logout_rounded,
              onTap: () async {
                context.read<AuthCubit>().startSignOut();
                Navigator.of(context).pop();
              },
            ),
            const Spacer(),
            const SizedBox(height: SizesResources.s2),
            Text(
              "ID : ${locator<UserData>().id.toString().padLeft(6, "0")}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: SizesResources.s1),
            Text(
              "رقم الاصدار : ${locator<UpdateInfo>().getVersionText()}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: SizesResources.s1),
            Text(
              locator<UserData>().email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: SizesResources.s10),
          ],
        ),
      ),
    );
  }
}
