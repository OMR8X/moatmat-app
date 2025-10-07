import 'package:flutter/material.dart';

String decodeFileName(String fileName) {
  //
  if (!fileName.contains("____")) {
    fileName = fileName.replaceAll(".pdf", "");
    fileName = fileName.replaceAll("_", " ");
    return fileName;
  }
  String result = "";
  //
  fileName = fileName.replaceAll("_____", "_%");
  fileName = fileName.replaceAll("____", "%");
  fileName = fileName.replaceAll(".pdf", "");
  //
  List<String> strList = fileName.split("_");
  strList.removeWhere((e) => e.isEmpty || e == '%');
  //
  debugPrint("debug: strList: $strList");
  for (var str in strList) {
    try {
      String current = str;
      debugPrint("debug: current: $current");
      result = "$result ${Uri.decodeFull(current)}";
    } on Exception catch (e) {
      result = "$result $str";
    }
  }

  return result;
}

String decodeFileNameKeepExtension(String fileName, String extension) {
  //
  if (!fileName.contains("____")) {
    fileName = fileName.replaceAll(".pdf", "");
    fileName = fileName.replaceAll("_", " ");
    return fileName;
  }
  String result = "";
  //
  fileName = fileName.replaceAll("_____", "_%");
  fileName = fileName.replaceAll("____", "%");
  fileName = fileName.replaceAll(".pdf", "");
  //
  List<String> strList = fileName.split("_");
  strList.removeWhere((e) => e.isEmpty || e == '%');
  //
  for (var str in strList) {
    try {
      String current = str;
      result = "$result ${Uri.decodeFull(current)}";
    } on Exception catch (e) {
      result = "$result $str";
    }
  }
  return '${result.trim()}$extension';
}
