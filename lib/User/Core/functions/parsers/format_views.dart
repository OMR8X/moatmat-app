String formatViews(int num) {
  if (num >= 1000000) {
    double millions = num / 1000000;
    return '${millions.toStringAsFixed(millions.truncateToDouble() == millions ? 0 : 1)} مليون';
  } else if (num >= 1000) {
    double thousands = num / 1000;
    return '${thousands.toStringAsFixed(thousands.truncateToDouble() == thousands ? 0 : 1)} ألف';
  } else {
    return '$num';
  }
}
