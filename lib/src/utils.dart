import 'dart:math';
import 'date.dart';

class Utils {
  /// Generate fast uuid with supports for prefix and with dashes or not
  static String fastUUID({String prefix = "", bool withDashes = true}) {
    final chars = '0123456789abcdef';
    final uuid = List.generate(32, (i) => chars[Random().nextInt(16)]).join();
    final formatted = withDashes
        ? '${uuid.substring(0, 8)}-${uuid.substring(8, 12)}-${uuid.substring(12, 16)}-${uuid.substring(16, 20)}-${uuid.substring(20)}'
        : uuid;
    return prefix.isNotEmpty ? '$prefix-$formatted' : formatted;
  }

  /// is null or empty for Map String, List
  static bool isEmpty(dynamic obj) {
    if (obj is String || obj is Map || obj is List) {
      return obj == null || obj.isEmpty;
    }
    return true;
  }

  /// unique for int, String, double List
  static List<T> unique<T>(List<T>? q1, [List<T>? q2]) {
    if (isEmpty(q1) && isEmpty(q2)) {
      return <T>[];
    }
    List<T> arr = q1 ?? [];
    arr.addAll(q2 ?? []);
    if (T != int &&
        T != String &&
        T != double &&
        arr.first is int &&
        arr.first is String &&
        arr.first is double) {
      return arr;
    }
    return Set<T>.from(arr).toList();
  }

  /// pickup target attributes for Map, List
  static List<T> pickup<T>(dynamic target, String keywordsStr) {
    if (isEmpty(keywordsStr) ||
        isEmpty(target) ||
        (target is! Map && target is! List)) {
      return List.empty();
    }
    List<String> keywords = keywordsStr.split("-");
    List<T> cherries = [];
    if (target is List && target.isNotEmpty) {
      for (var element in target) {
        List<T> tmp = pickup(element, keywordsStr);
        cherries.addAll(tmp);
      }
      return unique(cherries);
    }
    target.keys.forEach((element) {
      dynamic value = target[element];
      if (keywords.contains(element)) {
        cherries.add(value);
      }
      if (value is Map) {
        List<T> tmp = pickup(
            value.map((key, value) => MapEntry(key.toString(), value)),
            keywordsStr);
        cherries.addAll(tmp);
      }
      if (value is List) {
        List<T> tmp = pickup(value, keywordsStr);
        cherries.addAll(tmp);
      }
    });
    return unique<T>(cherries);
  }

  /// Compare two lists for equality.
  static bool areListsEqual(List<dynamic> list1, List<dynamic> list2) {
    // Check reference equality (optimization)
    if (identical(list1, list2)) {
      return true;
    }

    // Check nulls and length
    if (list1.length != list2.length) {
      return false;
    }

    // Compare each element
    for (int i = 0; i < list1.length; i++) {
      final item1 = list1[i];
      final item2 = list2[i];

      // Handle different types
      if (item1 is List && item2 is List) {
        if (!areListsEqual(item1, item2)) return false;
      } else if (item1 is Map && item2 is Map) {
        if (!areMapsEqual(item1, item2)) return false;
      } else if (item1 != item2) {
        // Direct comparison for primitives (int, String, bool, etc.)
        return false;
      }
    }
    return true;
  }

  /// Compare two maps for equality.
  static bool areMapsEqual(
      Map<dynamic, dynamic> map1, Map<dynamic, dynamic> map2) {
    if (identical(map1, map2)) return true;
    if (map1.length != map2.length) {
      return false;
    }

    for (final key in map1.keys) {
      if (!map2.containsKey(key)) return false;
      final value1 = map1[key];
      final value2 = map2[key];
      if (value1 is List && value2 is List) {
        if (!areListsEqual(value1, value2)) return false;
      } else if (value1 is Map && value2 is Map) {
        if (!areMapsEqual(value1, value2)) return false;
      } else if (value1 != value2) {
        return false;
      }
    }
    return true;
  }

  /// Tomorrow at same hour / minute / second than now
  static DateTime get tomorrow => DateTime.now().nextDay;

  /// Yesterday at same hour / minute / second than now
  static DateTime get yesterday => DateTime.now().previousDay;

  /// Current date (Same as [Date.now])
  static DateTime get today => DateTime.now();

  /// Returns a [DateTime] for each day the given range.
  ///
  /// [start] inclusive
  /// [end] exclusive
  static Iterable<DateTime> daysInRange(DateTime start, DateTime end) sync* {
    var i = start;
    var offset = start.timeZoneOffset;
    while (i.isBefore(end)) {
      yield i;
      i = i.addDays(1);
      var timeZoneDiff = i.timeZoneOffset - offset;
      if (timeZoneDiff.inSeconds != 0) {
        offset = i.timeZoneOffset;
        i = i.subtract(Duration(seconds: timeZoneDiff.inSeconds));
      }
    }
  }
}
