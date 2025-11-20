import 'time.dart';
import 'dart:math' as math;

/// Utilities for formatting numbers.
extension NumExtension<T extends num> on T {
  /// Transforms `this` into a `String` and pads it on the left if it is shorter
  /// than the given [width].
  String padLeft(int width, [String padding = '0']) =>
      toString().padLeft(width, padding);

  /// Transforms `this` into a `String` and pads it on the right if it is shorter
  /// than the given [width].
  String padRight(int width, [String padding = '0']) =>
      toString().padRight(width, padding);

  /// Returns `true` if `this` is between the given [min] (inclusive) and [max] (exclusive).
  bool between(num min, num max) {
    assert(min <= max,
        'Invalid bounds: $min and $max, min cannot be greater than max');
    return min <= this && this < max;
  }

  /// Returns `true` if this number is outside the given range of [min] (exclusive) and
  /// [max] (exclusive).
  bool outside(num min, num max) {
    assert(min <= max,
        'Invalid bounds: $min and $max, min cannot be greater than max');
    return this < min || this > max;
  }

  /// Convert milliseconds to DateTime
  DateTime get millisecondsToDateTime =>
      DateTime.fromMillisecondsSinceEpoch(this.toInt());

  /// Convert milliseconds to UTCDateTime
  DateTime get millisecondsToUTCDateTime =>
      DateTime.fromMillisecondsSinceEpoch(this.toInt(), isUtc: true);

  /// Convert degrees to radians
  double get radians => this * math.pi / 180.0;

  /// Convert radians to degree
  double get degrees => this * 180.0 / math.pi;

  /// Convert celsius to fahrenheit
  double get fahrenheit => (this * 9 / 5) + 32.0;

  /// Convert fahrenheit to celsius
  double get celsius => (this - 32.0) * 5 / 9;

  /// Convert miles to kilometers
  double get kilometers => this * 1.60934;

  /// Convert kilometers to miles
  double get miles => this / 1.60934;

  /// Convert grams to carats
  double get carats => this * 5.0;

  /// Convert grams to ounces
  double get ounces => this / 28.34952;

  /// From Carats to grams
  double get caratsToGrams => this / 5.0;

  /// From Ounces to grams
  double get ouncesToGrams => this * 28.34952;

  /// Converts a number representing total seconds into a time-formatted string.
  ///
  /// The number is treated as the total number of seconds.
  /// Supports 'mm:SS' and 'HH:mm:SS' formats.
  ///
  /// [format]: The desired output format. Defaults to 'mm:SS'.
  ///
  /// ---
  /// ### Code of Practice:
  ///
  /// **1. Default format (mm:SS):**
  /// ```dart
  /// int totalSeconds = 125;
  /// String formattedTime = totalSeconds.timer() ;  // '02:05'
  /// ```
  String timer({String format = 'mm:SS'}) {
    final seconds = this.toInt();
    int hrs = (seconds ~/ 3600);
    int mins = ((seconds % 3600) ~/ 60);
    int secs = (seconds % 60);

    if (format == 'HH:mm:SS') {
      return new Time(hrs, mins, secs).toString();
    }
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// Formats a number with thousands separators (commas).
  ///
  /// Handles both integers and doubles.
  ///
  /// ---
  /// ### Code of Practice:
  ///
  /// **1. Formatting an integer:**
  /// ```dart
  /// int largeNumber = 1234567;
  /// String formatted = largeNumber.thousands( ) ;  // '1,234,567'
  /// ```
  ///
  /// **2. Formatting a double:**
  /// ```dart
  /// double largeDouble = 1234567.89;
  /// String formatted = largeDouble.thousands(); // '1,234,567.89'
  /// ```
  ///
  String thousands() {
    try {
      if (!RegExp(r'^[+-]?([\d]+|[\d]+\.[\d]+)$').hasMatch(this.toString())) {
        return this.toString();
      }
      return this
          .toString()
          .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
    } catch (e) {
      return this.toString();
    }
  }

  /// Fix fraction digits for num
  num fixed([int fractionDigits = 6]) {
    String formatted = this.toStringAsFixed(fractionDigits);
    formatted = formatted.replaceAll(RegExp(r'\.[0]+$'), '');
    return num.tryParse(formatted) ?? this;
  }

  /// Converts a number into a percentage string.
  ///
  /// The number is multiplied by 100 and a '%' sign is appended.
  ///
  /// [fixed]: The number of decimal places to show. Defaults to 2.
  /// [fit]: If true, removes trailing '.00' from the result. Defaults to false.
  ///
  /// ---
  /// ### Code of Practice:
  ///
  /// 1. Default behavior:
  /// ```dart
  /// double value = 0.8567;
  /// String percent = value.percentage(); // '85.67%'
  /// ```
  ///
  /// 2. Specifying decimal places:
  /// ```dart
  /// double value = 0.8567;
  /// String percent = value.percentage(fixed:  1); // '85.7%'
  /// ```
  ///
  ///
  /// **3. Using 'fit' to remove unnecessary decimals:**
  /// ```dart
  /// double value = 0.5;
  /// String percent = value.percentage(fit: true); // '50%' (instead of '50.00%')
  /// ```
  ///
  /// double anotherValue = 0.501;
  /// String anotherPercent = anotherValue.percentage(fit: true); // '50.10%'
  /// ```
  ///
  String percentage({int fixed = 2, bool fit = false}) {
    String formatted = (this * 100).toStringAsFixed(fixed);
    if (fit) {
      formatted = formatted.replaceAll(RegExp(r'\.[0]+$'), '');
    }

    return '$formatted%';
  }

  /// Converts a number into a per mille string.
  /// The number is multiplied by 1000 and a '‰' sign is appended.
  String permille({int fixed = 2, bool fit = false}) {
    String formatted = (this * 1000).toStringAsFixed(fixed);
    if (fit) {
      formatted = formatted.replaceAll(RegExp(r'\.[0]+$'), '');
    }

    return '$formatted‰';
  }

  /// Converts a number into a per myriad string.
  /// The number is multiplied by 10000 and a '‱' sign is appended.
  String permyriad({int fixed = 2, bool fit = false}) {
    String formatted = (this * 10000).toStringAsFixed(fixed);
    if (fit) {
      formatted = formatted.replaceAll(RegExp(r'\.[0]+$'), '');
    }

    return '$formatted‱';
  }
}
