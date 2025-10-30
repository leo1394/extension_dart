import 'dart:convert';

import 'date.dart';
import 'time.dart';

final RegExp _emailRegex = RegExp(
    r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
final RegExp _percentageRegex = RegExp(r'^[+-]?[0-9]*\.?[0-9]+%$');
final RegExp _urlRegex = RegExp(r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$');
final RegExp _ipv4Regex = RegExp(
    r'^((25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)\.){3}(25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)$');
final RegExp _ipv6Regex = RegExp(
    r'^(([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|(([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])))$');

extension StringExtension on String? {
  /// Returns true if string is a valid email address
  bool get isEmail => this != null && _emailRegex.hasMatch(this!.toLowerCase());

  /// Returns true if string is a valid url
  bool get isUrl => this != null && _urlRegex.hasMatch(this!);

  /// Returns true if string match strong password requirements
  bool get isStrongPassword {
    final requirements = [
      RegExp(r'.{8,}'), // 8+ chars
      RegExp(r'(?=.*[a-z])'), // lowercase
      RegExp(r'(?=.*[A-Z])'), // uppercase
      RegExp(r'(?=.*\d)'), // digit
      RegExp(r'(?=.*[@$!%*?&])') // special
    ];
    return this != null && requirements.every((regex) => regex.hasMatch(this!));
  }

  /// Returns true if string is null or empty
  bool get isEmpty => this == null || this!.length == 0;

  /// Returns true if string is not empty
  bool get isNotEmpty => this != null && this!.length > 0;

  /// Validates URL query string (handles ? & # fragments, allows empty values)
  bool get isQuery {
    if (this == null) {
      return false;
    }
    // Extract query part: "?key=value&test=123"
    final queryMatch = RegExp(r'\?([^#]*)').firstMatch(this!);
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
  bool isValidFileExtension([List<String>? allowed]) {
    if (this == null) {
      return false;
    }
    final extensions =
        allowed ?? ['.jpg', '.jpeg', '.png', '.pdf', '.docx', '.txt', '.json'];
    final ext = this!.toLowerCase().split('.').last;
    return extensions.any((e) => '.$ext' == e.toLowerCase());
  }

  /// Returns true if string is a valid credit card number
  bool get isCreditCard {
    if (this == null) {
      return false;
    }
    final clean = this!.replaceAll(RegExp(r'[^0-9]'), '');
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

  /// Returns `true` if [id] is a valid Chinese resident ID number.
  bool get isChineseIdNumber {
    if (this == null) {
      return false;
    }
    // 1. Basic format
    if (this!.length != 18) return false;
    final digits = this!.split('');
    if (digits.sublist(0, 17).any((c) => !RegExp(r'[0-9]').hasMatch(c))) {
      return false;
    }

    // 2. Birthday (positions 7-14: YYYYMMDD)
    final year = int.parse(this!.substring(6, 10));
    final month = int.parse(this!.substring(10, 12));
    final day = int.parse(this!.substring(12, 14));

    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 31) return false;

    // Validate real date (including leap year)
    final DateTime? birthDate;
    try {
      birthDate = DateTime(year, month, day);
    } on ArgumentError {
      return false;
    }
    if (birthDate.year != year ||
        birthDate.month != month ||
        birthDate.day != day) {
      return false;
    }

    // 3. Check digit (ISO 7064, MOD 11-2)
    const weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
    const checkMap = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'];

    var sum = 0;
    for (var i = 0; i < 17; i++) {
      sum += int.parse(digits[i]) * weights[i];
    }
    final expectedCheck = checkMap[sum % 11];
    final actualCheck = digits[17].toUpperCase();

    return expectedCheck == actualCheck;
  }

  /// Returns `true` if [name] is a valid Chinese full name.
  ///
  /// Rules:
  /// - Length: 2 to 12 characters (common: 2–4)
  /// - All characters must be valid Chinese characters (Unicode CJK range)
  /// - Optional: allows '·' (U+00B7) for ethnic minority names like "买买提·艾买提"
  bool get isChineseFullName {
    if (this.isEmpty) return false;

    final trimmed = this!.trim();
    if (trimmed.length < 2 || trimmed.length > 12) return false;

    // Must consist only of CJK chars + optional single middle dot
    final allowed = RegExp(r'^[\u4E00-\u9FFF·]+$');
    if (!allowed.hasMatch(trimmed)) return false;

    // Prevent all identical characters
    if (trimmed.runes.toSet().length == 1) return false;

    // Count dots
    final dotCount = '·'.allMatches(trimmed).length;
    if (dotCount > 1) return false; // only one dot allowed

    if (dotCount == 0) {
      return trimmed.length <= 4; // no dot && length → valid
    }

    // --- Dot is present: must be in the middle ---
    final dotIndex = trimmed.indexOf('·');

    // Not at start or end
    if (dotIndex == 0 || dotIndex == trimmed.length - 1) return false;

    // Must have at least one CJK char on each side
    final left = trimmed.substring(0, dotIndex);
    final right = trimmed.substring(dotIndex + 1);
    if (left.isEmpty || right.isEmpty) return false;

    // Both sides must contain only Chinese characters (no extra dots, already checked)
    final cjkOnly = RegExp(r'^[\u4E00-\u9FFF]+$');
    if (!cjkOnly.hasMatch(left) || !cjkOnly.hasMatch(right)) return false;

    return true;
  }

  /// Returns true if string is a valid US Society Security Number
  bool get isSSNofUS {
    if (this == null) {
      return false;
    }
    final ssnPattern =
        RegExp(r'^(?!666|000|9\d{2})\d{3}-(?!00)\d{2}-(?!0000)\d{4}$');
    return ssnPattern.hasMatch(this!);
  }

  /// Returns true if string is a valid US Phone Number
  bool get isPhoneNumberOfUS {
    if (this == null) {
      return false;
    }
    final pattern = RegExp(
        r'^(\+1\s?)?(\()?([2-9][0-9]{2})(\))?[-.\s]?([2-9][0-9]{2})[-.\s]?([0-9]{4})$');
    return pattern.hasMatch(this!);
  }

  /// Returns true if string is a valid US Drug Enforcement Agency
  bool get isDEANumberOfUS {
    if (this == null) {
      return false;
    }
    final pattern = RegExp(r'^[A-Z]{2}\d{7}$');
    if (!pattern.hasMatch(this!)) return false;

    // Extract digits
    final digits = this!.substring(2).split('').map(int.parse).toList();

    // Check digit calculation:
    // 1. Add digits 1, 3, 5
    int sum135 = digits[0] + digits[2] + digits[4];
    // 2. Add digits 2, 4, 6 and multiply by 2
    int sum246x2 = (digits[1] + digits[3] + digits[5]) * 2;
    // 3. Total and check if last digit matches
    int expectedCheck = ((sum135 + sum246x2) % 10);

    return digits[6] == expectedCheck;
  }

  /// Returns true if string is a valid number
  bool get isNumeric =>
      this != null && (num.tryParse(this!) != null || this.numeric() != null);

  /// Returns double 0.564 from string percentage like "56.4%"
  /// Parse [source] as a double literal and return its value.
  double? numeric() {
    if (this == null) {
      return null;
    }
    if (_percentageRegex.hasMatch(this!)) {
      return double.parse(this!.substring(0, this!.length - 1)) / 100;
    }
    return double.tryParse(this!);
  }

  /// Returns true if string is a valid JSON string
  bool get isJson {
    if (this == null) {
      return false;
    }
    try {
      jsonDecode(this!);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Returns true if string is a valid IPv4 address
  bool get isIPv4 => this != null && _ipv4Regex.hasMatch(this!);

  /// Returns true if string is a valid IPv6 address
  bool get isIPv6 => this != null && _ipv6Regex.hasMatch(this!);

  /// Returns true if string is a valid IPv4 or IPv6 address
  bool get isIPAddress => this.isIPv4 || this.isIPv6;

  /// Convert an IPv4 address to an IPv6 address,
  String? get ipv4Tov6 {
    if (!this.isIPAddress) {
      return null;
    }
    if (this.isIPv6) {
      return this;
    }
    return '::ffff:$this';
  }

  /// Convert an IPv6 address to an IPv4 address,
  String? get ipv6Tov4 {
    if (!this.isIPAddress) {
      return null;
    }
    if (this.isIPv4) {
      return this;
    }
    final regex = RegExp(r'^::ffff:(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$',
        caseSensitive: false);
    final match = regex.firstMatch(this!);
    if (match != null) {
      return match.group(1);
    }
    return null;
  }

  /// Returns JSON object if string is a valid JSON string
  dynamic json() {
    if (this == null) {
      return null;
    }
    try {
      return jsonDecode(this!);
    } catch (ignored) {
      return null;
    }
  }

  /// Returns true if string is a time
  bool get isTime => this != null && Time.tryParse(this!) != null;

  /// Returns Time if string is a time string like "12:00:00"
  Time? get time => this == null ? null : Time.tryParse(this!);

  /// Returns Time if string is a time string like "12:00:00"
  Time? get timeOnly =>
      this == null ? null : DateTime.tryParse(this!)?.timeOnly;

  /// Returns true if string is a date
  bool get isDate => this != null && DateTime.tryParse(this!) != null;

  /// Returns DateTime if string is a date string like "2025-01-01 12:00:00"
  DateTime? get date => this == null ? null : DateTime.tryParse(this!);

  /// Returns DateTime if string is a date string like "2025-01-01"
  DateTime? get dateOnly =>
      this == null ? null : DateTime.tryParse(this!)?.dateOnly;

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
    if (this == null) {
      return "";
    }
    return this!
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
    if (this == null) {
      return "";
    }
    return this!
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
    if (this == null) {
      return chunks;
    }
    final len = this!.length;
    for (int i = 0; i < len; i += chunkSize) {
      final size = i + chunkSize;
      chunks.add(this!.substring(i, size > len ? len : size));
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
    if (this == null) {
      return chunks;
    }
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
    return this == null
        ? 0
        : this!.replaceAll(RegExp(r"[^\u0000-\u00ff]"), "aa").length;
  }

  /// Returns a list of the UTF-16 code units of the string.
  ///
  /// This is a convenient alias for `string.codeUnits`.
  List<int> bytes() => this == null ? [] : this!.codeUnits;

  /// Returns string with capitalized first letter
  ///
  /// Example:
  /// ```dart
  /// assert('test'.capitalizeFirstLetter(), 'Test');
  /// ```
  String capitalize() => this != null && this!.isNotEmpty
      ? '${this![0].toUpperCase()}${this!.substring(1)}'
      : "";
}
