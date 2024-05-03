import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Core/validators/not_empty_v.dart';
import 'package:moatmat_app/User/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_app/User/Features/banks/domain/entites/bank_q.dart';
import 'package:moatmat_app/User/Features/reports/domain/usecases/report_on_bank_uc.dart';
import 'package:moatmat_app/User/Features/reports/domain/usecases/report_on_test_uc.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/question.dart';

reportOnQuestion({
  required BuildContext context,
  required int id,
  required String teacherEmail,
  required String name,
  Question? bQuestion,
  Question? tQuestion,
}) {
  showDialog(
    context: context,
    builder: (context) => ReportDialog(
      id: id,
      bQuestion: bQuestion,
      tQuestion: tQuestion,
      teacher: teacherEmail,
      name: name,
    ),
  );
}

class ReportDialog extends StatefulWidget {
  const ReportDialog({
    super.key,
    required this.id,
    this.bQuestion,
    this.tQuestion,
    required this.teacher,
    required this.name,
  });
  final int id;
  final Question? bQuestion;
  final Question? tQuestion;
  final String teacher;
  final String name;
  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final _formKey = GlobalKey<FormState>();
  late String message;
  bool loading = false;
  report() async {
    setState(() {
      loading = true;
    });
    if (widget.bQuestion != null) {
      await locator<ReportOnBankUseCase>()
          .call(
        questionID: widget.bQuestion!.id,
        message: message,
        bankID: widget.id,
        name: widget.name,
        teacher: widget.teacher,
      )
          .then((value) {
        value.fold(
          (l) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("حصل خطآ ما"),
              ),
            );
            Navigator.of(context).pop();
          },
          (r) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم ارسال الابلاغ بنجاح"),
              ),
            );
            Navigator.of(context).pop();
          },
        );
      });
    } else if (widget.tQuestion != null) {
      await locator<ReportOnTestUseCase>()
          .call(
        questionID: widget.tQuestion!.id,
        message: message,
        testID: widget.id,
        name: widget.name,
        teacher: widget.teacher,
      )
          .then((value) {
        value.fold(
          (l) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("حصل خطآ ما"),
              ),
            );
            Navigator.of(context).pop();
          },
          (r) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم ارسال الابلاغ بنجاح"),
              ),
            );
            Navigator.of(context).pop();
          },
        );
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: const Text("الابلاغ عن سؤال"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: SizesResources.s2),
            MyTextFormFieldWidget(
              hintText: "يرجى ذكر سبب الابلاغ",
              validator: (s) {
                return notEmptyValidator(text: s);
              },
              width: SpacingResources.mainWidth(context) - 150,
              onSaved: (p0) {
                message = p0!;
              },
            ),
            const SizedBox(height: SizesResources.s2),
          ],
        ),
        actions: loading
            ? [
                const Center(
                  child: CupertinoActivityIndicator(),
                )
              ]
            : [
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: ColorsResources.borders,
                  ),
                  child: const Text("الغاء"),
                ),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      report();
                    }
                  },
                  child: const Text("ابلاغ"),
                ),
              ],
      ),
    );
  }
}
