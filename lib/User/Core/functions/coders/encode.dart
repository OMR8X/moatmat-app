String encodeFileName(String fileName) {
  //
  String result = fileName;
  //
  fileName = fileName.replaceAll("?", "");
  //
  fileName = fileName.replaceAll("-", "_");
  fileName = fileName.replaceAll(" ", "_");
  //
  result = result.replaceAll(".pdf", "");
  //
  result = Uri.encodeFull(result);
  //
  result = result.replaceAll("%", "____");
  //
  return result;
}
