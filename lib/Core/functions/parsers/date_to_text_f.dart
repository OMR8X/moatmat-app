String dateToTextFunction(DateTime dateTime) {
  String d = "${dateTime.day}".padLeft(2, "0");
  String m = "${dateTime.month}".padLeft(2, "0");
  return "$m/$d";
}
