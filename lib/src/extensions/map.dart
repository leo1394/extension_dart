/// Utilities for formatting Map.
extension MapExtension<T> on Map<String, T>? {
  /// Destructure ALL keys into a new Map (handles null)
  Map<String, T> destructure() =>
      this == null ? <String, T>{} : Map<String, T>.from(this!);
}

/// Null-safe convenience methods for nullable maps.
extension NullableMapExtension<K, V> on Map<K, V>? {
  /// Returns true if this map is null or empty.
  bool get isEmpty => this == null || this!.isEmpty;

  /// Returns true if this map has at least one entry.
  bool get isNotEmpty => this != null && this!.isNotEmpty;

  /// Returns this map, or an empty map when it is null.
  Map<K, V> get orEmpty => this == null ? <K, V>{} : Map<K, V>.from(this!);
}

/// Convenience methods for selecting and filtering map entries.
extension MapTransformExtension<K, V> on Map<K, V> {
  /// Returns a copy containing only [keys].
  Map<K, V> pick(Iterable<K> keys) {
    final result = <K, V>{};
    for (final key in keys) {
      if (containsKey(key)) {
        result[key] = this[key] as V;
      }
    }
    return result;
  }

  /// Returns a copy excluding [keys].
  Map<K, V> omit(Iterable<K> keys) {
    final excluded = keys.toSet();
    return Map<K, V>.fromEntries(
      entries.where((entry) => !excluded.contains(entry.key)),
    );
  }

  /// Returns a copy without null values.
  Map<K, V> withoutNullValues() {
    return Map<K, V>.fromEntries(
      entries.where((entry) => entry.value != null),
    );
  }

  /// Returns a copy with entries that satisfy [test].
  Map<K, V> whereEntries(bool Function(K key, V value) test) {
    return Map<K, V>.fromEntries(
      entries.where((entry) => test(entry.key, entry.value)),
    );
  }
}

/// Converts map values into a form suitable for URI query parameters.
extension QueryParametersConversion on Map<String, dynamic> {
  /// Returns a query parameter map with scalar and iterable values as strings.
  Map<String, dynamic> get asQueryParameters {
    return map((key, value) {
      if (value == null) {
        return MapEntry(key, null);
      } else if (value is Iterable) {
        return MapEntry(key, value.map((e) => e.toString()).toList());
      } else {
        return MapEntry(key, value.toString());
      }
    });
  }
}
