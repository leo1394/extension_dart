import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:extension_dart/extensions.dart';

/// General-purpose helpers shared by extension methods and package consumers.
class Utils {
  static final Random _random = Random();

  /// Generate fast uuid with supports for prefix and with dashes or not
  static String fastUUID({String prefix = "", bool withDashes = true}) {
    final chars = '0123456789abcdef';
    final uuid = List.generate(32, (i) => chars[_random.nextInt(16)]).join();
    final formatted = withDashes
        ? '${uuid.substring(0, 8)}-${uuid.substring(8, 12)}-${uuid.substring(12, 16)}-${uuid.substring(16, 20)}-${uuid.substring(20)}'
        : uuid;
    return prefix.isNotEmpty ? '$prefix-$formatted' : formatted;
  }

  /// is null or empty for Map, String, Iterable
  static bool isEmpty(dynamic value) {
    if (value == null) return true;

    if (value is String) return value.isEmpty;
    if (value is Iterable) return value.isEmpty;
    if (value is Map) return value.isEmpty;

    return false;
  }

  /// unique for int, String, double List
  static List<T> unique<T>(List<T>? q1, [List<T>? q2]) {
    if (isEmpty(q1) && isEmpty(q2)) {
      return <T>[];
    }
    final arr = <T>[...?q1, ...?q2];
    return Set<T>.from(arr).toList();
  }

  /// Generate a random string.
  static String randomString(
    int length, {
    String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
  }) {
    if (length < 0) {
      throw RangeError.value(length, 'length', 'must not be negative');
    }
    if (chars.isEmpty) {
      throw ArgumentError.value(chars, 'chars', 'must not be empty');
    }

    return List.generate(length, (_) => chars[_random.nextInt(chars.length)])
        .join();
  }

  /// Returns [value] when it can be JSON-decoded, otherwise null.
  static dynamic tryJsonDecode(String? value) {
    if (value == null) return null;
    try {
      return jsonDecode(value);
    } catch (_) {
      return null;
    }
  }

  /// Returns a JSON string, or null when [value] cannot be encoded.
  static String? tryJsonEncode(dynamic value) {
    try {
      return jsonEncode(value);
    } catch (_) {
      return null;
    }
  }

  /// Returns a query string built from [parameters].
  static String queryString(Map<String, dynamic> parameters) {
    return Uri(queryParameters: parameters.asQueryParameters).query;
  }

  /// Removes null values from maps and lists recursively.
  static dynamic removeNullValues(dynamic value) {
    if (value is Map) {
      final result = <dynamic, dynamic>{};
      value.forEach((key, item) {
        if (item != null) {
          result[key] = removeNullValues(item);
        }
      });
      return result;
    }

    if (value is List) {
      return value.where((item) => item != null).map(removeNullValues).toList();
    }

    return value;
  }

  /// Deep merges [source] into [target].
  static Map<K, dynamic> deepMerge<K>(
    Map<K, dynamic> target,
    Map<K, dynamic> source,
  ) {
    final result = Map<K, dynamic>.from(target);
    source.forEach((key, value) {
      final current = result[key];
      if (current is Map && value is Map) {
        result[key] = deepMerge<dynamic>(
          Map<dynamic, dynamic>.from(current),
          Map<dynamic, dynamic>.from(value),
        );
      } else {
        result[key] = value;
      }
    });

    return result;
  }

  /// Retries an async [action] until it succeeds or [retries] is exhausted.
  static Future<T> retry<T>(
    Future<T> Function() action, {
    int retries = 3,
    Duration delay = Duration.zero,
    bool Function(Object error)? retryIf,
  }) async {
    if (retries < 0) {
      throw RangeError.value(retries, 'retries', 'must not be negative');
    }

    var attempt = 0;
    while (true) {
      try {
        return await action();
      } catch (error) {
        final shouldRetry = attempt < retries && (retryIf?.call(error) ?? true);
        if (!shouldRetry) rethrow;
        attempt++;
        if (delay > Duration.zero) {
          await Future<void>.delayed(delay);
        }
      }
    }
  }

  /// Debounces repeated calls and runs only the latest action.
  static void Function() debounce(
    void Function() action, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(delay, action);
    };
  }

  /// Throttles repeated calls to at most once per [duration].
  static void Function() throttle(
    void Function() action, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    DateTime? lastRun;
    return () {
      final now = DateTime.now();
      if (lastRun == null || now.difference(lastRun!) >= duration) {
        lastRun = now;
        action();
      }
    };
  }

  /// Deep equality for lists, maps, and primitive values.
  static bool deepEquals(dynamic value1, dynamic value2) {
    if (identical(value1, value2)) return true;
    if (value1 is List && value2 is List) {
      return areListsEqual(value1, value2);
    }
    if (value1 is Map && value2 is Map) {
      return areMapsEqual(value1, value2);
    }
    return value1 == value2;
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

  /// Current date (same as `DateTime.now()`).
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

  /// Waits for all [futures] and returns results in the original order.
  ///
  /// Delegates to the iterable future extension and supports progress,
  /// success, error, and staggered start callbacks.
  static Future<List<dynamic>> futureAll(
    Iterable<Future> futures, {
    void Function(int, int, Map<int, dynamic>)? onProgress,
    void Function(dynamic, int)? onAnySuccess,
    void Function(Object, StackTrace, int)? onAnyError,
    int delayMillis = 0,
  }) {
    return futures.all(
        onProgress: onProgress,
        onAnySuccess: onAnySuccess,
        onAnyError: onAnyError,
        delayMillis: delayMillis);
  }

  /// Returns true if is yesterday, otherwise false
  static bool isYesterday(int current) =>
      current.millisecondsToDateTime.isYesterday;

  /// Returns true if is tomorrow, otherwise false
  static bool isTomorrow(DateTime date) => date.isTomorrow;

  /// Returns true if is today, otherwise false
  static bool isToday(DateTime date) => date.isToday;
}
