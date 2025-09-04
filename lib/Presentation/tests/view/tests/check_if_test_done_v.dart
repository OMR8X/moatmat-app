import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/Core/injection/app_inj.dart';
import 'package:moatmat_app/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/Features/tests/domain/usecases/can_do_test_uc.dart';
import 'package:moatmat_app/Presentation/videos/view/test_assets_v.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/functions/show_alert.dart';
import '../exploring/explore_no_time_v.dart';
import '../exploring/full_time_explore_v.dart';
import '../exploring/per_question_explore_v.dart';

class CheckIfTestDone extends StatefulWidget {
  const CheckIfTestDone({super.key, required this.test, this.isOffline = false});
  final bool isOffline;
  final Test test;
  @override
  State<CheckIfTestDone> createState() => _CheckIfTestDoneState();
}

class _CheckIfTestDoneState extends State<CheckIfTestDone> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.isOffline) {
        onOpen();
        return;
      }
      if (widget.test.information.previous != null) {
        locator<CanDoTestUC>().call(test: widget.test.information.previous!).then((v) {
          v.fold(
            (l) {
              exitWithMsg("حصل خطآ اثناء الاتصال بالخادم");
            },
            (r) {
              if (r) {
                checking();
              } else {
                String title = widget.test.information.previous!.title;
                Navigator.of(context).pop();
                showAlert(
                  context: context,
                  title: "تنبيه",
                  body: "يجب عليك حل الاختبار : \"$title\" \n لكي تتمكن من فتح الاختبار",
                  onAgree: () {},
                );
              }
            },
          );
        });
      } else {
        checking();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }

  Future checking() async {
    if (kDebugMode) {
      onOpen();
      return;
    }
    //
    if (widget.test.properties.repeatable ?? false) {
      onOpen();
      return;
    }
    var res = await Supabase.instance.client.from("results").select().eq("user_id", locator<UserData>().uuid).eq("test_id", widget.test.id);
    if (res.isEmpty) {
      onOpen();
    } else {
      if (mounted) {
        exitWithMsg("لا يمكنك اعادة الاختبار");
      }
    }
  }

  exitWithMsg(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  onOpen() {
    bool con1 = widget.test.information.videos?.isNotEmpty ?? false;
    bool con2 = widget.test.information.files?.isNotEmpty ?? false;
    bool con3 = widget.test.information.images?.isNotEmpty ?? false;
    if (con1 || con2 || con3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TestAssetsView(
            test: widget.test,
            isOffline: widget.isOffline,
          ),
        ),
      );
    } else {
      openTest();
    }
  }

  openTest() async {
    if (widget.test.information.period == 0 || widget.test.information.period == null) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TestExploreNoTimeView(
            test: widget.test,
          ),
        ),
      );
    } else {
      if (widget.test.properties.timePerQuestion ?? false) {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TestPerQuestionExploreView(
              minutes: widget.test.information.period!,
              test: widget.test,
            ),
          ),
        );
      } else {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TestFullTimeExploreView(
              minutes: widget.test.information.period!,
              test: widget.test,
            ),
          ),
        );
      }
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
