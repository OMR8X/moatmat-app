  String periodToTextFunction(int seconds) {
    Duration time = Duration(seconds: seconds);
    String h = (time.inHours % 60).toString();
    String m = (time.inMinutes % 60).toString();
    String s = (time.inSeconds % 60).toString();
    if (time.inHours > 0) {
      return "${h.padLeft(2, "0")}:${m.padLeft(2, "0")}:${s.padLeft(2, "0")}";
    } else {
      return "${m.padLeft(2, "0")}:${s.padLeft(2, "0")}";
    }
  }