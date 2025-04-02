import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../../Core/resources/colors_r.dart';
import '../state/codes_c/codes_cubit.dart';

class CodeScannerView extends StatefulWidget {
  const CodeScannerView({super.key});

  @override
  State<CodeScannerView> createState() => _CodeScannerViewState();
}

class _CodeScannerViewState extends State<CodeScannerView> {
  QRViewController? _controller;
  final qrKey = GlobalKey(debugLabel: "QR");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        overlay: QrScannerOverlayShape(
          borderWidth: 7.5,
          borderColor: ColorsResources.primary,
          borderLength: 35,
          borderRadius: 6,
        ),
        onQRViewCreated: (QRViewController controller) {
          setState(() {
            _controller = controller;
          });
          _controller!.scannedDataStream.listen((qrCode) {
            context.read<CodesCubit>().init(
                  code: qrCode.code,
                  msg: "تم مسح الكود بنجاح",
                );
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller?.pauseCamera();
    } else if (Platform.isIOS) {
      _controller?.resumeCamera();
    }
  }
}
