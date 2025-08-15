import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/widgets/ui/empty_list_text.dart';
import 'package:moatmat_app/User/Presentation/banks/views/banks/setting_up_banke.dart';
import 'package:moatmat_app/User/Presentation/tests/view/tests/tests_view_manager.dart';

import '../../../Core/functions/show_alert.dart';
import '../../../Core/injection/app_inj.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/fonts_r.dart';
import '../../../Core/widgets/view/pick_folder_v.dart';
import '../../../Features/banks/domain/entites/bank.dart';
import '../../../Features/tests/domain/entities/test.dart';
import '../../banks/views/bank_tile_w.dart';
import '../../tests/state/download_test/download_test_bloc.dart';
import '../../tests/view/downloading/download_test_view.dart';
import '../../tests/view/tests/check_if_test_done_v.dart';
import '../../tests/view/tests/pick_test_v.dart';
import '../../tests/widgets/test_tile_w.dart';

class SubFoldersView extends StatelessWidget {
  const SubFoldersView({
    super.key,
    required this.folders,
    required this.openDirectory,
    this.onPop,
    required this.banks,
    required this.tests,
  });
  //
  final List<String> folders;
  //
  final List<Bank> banks;
  //
  final List<Test> tests;
  //
  final void Function(String) openDirectory;
  //
  final void Function()? onPop;
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      appBar: AppBar(
        backgroundColor: ColorsResources.primary,
        foregroundColor: ColorsResources.whiteText1,
        automaticallyImplyLeading: false,
        leading: onPop != null
            ? IconButton(
                onPressed: onPop,
                icon: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: ColorsResources.whiteText1,
                ),
              )
            : null,
        actions: const [],
      ),
      body: (getItemLength() <= 0)
          ? const EmptyListTextWidget()
          : ListView.builder(
              itemCount: getItemLength(),
              itemBuilder: (context, index) {
                return getWidgetByIndex(context, index);
              },
            ),
    );
  }

  int getItemLength() {
    int length = 0;
    length += folders.length;
    length += tests.length;
    length += banks.length;
    return length;
  }

  Widget getWidgetByIndex(BuildContext context, int index) {
    //
    int fLength = folders.length;
    int tLength = tests.length;
    //
    if (index < fLength) {
      return FolderItemWidget(
        name: folders[index],
        onTap: () {
          openDirectory(folders[index]);
        },
      );
    } else if (index < fLength + tLength) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: SizesResources.s3),
        child: TestTileWidget(
          test: tests[index - fLength],
          onPick: () async {
            showDialog(
              context: context,
              builder: (context) => BuyTestWidget(
                test: tests[index - fLength],
                onPick: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CheckIfTestDone(
                        test: tests[index - fLength],
                      ),
                    ),
                  );
                },
                onDownload: (testId) {
                  // wrap with bloc provider
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => locator<DownloadTestBloc>(),
                        child: DownloadTestView(testId: testId),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
      //
    } else {
      return BankTileWidget(
        bank: banks[index - (tLength + fLength)],
        onPick: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SettingUpBankView(bank: banks[index - (tLength + fLength)]),
            ),
          );
        },
      );
    }
  }
}
