import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Features/auth/domain/entites/user_data.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../exploring/explore_no_time_v.dart';
import '../exploring/full_time_explore_v.dart';
import '../exploring/per_question_explore_v.dart';

class CheckIfTestDone extends StatefulWidget {
  const CheckIfTestDone({super.key, required this.test});
  final Test test;
  @override
  State<CheckIfTestDone> createState() => _CheckIfTestDoneState();
}

class _CheckIfTestDoneState extends State<CheckIfTestDone> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checking();
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
    if (widget.test.returnable) {
      onOpen();
      return;
    }
    var res = await Supabase.instance.client
        .from("results")
        .select()
        .eq("user_id", locator<UserData>().uuid)
        .eq("test_id", widget.test.id);
    if (res.isEmpty) {
      onOpen();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("لا يمكنك اعادة الاختبار"),
          ),
        );
      }
    }
  }

  onOpen() {
    if (widget.test.seconds == null || widget.test.seconds == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TestExploreNoTimeView(
            test: widget.test,
          ),
        ),
      );
    } else {
      if (widget.test.timePerQuestion) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TestPerQuestionExploreView(
              minutes: widget.test.seconds!,
              test: widget.test,
            ),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TestFullTimeExploreView(
              minutes: widget.test.seconds!,
              test: widget.test,
            ),
          ),
        );
      }
    }
  }
}
