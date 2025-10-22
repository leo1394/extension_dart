/// Date format class for formatting dates
class DateFormat {
  final String _pattern;

  DateFormat(this._pattern);

  /// Format a DateTime using the pattern
  String format(DateTime dateTime) {
    return _formatDateTime(dateTime, _pattern);
  }

  /// Format DateTime with the given pattern
  String _formatDateTime(DateTime dateTime, String pattern) {
    String result = pattern;

    // Year patterns
    result = result.replaceAll('yyyy', _padLeft(dateTime.year.toString(), 4));
    result = result.replaceAll('yy', dateTime.year.toString().substring(2));

    // Month patterns
    result = result.replaceAll('MMMM', _getMonthName(dateTime.month));
    result = result.replaceAll('MMM', _getShortMonthName(dateTime.month));
    result = result.replaceAll('MM', _padLeft(dateTime.month.toString(), 2));
    result = result.replaceAll('M', dateTime.month.toString());

    // Day patterns
    result = result.replaceAll('dd', _padLeft(dateTime.day.toString(), 2));
    result = result.replaceAll('d', dateTime.day.toString());

    // Weekday patterns
    result = result.replaceAll('EEEE', _getWeekdayName(dateTime.weekday));
    result = result.replaceAll('EEE', _getShortWeekdayName(dateTime.weekday));
    result = result.replaceAll('E', _getShortWeekdayName(dateTime.weekday));

    // Hour patterns (24-hour)
    result = result.replaceAll('HH', _padLeft(dateTime.hour.toString(), 2));
    result = result.replaceAll('H', dateTime.hour.toString());

    // Hour patterns (12-hour)
    int hour12 = dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    result = result.replaceAll('hh', _padLeft(hour12.toString(), 2));
    result = result.replaceAll('h', hour12.toString());

    // Minute patterns
    result = result.replaceAll('mm', _padLeft(dateTime.minute.toString(), 2));
    result = result.replaceAll('m', dateTime.minute.toString());

    // Second patterns
    result = result.replaceAll('ss', _padLeft(dateTime.second.toString(), 2));
    result = result.replaceAll('s', dateTime.second.toString());

    // Millisecond patterns
    result =
        result.replaceAll('SSS', _padLeft(dateTime.millisecond.toString(), 3));
    result =
        result.replaceAll('SS', _padLeft(dateTime.millisecond.toString(), 2));
    result = result.replaceAll('S', dateTime.millisecond.toString());

    // Microsecond patterns
    result =
        result.replaceAll('uuu', _padLeft(dateTime.microsecond.toString(), 3));
    result =
        result.replaceAll('uu', _padLeft(dateTime.microsecond.toString(), 2));
    result = result.replaceAll('u', dateTime.microsecond.toString());

    // AM/PM patterns
    String ampm = dateTime.hour < 12 ? 'AM' : 'PM';
    result = result.replaceAll('a', ampm);

    return result;
  }

  /// Pad string with zeros on the left
  String _padLeft(String value, int width) {
    return value.padLeft(width, '0');
  }

  /// Get full month name
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  /// Get short month name
  String _getShortMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  /// Get full weekday name
  String _getWeekdayName(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[weekday - 1];
  }

  /// Get short weekday name
  String _getShortWeekdayName(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  // Predefined formatters
  static DateFormat yMd() => DateFormat('y/M/d');
  static DateFormat yMMMd() => DateFormat('MMM d, y');
  static DateFormat yMMMMEEEEd() => DateFormat('EEEE, MMMM d, y');
  static DateFormat yMMMEd() => DateFormat('EEE, MMM d, y');
  static DateFormat Hms() => DateFormat('H:mm:ss');
  static DateFormat Hm() => DateFormat('H:mm');
  static DateFormat hms() => DateFormat('h:mm:ss a');
  static DateFormat hm() => DateFormat('h:mm a');
  static DateFormat ms() => DateFormat('m:ss');
  static DateFormat y() => DateFormat('y');
  static DateFormat M() => DateFormat('M');
  static DateFormat d() => DateFormat('d');
  static DateFormat H() => DateFormat('H');
  static DateFormat m() => DateFormat('m');
  static DateFormat s() => DateFormat('s');
}
