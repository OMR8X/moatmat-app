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
  //
  List<String> strList = fileName.split("_");
  strList.removeWhere((e) => e.isEmpty);
  //
  for (var str in strList) {
    //
    String current = str;
    result = "$result ${Uri.decodeFull(current)}";
  }

  return result.split(".").first.trim();
}

String decodeFileNameKeepExtension(String fileName) {
  // Extract the file extension first
  String extension = '';
  if (fileName.contains('.')) {
    int lastDotIndex = fileName.lastIndexOf('.');
    extension = fileName.substring(lastDotIndex);
    fileName = fileName.substring(0, lastDotIndex);
  }

  //
  if (!fileName.contains("____")) {
    fileName = fileName.replaceAll("_", " ");
    return '$fileName$extension';
  }
  String result = "";
  //
  fileName = fileName.replaceAll("_____", "_%");
  fileName = fileName.replaceAll("____", "%");
  //
  List<String> strList = fileName.split("_");
  strList.removeWhere((e) => e.isEmpty);
  //
  for (var str in strList) {
    //
    String current = str;
    result = "$result ${Uri.decodeFull(current)}";
  }

  return '${result.trim()}$extension';
}
