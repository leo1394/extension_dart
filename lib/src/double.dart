import 'dart:math';
/// Utilities for formatting double.
extension DoubleExtension on double {
  /// Formats a double to a specific number of decimal places, with an option to round.
  ///
  /// Returns an `int` if [decimals] is 0, otherwise returns a `double`.
  ///
  /// [decimals]: The number of decimal places to keep. Defaults to 2.
  /// [round]: If true, the number is rounded to the specified number of decimal places.
  ///          If false (default), the number is truncated.
  ///
  /// ---
  /// ### Code of Practice:
  ///
  /// ```dart
  /// double value = 3.14159;
  /// // **1. Default behavior (2 decimal places, no rounding):**
  ///
  /// var result = value.fixed(); // 3.14
  /// // **2. Specifying a different number of decimals:**
  ///
  /// var result = value.fixed(decimals:  4); // 3.1415
  /// // **3. Rounding to a specific number of decimals:**
  ///
  /// var result = value.fixed(decimals:  2, round: true); // 3.15
  /// // Using fixed with decimals: 0 is like calling .toInt()
  /// // **4. Getting an integer result:**
  ///
  /// var result = value.fixed(decimals: 0); // 3
  ///
  /// ```
  dynamic fixed({int? decimals = 2, bool? round = false}) {
    if(decimals == null) {decimals = 2;}
    if(round == null) {round = false;}
    double result = this;
    if(round) {
      int factor = pow(10, decimals).toInt();
      result = (this * factor).round() / factor;
    }
    result = double.parse(this.toStringAsFixed(decimals));
    // Return int if decimals = 0, double otherwise
    return decimals == 0 ? result.toInt() : result;
  }
}