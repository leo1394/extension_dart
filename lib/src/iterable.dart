import 'string.dart';

num Function(dynamic) identity =
    (dynamic e) => e is num ? e : (e.toString().digits() ?? 0);

extension IterableFindExtension<E> on Iterable<E> {
  /// find the first element that satisfies the given predicate [test].
  ///
  /// Iterates through elements and returns the first to satisfy [test].
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// var result = numbers.firstWhere((element) => element < 5); // 1
  /// result = numbers.find((element) => element > 5); // 6
  /// result = numbers.find((element) => element > 10); // null
  /// result =
  ///     numbers.find((element) => element > 10, orElse: () => -1); // -1
  /// ```
  ///
  /// If no element satisfies [test], the result of invoking the [orElse]
  /// function is returned.
  /// If [orElse] is omitted, it defaults to return a null.
  /// Stops iterating on the first matching element.
  E? find(bool Function(E element) test, {E Function()? orElse}) {
    for (E element in this) {
      if (test(element)) return element;
    }
    if (orElse != null) return orElse();
    return null;
  }

  /// find the first element index that satisfies the given predicate [test].
  ///
  /// Iterates through elements and returns the first element index to satisfy [test].
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// int result = numbers.findIndex((element) => element < 5); // 0
  /// int result = numbers.findIndex((element) => element > 5); // 4
  /// int result = numbers.findIndex((element) => element > 10); // -1
  /// ```
  ///
  /// Stops iterating on the first matching element.
  int findIndex(bool Function(E element) test) {
    int index = -1;
    for (E element in this) {
      index++;
      if (test(element)) return index;
    }
    return 0;
  }

  /// Flats each element of this [Iterable] into zero or more elements.
  ///
  /// The resulting Iterable runs through the elements returned
  /// by [toElements] for each element of this, in iteration order.
  ///
  /// The returned [Iterable] is lazy, and calls [toElements] for each element
  /// of this iterable every time the returned iterable is iterated.
  ///
  /// Example:
  /// ```dart
  ///
  /// var numbers = [[1,2, [7,8]], [3,5]];
  /// print(numbers.flat()); // (1, 2, [7, 8], 3, 5)
  /// print(numbers.flat(depth: 2)); // (1, 2, 7, 8, 3, 5)
  /// ```
  Iterable<E> flat<E>(
      {int? depth, dynamic Function(dynamic e)? toElements}) sync* {
    toElements ??= (dynamic e) => e;
    depth ??= 1;
    for (var element in this) {
      if (depth > 0) {
        final extracted = toElements(element);
        if (extracted is! Iterable) {
          yield extracted;
          continue;
        }
        // Use dynamic to handle recursive call type flexibly
        yield* extracted.flat<E>(depth: depth - 1, toElements: toElements);
      } else {
        yield* [toElements(element)];
      }
    }
  }

  /// Returns the sum of all the values in this iterable, as defined by
  /// [addend].
  ///
  /// Returns 0 if [this] is empty.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'aa', 'aaa'].sum((s) => s.length); // 6
  /// ```
  num sum([num Function(dynamic)? addend]) {
    addend ??= identity;
    return this.isEmpty
        ? 0
        : this.fold(0, (prev, element) => prev + addend!(element));
  }

  /// Returns the average of all the values in this iterable, as defined by
  /// [value].
  ///
  /// Returns null if [this] is empty.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'aa', 'aaa'].average((s) => s.length); // 2
  /// [].average(); // null
  /// ```
  num? average({num Function(dynamic)? value}) {
    value ??= identity;
    if (this.isEmpty) return null;

    return this.sum(value) / this.length;
  }

  /// Returns the element with the maximum value in the iterable.
  ///
  /// An optional [value] function can be provided to define what is compared.
  /// If omitted, the element itself is used for comparison.
  ///
  /// ** Finding the longest string:**
  /// ```dart
  /// final strings = ['a', 'cccc', 'bb'];
  /// final result = strings.max(value: (s) => s.length); // 'cccc'
  /// ```
  ///
  E max({num Function(dynamic)? value}) {
    value ??= identity;
    E maxElement = this.first;
    num maxValue = value(maxElement);

    for (var element in skip(1)) {
      num current = value(element);
      if (current > maxValue) maxElement = element;
    }

    return maxElement;
  }

  /// Returns the element with the minimum value in the iterable.
  ///
  /// An optional [value] function can be provided to define what is compared.
  /// If omitted, the element itself is used for comparison.
  ///
  /// ** Finding the min of string:**
  /// ```dart
  /// final strings = ['a', 'cccc', 'bb'];
  /// final result = strings.min(value: (s) => s.length); // 'a'
  /// ```
  ///
  E min({num Function(dynamic)? value}) {
    value ??= identity;
    E minElement = this.first;
    num minValue = value(minElement);

    for (var element in skip(1)) {
      num current = value(element);
      if (current < minValue) minElement = element;
    }

    return minElement;
  }

  /// Split one large list to limited sub lists
  /// ```dart
  /// [1, 2, 3, 4, 5, 6, 7, 8, 9].chunks(2)
  /// // => [[1, 2], [3, 4], [5, 6], [7, 8], [9]]
  /// ```
  Iterable<List<E>> chunks(int chunkSize) sync* {
    final len = this.length;

    for (int i = 0; i < len; i += chunkSize) {
      final start = i > len ? i - len : i;
      yield skip(start).take(chunkSize).toList();
    }
  }
}
