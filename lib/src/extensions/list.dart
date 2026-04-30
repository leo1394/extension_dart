extension ListExtension<E> on List<E> {
  /// Split one large list to limited sub lists
  /// ```dart
  /// [1, 2, 3, 4, 5, 6, 7, 8, 9].chunks(2)
  /// // => [[1, 2], [3, 4], [5, 6], [7, 8], [9]]
  /// ```
  List<List<E>> chunks(int chunkSize) {
    final chunks = <List<E>>[];
    final len = this.length;
    for (int i = 0; i < len; i += chunkSize) {
      final size = i + chunkSize;
      chunks.add(this.sublist(i, size > len ? len : size));
    }
    return chunks;
  }

  /// Returns a new lazy [List] with unique elements from this collection.
  ///
  /// If [comparator] is provided, it uses the custom logic to determine
  /// if two elements are equal. If [comparator] is null, it falls back to
  /// the default equality operator (==).
  ///
  /// The [comparator] should return true if [a] and [b] are considered duplicates.
  List<E> unique([bool Function(E a, E b)? comparator]) {
    final List<E> result = [];

    for (final element in this) {
      if (comparator == null) {
        // Fallback to standard equality and hashCode check
        if (!result.contains(element)) {
          result.add(element);
        }
      } else {
        // Use custom comparison logic
        bool isDuplicate = false;
        for (final existing in result) {
          if (comparator(existing, element)) {
            isDuplicate = true;
            break;
          }
        }
        if (!isDuplicate) {
          result.add(element);
        }
      }
    }

    return result;
  }

  /// Returns a new [List] containing only the elements that have unique keys.
  ///
  /// The [keySelector] function extracts the key used for comparison.
  /// Only the first element encountered for each unique key is kept.
  ///
  /// Example:
  /// ```dart
  /// final users = [User(id: 1), User(id: 2), User(id: 1)];
  /// final unique = users.uniqueBy((u) => u.id); // Keeps first two users
  /// ```
  List<E> uniqueBy<K>(K Function(E element) keySelector) {
    final Set<K> seenKeys = <K>{};
    final List<E> result = <E>[];

    for (final element in this) {
      final K key = keySelector(element);
      if (seenKeys.add(key)) {
        result.add(element);
      }
    }

    return result;
  }
}
