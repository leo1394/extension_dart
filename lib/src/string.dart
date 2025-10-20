final RegExp _emailRegex = RegExp(r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
final RegExp _percentageRegex = RegExp(r'^[+-]?[0-9]*\.?[0-9]+%$');

extension StringExtension on String {
  /// Returns true if string contains email
  bool get isEmail => _emailRegex.hasMatch(this.toLowerCase());

  /// Returns double 0.564 from string percentage like "56.4%"
  /// Parse [source] as a double literal and return its value.
  double? digits() {
    if(_percentageRegex.hasMatch(this)) {
      return double.parse(this.substring(0, this.length - 1)) / 100;
    }
    return double.tryParse(this);
  }
  /// Converts a string from snake_case or kebab-case to camelCase.
  ///
  /// Example:
  /// ```dart
  /// 'hello_world'.toCamelCase( ) ;  // 'helloWorld'
  /// 'user_profile_data'. toCamelCase( ) ;  // 'userProfileData'
  /// 'HelloWorld'.toCamelCase( ) ;  // 'helloWorld'
  /// ```
  String toCamelCase() {
    return this.split('_').map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join()
        .replaceFirstMapped(RegExp(r'^[A-Z]'), (match) => match.group(0)!.toLowerCase());
  }

  /// Converts a string from camelCase to snake_case.
  ///
  /// Example:
  /// ```dart
  /// 'helloWorld'.toSnakeCase( ) ;  // 'hello_world'
  /// 'userProfileData'.toSnakeCase( ) ;  // 'user_profile_data'
  /// 'HelloWorld'.toSnakeCase( ) ;  // 'hello_world'
  /// ```
  String toSnakeCase() {
    return this.replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_' + match.group(0)!.toLowerCase())
        .replaceAll(RegExp(r'^_'), '');
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
  int bytesCount(){
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
  String capitalizeFirstLetter() => this.isNotEmpty ? '${this[0].toUpperCase()}${this.substring(1)}' : this;
}