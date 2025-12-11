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
}
