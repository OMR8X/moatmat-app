import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_app/Core/injection/app_inj.dart';
import 'package:moatmat_app/Features/auth/domain/entites/user_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';

class MyQrCodeView extends StatefulWidget {
  const MyQrCodeView({
    super.key,
  });

  @override
  State<MyQrCodeView> createState() => _MyQrCodeViewState();
}

class _MyQrCodeViewState extends State<MyQrCodeView> {
  late ScreenshotController screenshotController;

  takeScreenShot() async {
    //
    Rect rect = getRect();
    //
    var value = await screenshotController.capture();
    //
    if (value == null) {
      Fluttertoast.showToast(msg: "حصل خطأ ما");
      return;
    }
    //
    final filePath = await getFilePath();
    //
    await XFile.fromData(value).saveTo(filePath);
    //
    await Share.shareXFiles(
      [XFile(filePath)],
    );
    //
    return;
  }

  Rect getRect() {
    return Rect.fromCenter(
      center: Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      ),
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
    );
  }

  Future<String> getFilePath() async {
    //
    Directory? externalDir;
    //
    if (Platform.isIOS) {
      externalDir = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      externalDir = await getExternalStorageDirectory();
    } else {
      externalDir = await getApplicationSupportDirectory();
    }
    //
    final ts = DateTime.now().toIso8601String();
    //
    final filePath = "${externalDir!.path}/$ts.png";
    //
    return filePath;
  }

  @override
  void initState() {
    screenshotController = ScreenshotController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: ColorsResources.primary,
        title: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            "كود تسجيل الحضور",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              takeScreenShot();
            },
            icon: Icon(Icons.save_alt),
          )
        ],
      ),
      backgroundColor: ColorsResources.primary,
      body: Screenshot(
        controller: screenshotController,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Container(
                  color: ColorsResources.primary,
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizesResources.s10 * 3,
                        width: MediaQuery.sizeOf(context).width,
                      ),
                      //
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width / 1.60,
                              height: MediaQuery.sizeOf(context).width / 1.60,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: QrImageView(
                              eyeStyle: const QrEyeStyle(
                                color: Colors.black,
                                eyeShape: QrEyeShape.square,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                color: Colors.black,
                                dataModuleShape: QrDataModuleShape.square,
                              ),
                              data: locator<UserData>().toQrValue(),
                              version: QrVersions.auto,
                              size: MediaQuery.sizeOf(context).width / 1.75,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SizesResources.s8),
                      Text(
                        "الاسم : ${locator<UserData>().name}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: SizesResources.s2),
                      Text(
                        "رقم الطالب : ${locator<UserData>().id.toString().padLeft(6, '0')}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: SizesResources.s10 * 3,
                      ),
                    ],
                  ),
                ),
              ),

              //
              const SizedBox(height: SizesResources.s10),
            ],
          ),
        ),
      ),
    );
  }
}
