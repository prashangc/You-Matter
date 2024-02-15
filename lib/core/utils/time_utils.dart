DateTime parseTimeString(String timeString) {
  List<String> timeParts = timeString.split(' ');
  List<String> hourMinute = timeParts[0].split(':');

  int hours = int.parse(hourMinute[0]);
  int minutes = int.parse(hourMinute[1]);

  if (timeParts[1] == 'PM' && hours != 12) {
    hours += 12;
  } else if (timeParts[1] == 'AM' && hours == 12) {
    hours = 0;
  }

  return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
      hours, minutes);
}

int findClosestTimeIndex(List<String> times) {
  DateTime currentTime = DateTime.now();
  final time = times.reduce((value, element) =>
      parseTimeString(value).difference(currentTime).abs() <
              parseTimeString(element).difference(currentTime).abs()
          ? value
          : element);
  return times.indexOf(time);
}
