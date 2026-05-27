// ignore_for_file: unnecessary_this

import '../date_format.dart';
import '../utils.dart';
import 'time.dart';

DateTime _copyDateTime(
  DateTime source, {
  int? year,
  int? month,
  int? day,
  int? hour,
  int? minute,
  int? second,
  int? millisecond,
  int? microsecond,
}) {
  final values = [
    year ?? source.year,
    month ?? source.month,
    day ?? source.day,
    hour ?? source.hour,
    minute ?? source.minute,
    second ?? source.second,
    millisecond ?? source.millisecond,
    microsecond ?? source.microsecond,
  ];

  return source.isUtc
      ? DateTime.utc(
          values[0],
          values[1],
          values[2],
          values[3],
          values[4],
          values[5],
          values[6],
          values[7],
        )
      : DateTime(
          values[0],
          values[1],
          values[2],
          values[3],
          values[4],
          values[5],
          values[6],
          values[7],
        );
}

/// Convenience methods for working with [DateTime] values.
extension DateExtension on DateTime {
  /// Returns the end of Current date
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999, 999);
  }

  /// Returns the start of Current date
  DateTime get startOfDay {
    return DateTime(year, month, day, 0, 0, 0, 0, 0);
  }

  /// Returns a [DateTime] with the date of the original, but time set to
  /// midnight.
  DateTime get dateOnly => DateTime(this.year, this.month, this.day);

  /// Returns only the time.
  Time get timeOnly => Time(
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );

  /// Returns date formatted string with support for custom format
  String format([String? format]) {
    return DateFormat.format(this, format ?? 'yyyy-MM-dd HH:mm:ss');
  }

  /// Return date formatted string
  String get formatted => this.format();

  /// Check if the date is today
  bool get isToday {
    final nowDate = DateTime.now();
    return year == nowDate.year && month == nowDate.month && day == nowDate.day;
  }

  /// Check if the date is yesterday, consider gap of year, month, day
  bool get isYesterday {
    final nowDate = DateTime.now();
    final yesterdayDate = nowDate.subtract(Duration(days: 1));
    return year == yesterdayDate.year &&
        month == yesterdayDate.month &&
        day == yesterdayDate.day;
  }

  /// Check if the date is tomorrow
  bool get isTomorrow {
    final nowDate = DateTime.now();
    final tomorrowDate = nowDate.add(Duration(days: 1));
    return year == tomorrowDate.year &&
        month == tomorrowDate.month &&
        day == tomorrowDate.day;
  }

  /// Add a certain amount of days to this date
  DateTime addDays(int amount) => DateTime(
        year,
        month,
        day + amount,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );

  /// Add a certain amount of hours to this date
  DateTime addHours(int amount) => DateTime(
        year,
        month,
        day,
        hour + amount,
        minute,
        second,
        millisecond,
        microsecond,
      );

  /// Add a certain amount of minutes to this date
  DateTime addMinutes(int amount) => add(Duration(minutes: amount));

  /// Add a certain amount of seconds to this date
  DateTime addSeconds(int amount) => add(Duration(seconds: amount));

  /// Add a certain amount of months to this date and clamp overflow days.
  DateTime addMonths(int amount) {
    final totalMonths = year * 12 + month - 1 + amount;
    final targetYear = totalMonths ~/ 12;
    final targetMonth = totalMonths % 12 + 1;
    final maxDay = DateTime(targetYear, targetMonth + 1, 0).day;

    return _copyDateTime(
      this,
      year: targetYear,
      month: targetMonth,
      day: day > maxDay ? maxDay : day,
    );
  }

  /// Add a certain amount of years to this date and clamp overflow days.
  DateTime addYears(int amount) => addMonths(amount * 12);

  /// The day after this [DateTime]
  DateTime get nextDay => addDays(1);

  /// The day previous this [DateTime]
  DateTime get previousDay => addDays(-1);

  /// Whether or not two times are on the same day.
  bool isSameDay(DateTime b) =>
      year == b.year && month == b.month && day == b.day;

  /// Whether or not two dates are in the same month.
  bool isSameMonth(DateTime b) => year == b.year && month == b.month;

  /// Whether or not two dates are in the same year.
  bool isSameYear(DateTime b) => year == b.year;

  /// Returns true when this date is Saturday or Sunday.
  bool get isWeekend =>
      weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Returns true when this date is Monday through Friday.
  bool get isWeekday => !isWeekend;

  /// The list of days in a given month
  List<DateTime> get daysInMonth {
    var first = firstDayOfMonth;
    var daysBefore = first.weekday;
    var firstToDisplay = first.subtract(Duration(days: daysBefore));
    var last = lastDayOfMonth;

    var daysAfter = 7 - last.weekday;

    // If the last day is sunday (7) the entire week must be rendered
    if (daysAfter == 0) {
      daysAfter = 7;
    }

    var lastToDisplay = last.add(Duration(days: daysAfter));
    return Utils.daysInRange(firstToDisplay, lastToDisplay).toList();
  }

  /// Check if the first day of a month
  bool get isFirstDayOfMonth => isSameDay(firstDayOfMonth);

  /// Check if the last day of a month
  bool get isLastDayOfMonth => isSameDay(lastDayOfMonth);

  /// Returns the first day of a given month
  DateTime get firstDayOfMonth => DateTime(this.year, this.month);

  /// Returns the start of the current month.
  DateTime get startOfMonth => firstDayOfMonth.startOfDay;

  /// Returns the end of the current month.
  DateTime get endOfMonth => lastDayOfMonth.endOfDay;

  /// Returns the first day of the current year.
  DateTime get firstDayOfYear => DateTime(year);

  /// Returns the last day of the current year.
  DateTime get lastDayOfYear => DateTime(year, 12, 31);

  /// Returns the start of the current year.
  DateTime get startOfYear => firstDayOfYear.startOfDay;

  /// Returns the end of the current year.
  DateTime get endOfYear => lastDayOfYear.endOfDay;

  /// Returns the first day of week
  DateTime get firstDayOfWeek {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    final day = DateTime.utc(this.year, this.month, this.day, 12);

    /// Weekday is on a 1-7 scale Monday - Sunday,
    /// This Calendar works from Sunday - Monday
    var decreaseNum = day.weekday % 7;
    return this.subtract(Duration(days: decreaseNum));
  }

  /// Returns the last day of week
  DateTime get lastDayOfWeek {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    final day = DateTime.utc(this.year, this.month, this.day, 12);

    /// Weekday is on a 1-7 scale Monday - Sunday,
    /// This Calendar's Week starts on Sunday
    var increaseNum = day.weekday % 7;
    return day.add(Duration(days: 7 - increaseNum));
  }

  /// The last day of a given month
  DateTime get lastDayOfMonth {
    var beginningNextMonth = (this.month < 12)
        ? DateTime(this.year, this.month + 1, 1)
        : DateTime(this.year + 1, 1, 1);
    return beginningNextMonth.subtract(Duration(days: 1));
  }

  /// Returns the previous month
  DateTime get previousMonth {
    var year = this.year;
    var month = this.month;
    if (month == 1) {
      year--;
      month = 12;
    } else {
      month--;
    }
    return DateTime(year, month);
  }

  /// Returns the next month
  DateTime get nextMonth {
    var year = this.year;
    var month = this.month;

    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }
    return DateTime(year, month);
  }

  /// Returns the last week
  DateTime get previousWeek => this.subtract(Duration(days: 7));

  /// Returns the next week
  DateTime get nextWeek => this.add(Duration(days: 7));

  /// Check if the date is on the same week for a given date
  bool isSameWeek(DateTime b) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    final a = DateTime.utc(year, month, day);
    b = DateTime.utc(b.year, b.month, b.day);

    final diff = a.toUtc().difference(b.toUtc()).inDays;
    if (diff.abs() >= 7) {
      return false;
    }

    final min = a.isBefore(b) ? a : b;
    final max = a.isBefore(b) ? b : a;
    final result = max.weekday % 7 - min.weekday % 7 >= 0;
    return result;
  }

  /// Returns the whole day difference from this date to [other].
  int daysUntil(DateTime other) => other.dateOnly.difference(dateOnly).inDays;

  /// Returns true if this date is between [start] and [end].
  bool isBetween(
    DateTime start,
    DateTime end, {
    bool includeStart = true,
    bool includeEnd = true,
  }) {
    if (start.isAfter(end)) {
      throw ArgumentError.value(start, 'start', 'must be before end');
    }

    final afterStart = includeStart ? !isBefore(start) : isAfter(start);
    final beforeEnd = includeEnd ? !isAfter(end) : isBefore(end);
    return afterStart && beforeEnd;
  }
}
