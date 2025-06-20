String timeAgo(String timestamp) {
  final dateTime = DateTime.parse(timestamp);
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'الآن';
  } else if (difference.inMinutes < 60) {
    return 'قبل ${difference.inMinutes} دقيقة';
  } else if (difference.inHours < 24) {
    return 'قبل ${difference.inHours} ساعة';
  } else if (difference.inDays < 7) {
    return 'قبل ${difference.inDays} يوم';
  } else if (difference.inDays < 30) {
    int weeks = (difference.inDays / 7).floor();
    return 'قبل $weeks أسبوع';
  } else if (difference.inDays < 365) {
    int months = (difference.inDays / 30).floor();
    return 'قبل $months شهر';
  } else {
    int years = (difference.inDays / 365).floor();
    return 'قبل $years سنة';
  }
}
