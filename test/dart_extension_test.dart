import 'package:extension_dart/extensions.dart';
import 'package:extension_dart/utils.dart';
import 'package:test/test.dart';

void main() {
  test('seconds timer', () {
    expect((90).timer(), '01:30');
  });

  group('string extensions', () {
    test('blank and formatting helpers', () {
      const String? nullable = null;

      expect(nullable.orEmpty, '');
      expect('  '.isBlank, isTrue);
      expect(' hello world '.trimmed, 'hello world');
      expect('hello world'.capitalize(), 'Hello world');
      expect('hello world'.capitalize(allWords: true), 'Hello World');
      expect('Hello World'.containsIgnoreCase('world'), isTrue);
      expect(' a b\tc\n'.removeWhitespace(), 'abc');
      expect('Tel: 123-456'.onlyDigits(), '123456');
      expect('abcdef'.limit(4), 'a...');
      expect('13800138000'.mask(start: 3, end: 7), '138****8000');
    });
  });

  group('date extensions', () {
    test('month arithmetic clamps overflow days', () {
      final date = DateTime(2024, 1, 31, 10, 20);

      expect(date.addMonths(1), DateTime(2024, 2, 29, 10, 20));
      expect(date.addMonths(-1), DateTime(2023, 12, 31, 10, 20));
      expect(date.addYears(1), DateTime(2025, 1, 31, 10, 20));
      expect(date.isSameMonth(DateTime(2024, 1, 1)), isTrue);
      expect(date.daysUntil(DateTime(2024, 2, 2)), 2);
    });
  });

  group('iterable and list extensions', () {
    test('collection helpers', () {
      final numbers = [3, 1, 2, 2];

      expect(numbers.findIndex((e) => e == 9), -1);
      expect(numbers.firstOrNull, 3);
      expect(<int>[].firstOrNull, isNull);
      expect(numbers.elementAtOrNull(10), isNull);
      expect(numbers.count((e) => e == 2), 2);
      expect(numbers.groupBy((e) => e.isEven), {
        false: [3, 1],
        true: [2, 2],
      });
      expect(numbers.sortedBy((e) => e), [1, 2, 2, 3]);
      expect(['a', 'b', 'c'].separatedBy('|'), ['a', '|', 'b', '|', 'c']);
    });
  });

  group('map and utils helpers', () {
    test('map transforms and utility helpers', () async {
      expect({'a': 1, 'b': 2}.pick(['a', 'c']), {'a': 1});
      expect({'a': 1, 'b': 2}.omit(['b']), {'a': 1});
      expect({'a': 1, 'b': null}.withoutNullValues(), {'a': 1});

      final original = [1, 2];
      expect(Utils.unique(original, [2, 3]), [1, 2, 3]);
      expect(original, [1, 2]);
      expect(Utils.tryJsonDecode('{"ok":true}'), {'ok': true});
      expect(
          Utils.deepEquals({
            'a': [1, 2]
          }, {
            'a': [1, 2]
          }),
          isTrue);
      expect(
        Utils.deepMerge({
          'a': {'b': 1}
        }, {
          'a': {'c': 2}
        }),
        {
          'a': {'b': 1, 'c': 2}
        },
      );

      var attempts = 0;
      final result = await Utils.retry(() async {
        attempts++;
        if (attempts < 2) throw StateError('try again');
        return 'ok';
      });

      expect(result, 'ok');
      expect(attempts, 2);
    });
  });
}
