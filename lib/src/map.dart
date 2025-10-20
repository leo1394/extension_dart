
extension MapExtension<T> on Map<String, T>? {
  /// Destructure ALL keys into a new Map (handles null)
  Map<String, T> destructure() =>
      this == null ? <String, T>{} : Map<String, T>.from(this!);
}
