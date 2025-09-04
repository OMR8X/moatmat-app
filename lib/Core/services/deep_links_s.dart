import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moatmat_app/Core/resources/colors_r.dart';
import 'package:moatmat_app/Core/resources/sizes_resources.dart';

class DeepLinkService {
  static String packageName = "com.moatmat.app";
  static String baseLink = "https://moatmat.page.link";
  static initDeepLinks({
    required Function({int? bankId, int? testId, int? questionId}) onGetLink,
  }) async {
    FirebaseDynamicLinks.instance.onLink.listen((event) {
      var queryParameters = event.link.queryParameters;
      if (queryParameters["type"] == "test") {
        onGetLink(
          testId: int.parse(
            queryParameters["id"]!,
          ),
          questionId: int.parse(
            queryParameters["questionId"]!,
          ),
        );
      } else {
        onGetLink(
          bankId: int.parse(
            queryParameters["id"]!,
          ),
          questionId: int.parse(
            queryParameters["questionId"]!,
          ),
        );
      }
    });
  }

  static Future<void> createDynamicLink({
    int? bankId,
    int? testId,
    required int questionId,
    required BuildContext context,
  }) async {
    showDialog(
      context: context,
      builder: (context) => CreatingLinkDialogWidget(
        bankId: bankId,
        testId: testId,
        questionId: questionId,
      ),
    );
  }
}

class CreatingLinkDialogWidget extends StatefulWidget {
  const CreatingLinkDialogWidget({
    super.key,
    this.bankId,
    this.testId,
    required this.questionId,
  });
  final int? bankId;
  final int? testId;
  final int questionId;
  @override
  State<CreatingLinkDialogWidget> createState() =>
      _CreatingLinkDialogWidgetState();
}

class _CreatingLinkDialogWidgetState extends State<CreatingLinkDialogWidget> {
  //
  bool loading = false;
  String? link;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "انشاء رابط لمشاركة السؤال",
        style: TextStyle(fontSize: 14),
      ),
      content: FutureBuilder<String>(
        future: createLink(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: snapshot.data!))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("تم نسخ الرابط"),
                        ),
                      );
                    });
                  },
                  child: Text(
                    snapshot.data!,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: SizesResources.s2),
                const Text(
                  "انقر للنسخ",
                  style: TextStyle(
                    fontSize: 10,
                    color: ColorsResources.blackText2,
                  ),
                )
              ],
            );
          } else {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: SizesResources.s3),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoActivityIndicator(),
                      SizedBox(height: SizesResources.s3),
                      Text(
                        "يجب عليك تشغيل برنامج VPN",
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizesResources.s3),
              ],
            );
          }
        },
      ),
    );
  }

  Future<String> createLink() async {
    String type = "";
    String id = "";
    String questionId = "";
    if (widget.bankId != null) {
      type = "bank";
      id = widget.bankId.toString();
    }
    if (widget.testId != null) {
      type = "test";
      id = widget.testId.toString();
    }
    questionId = widget.questionId.toString();
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          "${DeepLinkService.baseLink}/search?id=$id&questionId=$questionId&type=$type"),
      uriPrefix: DeepLinkService.baseLink,
      androidParameters: AndroidParameters(
        packageName: DeepLinkService.packageName,
      ),
      iosParameters: IOSParameters(
        bundleId: DeepLinkService.packageName,
      ),
    );
    //
    ShortDynamicLink unguessableDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(
      dynamicLinkParams,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );
    return (unguessableDynamicLink.shortUrl.toString());
  }
}
