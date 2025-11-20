/// Date format class for formatting dates
class DateFormat {
  /// Format a DateTime using the pattern
  static String format([DateTime? dateTime, String pattern = 'yyyy-MM-dd']) {
    dateTime ??= DateTime.now();
    return _formatDateTime(dateTime, pattern);
  }

  /// Format DateTime with the given pattern
  static String _formatDateTime(DateTime dateTime, String pattern) {
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
  static String _padLeft(String value, int width) {
    return value.padLeft(width, '0');
  }

  /// Get full month name
  static String _getMonthName(int month) {
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
  static String _getShortMonthName(int month) {
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
  static String _getWeekdayName(int weekday) {
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
  static String _getShortWeekdayName(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  // Predefined formatters
  static String yMd([DateTime? datetime]) =>
      DateFormat.format(datetime, 'y/M/d');
  static String yMMMd([DateTime? datetime]) =>
      DateFormat.format(datetime, 'MMM d, y');
  static String yMMMMEEEEd([DateTime? datetime]) =>
      DateFormat.format(datetime, 'EEEE, MMMM d, y');
  static String yMMMEd([DateTime? datetime]) =>
      DateFormat.format(datetime, 'EEE, MMM d, y');
  static String Hms([DateTime? datetime]) =>
      DateFormat.format(datetime, 'H:mm:ss');
  static String HHmmss([DateTime? datetime]) =>
      DateFormat.format(datetime, 'HH:mm:ss');
  static String Hm([DateTime? datetime]) => DateFormat.format(datetime, 'H:mm');
  static String hms([DateTime? datetime]) =>
      DateFormat.format(datetime, 'h:mm:ss a');
  static String hm([DateTime? datetime]) =>
      DateFormat.format(datetime, 'h:mm a');
  static String ms([DateTime? datetime]) => DateFormat.format(datetime, 'm:ss');
  static String y([DateTime? datetime]) => DateFormat.format(datetime, 'y');
  static String M([DateTime? datetime]) => DateFormat.format(datetime, 'M');
  static String d([DateTime? datetime]) => DateFormat.format(datetime, 'd');
  static String H([DateTime? datetime]) => DateFormat.format(datetime, 'H');
  static String m([DateTime? datetime]) => DateFormat.format(datetime, 'm');
  static String s([DateTime? datetime]) => DateFormat.format(datetime, 's');
}
