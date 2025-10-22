import 'dart:convert';

import 'date.dart';
import 'time.dart';

final RegExp _emailRegex = RegExp(
    r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
final RegExp _percentageRegex = RegExp(r'^[+-]?[0-9]*\.?[0-9]+%$');

extension StringExtension on String {
  /// Returns true if string contains email
  bool get isEmail => _emailRegex.hasMatch(this.toLowerCase());

  /// Returns true if string match strong password requirements
  bool get isStrongPassword {
    final requirements = [
      RegExp(r'.{8,}'), // 8+ chars
      RegExp(r'(?=.*[a-z])'), // lowercase
      RegExp(r'(?=.*[A-Z])'), // uppercase
      RegExp(r'(?=.*\d)'), // digit
      RegExp(r'(?=.*[@$!%*?&])') // special
    ];
    return requirements.every((regex) => regex.hasMatch(this));
  }

  /// Returns true if string is a valid JSON string
  bool get isJson {
    try {
      jsonDecode(this);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validates URL query string (handles ? & # fragments, allows empty values)
  bool get isQuery {
    // Extract query part: "?key=value&test=123"
    final queryMatch = RegExp(r'\?([^#]*)').firstMatch(this);
    if (queryMatch == null) return false;

    final query = queryMatch.group(1)!;
    if (query.isEmpty) return false;

    // Split & validate: key MUST exist, value CAN be empty
    return query.split('&').every((pair) {
      final parts = pair.split('=');
      return parts.length == 2 && parts[0].isNotEmpty; // ← Empty value OK!
    });
  }

  /// Returns true if string is a file
  bool isValidFileExtension(String filename, {List<String>? allowed}) {
    final extensions = allowed ?? ['.jpg', '.jpeg', '.png', '.pdf', '.docx'];
    final ext = filename.toLowerCase().split('.').last;
    return extensions.any((e) => '.$ext' == e.toLowerCase());
  }

  ///

  /// Returns true if string is a valid credit card number
  bool get isCreditCard {
    final clean = this.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.length < 13 || clean.length > 19) return false;

    // Luhn algorithm
    int sum = 0;
    bool even = false;
    for (int i = clean.length - 1; i >= 0; i--) {
      int digit = int.parse(clean[i]);
      if (even) digit *= 2;
      if (digit > 9) digit -= 9;
      sum += digit;
      even = !even;
    }
    return sum % 10 == 0;
  }

  /// Returns double 0.564 from string percentage like "56.4%"
  /// Parse [source] as a double literal and return its value.
  double? digits() {
    if (_percentageRegex.hasMatch(this)) {
      return double.parse(this.substring(0, this.length - 1)) / 100;
    }
    return double.tryParse(this);
  }

  /// Returns true if string is a time
  bool get isTime => Time.tryParse(this) != null;

  /// Returns Time if string is a time string like "12:00:00"
  Time? get time => Time.tryParse(this);

  /// Returns Time if string is a time string like "12:00:00"
  Time? get timeOnly => DateTime.tryParse(this)?.timeOnly;

  /// Returns true if string is a date
  bool get isDate => DateTime.tryParse(this) != null;

  /// Returns DateTime if string is a date string like "2025-01-01 12:00:00"
  DateTime? get date => DateTime.tryParse(this);

  /// Returns DateTime if string is a date string like "2025-01-01"
  DateTime? get dateOnly => DateTime.tryParse(this)?.dateOnly;

  /// Converts a string from snake_case or kebab-case to camelCase.
  ///
  /// Example:
  /// ```dart
  /// 'hello_world'.toCamelCase( ) ;  // 'helloWorld'
  /// 'hello world'.toCamelCase( ) ;  // 'helloWorld'
  /// 'user_profile_data'. toCamelCase( ) ;  // 'userProfileData'
  /// 'HelloWorld'.toCamelCase( ) ;  // 'helloWorld'
  /// ```
  String toCamelCase() {
    return this
        .split(RegExp(r'[_\s]'))
        .map((word) => word.isEmpty
            ? ''
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join()
        .replaceFirstMapped(
            RegExp(r'^[A-Z]'), (match) => match.group(0)!.toLowerCase());
  }

  /// Converts a string from camelCase to snake_case.
  ///
  /// Example:
  /// ```dart
  /// 'helloWorld'.toSnakeCase( ) ;  // 'hello_world'
  /// 'userProfileData'.toSnakeCase( ) ;  // 'user_profile_data'
  /// 'HelloWorld'.toSnakeCase( ) ;  // 'hello_world'
  /// ```
  String toSnakeCase({String separator = '_'}) {
    return this
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAllMapped(
            RegExp(r'[A-Z]'), (match) => '_' + match.group(0)!.toLowerCase())
        .replaceAll(RegExp(r'^_'), '')
        .replaceAll(RegExp(r'_+'), '_');
  }

  /// Splits the string into a list of chunks of a specified size.
  ///
  /// The last chunk may be smaller than [chunkSize] if the string's length
  /// is not evenly divisible by [chunkSize].
  ///
  /// Example:
  /// ```dart
  /// 'HelloWorld'.chunks( 3) ;  // ['Hel', 'loW', 'orl', 'd']
  /// '12345'.chunks(2); // ['12', '34', '5']
  /// ```
  List<String> chunks(int chunkSize) {
    final chunks = <String>[];
    final len = this.length;
    for (int i = 0; i < len; i += chunkSize) {
      final size = i + chunkSize;
      chunks.add(this.substring(i, size > len ? len : size));
    }
    return chunks;
  }

  /// Splits the string's UTF-16 code units (bytes) into a list of chunks.
  ///
  /// This is useful for processing byte data in smaller segments.
  /// The last chunk may be smaller than [chunkSize].
  ///
  /// Example:
  /// ```dart
  /// 'Hello'.bytesChunks(2) ;  // [[72, 101], [108, 108], [111]]
  /// ```
  List<List<int>> bytesChunks(int chunkSize) {
    final chunks = <List<int>>[];
    final bytes = this.bytes();
    final len = bytes.length;
    for (int i = 0; i < len; i += chunkSize) {
      final size = i + chunkSize;
      chunks.add(bytes.sublist(i, size > len ? len : size));
    }
    return chunks;
  }

  /// Calculates the byte count of a string, treating non-ASCII characters as 2 bytes.
  ///
  /// This is often used for validation where systems have byte-based length limits
  /// (e.g., some database varchar fields).
  ///
  /// Example:
  /// ```dart /// 'hello'.bytesCount() ;  // 5
  /// '你好'.bytesCount(); // 4
  /// 'hello你好'.bytesCount( ) ;  // 9
  /// ```
  int bytesCount() {
    return this.replaceAll(RegExp(r"[^\u0000-\u00ff]"), "aa").length;
  }

  /// Returns a list of the UTF-16 code units of the string.
  ///
  /// This is a convenient alias for `string.codeUnits`.
  List<int> bytes() => this.codeUnits;

  /// Returns string with capitalized first letter
  ///
  /// Example:
  /// ```dart
  /// assert('test'.capitalizeFirstLetter(), 'Test');
  /// ```
  String capitalize() =>
      this.isNotEmpty ? '${this[0].toUpperCase()}${this.substring(1)}' : this;
}
