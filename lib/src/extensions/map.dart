/// Utilities for formatting Map.
extension MapExtension<T> on Map<String, T>? {
  /// Destructure ALL keys into a new Map (handles null)
  Map<String, T> destructure() =>
      this == null ? <String, T>{} : Map<String, T>.from(this!);
}

extension QueryParametersConversion on Map<String, dynamic> {
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
