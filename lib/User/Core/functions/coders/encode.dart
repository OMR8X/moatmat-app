String encodeFileName(String fileName) {
  //
  String result = fileName;
  //
  result = result.replaceAll(".pdf", "");
  //
  result = Uri.encodeFull(result);
  //
  result = result.replaceAll("%", "____");
  //
  return result;
}
