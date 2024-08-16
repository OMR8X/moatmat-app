import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/app/admin_info.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_app/User/Features/update/domain/entites/update_info.dart';
import 'package:moatmat_app/User/Presentation/auth/state/auth_c/auth_cubit_cubit.dart';
import 'package:moatmat_app/User/Presentation/auth/view/auth_views_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateView extends StatelessWidget {
  const UpdateView({super.key, required this.updateInfo});
  final UpdateInfo updateInfo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.download_for_offline,
              size: 150,
              color: ColorsResources.darkPrimary,
            ),
            //
            const SizedBox(height: SizesResources.s2),
            //
            Text(
              updateInfo.appVersion >= updateInfo.minimumVersion
                  ? "يتوفر تحديث جديد"
                  : "التحديث مطلوب",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
                color: ColorsResources.blackText1,
              ),
            ),
            //
            const SizedBox(height: SizesResources.s1),
            //
            if (updateInfo.appVersion < updateInfo.minimumVersion)
              Text(
                "الاصدار الادنى : ${updateInfo.minimumVersion}",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: ColorsResources.blackText2,
                ),
              ),
            Text(
              "الاصدار الحالي : ${updateInfo.appVersion}",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: ColorsResources.blackText2,
              ),
            ),
            if (updateInfo.appVersion >= updateInfo.minimumVersion)
              Text(
                "الاصدار الاحدث : ${updateInfo.currentVersion}",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: ColorsResources.blackText2,
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButtonWidget(
            text: "تحميل احدث اصدار",
            onPressed: () async {
              await launchUrl(Uri.parse(AdminInfo.telegram));
            },
          ),
          if (updateInfo.appVersion >= updateInfo.minimumVersion) ...[
            const SizedBox(height: SizesResources.s2),
            ElevatedButtonWidget(
              text: "تخطي",
              onPressed: () {
                context.read<AuthCubit>().skipUpdate();
              },
            ),
          ],
          const SizedBox(height: SizesResources.s10),
        ],
      ),
    );
  }
}
