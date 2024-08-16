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
  strList.removeWhere((e) => e.isEmpty);
  //
  for (var str in strList) {
    //
    String current = str;
    result = "$result ${Uri.decodeFull(current)}";
  }

  return result;
}
