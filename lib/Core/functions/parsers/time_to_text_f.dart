String timeToText(DateTime dateTime) {
  // Determine AM or PM suffix based on the hour
  String suffix = dateTime.hour >= 12 ? "PM" : "AM";

  // Convert hour to 12-hour format
  int hour12 = dateTime.hour % 12;
  // Treat "0" hour as "12"
  hour12 = hour12 == 0 ? 12 : hour12;

  // Convert integers to strings and pad if necessary
  String h = hour12.toString().padLeft(2, '0');
  String m = dateTime.minute.toString().padLeft(2, '0');

  // Return the formatted time string with AM or PM
  return "$h:$m $suffix";
}
