---
name: extension_dart
description: Use when coding with extension_dart: Dart extensions for numeric formatting, percentages, string parsing/case conversion, date/time helpers, collection helpers, future batching, map query parameters, and Utils helpers.
---

# extension_dart Agent Context

Use this package for lightweight Dart extension methods and utility helpers. Prefer it over hand-written formatting/parsing helpers when the app already depends on it.

## Imports

```dart
import 'package:extension_dart/extensions.dart';
import 'package:extension_dart/utils.dart';
import 'package:extension_dart/date_format.dart';
```

## Numeric Helpers

```dart
3.1415926.fixed(decimals: 3);              // "3.141"
3.1415926.fixed(decimals: 3, round: true); // "3.142"
(4783484).thousands();                     // "4,783,484"
(125).timer();                             // "02:05"
0.5.percentage(fit: true);                 // "50%"
0.501.percentage();                        // "50.10%"
0.501.permille();                          // "50.10‰"
```

Also exposes unit conversion getters such as `radians`, `degrees`, `fahrenheit`, `celsius`, `kilometers`, `miles`, `caratsToGrams`, and `ouncesToGrams`.

## String Helpers

```dart
"3.1415926".numeric();     // 3.1415926
"4.56%".numeric();         // 0.456
"hello world".toCamelCase();
"HelloWorld".toSnakeCase();
"12345".chunks(2);         // ["12", "34", "5"]
"Hello".bytes();
"qwerty你好".bytesCount;
"{}".isJson;
"?id=&search=".isQuery;
"test@gmail.com".isEmail;
```

## Collections and Futures

```dart
[1, 2, 3, 2].unique().toList();
[1, 2, 3, 4].sum();
["a", "aa"].sum((s) => s.length);
[[1, 2, [3]], 4].flat(depth: 2);
[1, 2, 3].find((e) => e > 1);
[1, 2, 3].findIndex((e) => e == 2);

final results = await futures.all(
  delayMillis: 200,
  onProgress: (done, total, current) {},
  onAnySuccess: (value, index) {},
  onAnyError: (error, stack, index) {},
);
```

## Dates, Maps, Utils

```dart
DateTime.now().isToday;
DateTime.now().dateOnly;
DateTime.now().addDays(1);
DateTime.now().formatted;

final queryParameters = {
  "tags": ["dart", "flutter"],
  "active": true,
  "filter": null,
}.asQueryParameters;

Utils.isEmpty([]);
Utils.fastUUID();
Utils.unique([3, 7], [7, 9]);
Utils.pickup({"kk": {"pp": 3}}, "pp");
```

## Notes for Agents

- Import `extensions.dart` for extension methods; import `utils.dart` only for `Utils`.
- Do not reimplement common formatting/parsing helpers when an extension exists.
- Be careful with `numeric()` semantics: `%`, `‰`, and `‱` are scaled to decimal values.
