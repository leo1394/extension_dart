
## extension_dart
[![pub package](https://img.shields.io/pub/v/extension_dart.svg)](https://pub.dev/packages/extension_dart)
[![pub points](https://img.shields.io/pub/points/extension_dart?color=2E8B57&label=pub%20points)](https://pub.dev/packages/extension_dart/score)
[![GitHub Issues](https://img.shields.io/github/issues/leo1394/extension_dart.svg?branch=master)](https://github.com/leo1394/extension_dart/issues)
[![GitHub Forks](https://img.shields.io/github/forks/leo1394/extension_dart.svg?branch=master)](https://github.com/leo1394/extension_dart/network)
[![GitHub Stars](https://img.shields.io/github/stars/leo1394/extension_dart.svg?branch=master)](https://github.com/leo1394/extension_dart/stargazers)
[![GitHub License](https://img.shields.io/badge/license-MIT%20-blue.svg)](https://raw.githubusercontent.com/leo1394/extension_dart/master/LICENSE)

A lightweight Dart extensions that simplify framework usage for elegant, effortless app development.

Language: English | [中文](README-ZH.md)
## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: |:---:| :---: | :-----: |
|   ✅    | ✅  |  ✅   |  ✅  |  ✅   |   ✅    |

## Requirements

- Flutter >=3.0.0 <4.0.0
- Dart: ^2.17.0
- meta: ^1.8.0

## Getting started
Import
```dart
import 'package:extension_dart/extensions.dart';
import 'package:extension_dart/utils.dart';
``` 

### Double

```dart
  double value = 3.1415926;
  print(value.fixed(decimals: 3)); // 3.141
  print(value.fixed(decimals: 3, round: true)); // 3.142

```

### Num
```dart
  print((4783484).thousands()); // '4,783,484'
  int totalSeconds = 125;
  print(totalSeconds.timer()); // '02:05'

  double value = 0.5;
  String percent = value.percentage(fit: true); // '50%' (instead of '50.00%')

  double anotherValue = 0.501;
  print(anotherValue.percentage()); // '50.10%'
  print(anotherValue.permille()); // '50.10‰'
  print(anotherValue.permyriad()); // '50.10‱'

    /// Other units conversion methods
    /// (90).radians
    /// (90).degrees
    /// (90).fahrenheit
    /// (90).celsius
    /// (90).kilometers
    /// (90).miles
    /// (90).carats
    /// (90).ounces
    /// (90).caratsToGrams
    /// (90).ouncesToGrams

```

### String?

```dart
  print("3.1415926".numeric()); // 3.1415926
  print("4.56%".numeric()); // 0.456
  print("4.56‰".numeric()); // 0.0456
  print("4.56‱".numeric()); // 0.00456
  print("-1.e3".numeric()); // -1000.0

  print("hello world".toCamelCase()); // helloWorld
  print("HelloWorld".toSnakeCase()); // hello_world

  '12345'.chunks(2); // ['12', '34', '5']

  /// Other extension methods
  /// "qwerty".chunks(3); // ["qwe", "rty];
  /// 'Hello'.bytes() ;  // [72, 101, 108, 108, 111]
  /// "qwerty你好".bytesCount; // 10
  /// 'Hello'.bytesChunks(2) ;  // [[72, 101], [108, 108], [111]]
  /// "hello".capitalize(); // return Hello
  /// "{}".isJson 
  /// "?id=&search=".isQuery 
  /// "test@gmail.com".isEmail 
  /// "xxxxxxxx".isCreditCard 
  /// "dk9KK_ee83".isStrongPassword 
  /// "王伟".isChineseFullName; // true
  /// "CP2756344".isDEANumberOfUS; // true
  /// "XXX-XX-XXXX".isSSNofUS; // false
  /// "+1 (234) 567-8901".isPhoneNumberOfUS; // true 

```

### Map

```dart
  Map<String, dynamic> headers = {};
  final {"requestId": requestId, "silent": silent} = headers.destructure();

  // use for Uri.https or http
  final Map<String, dynamic> query = {
  'name': 'John',
  'age': 30,
  'tags': ['dart', 'flutter'],  // List or Set
  'active': true,
  'filter': null,               // optional param
  };

  final Map<String, dynamic> queryParameters = query.asQueryParameters;

```

### Iterable

```dart
  final numbers = <int>[1, 2, 3, 5, 6, 7];
  var result = numbers.find((element) => element < 5); // 1
  result = numbers.find((element) => element > 5); // 6
  result = numbers.find((element) => element > 10); // null
  result = numbers.find((element) => element > 10, orElse: () => -1); // -1
  /// other api `findIndex` return index of target element, return -1 otherwise

  var numbers = [[1,2, [7,8]], [3,5]];
  print(numbers.flat()); // (1, 2, [7, 8], 3, 5)
  print(numbers.flat(depth: 2)); // (1, 2, 7, 8, 3, 5)

  ['a', 'aa', 'aaa'].sum((s) => s.length); // 6
  [1, 2, 3, 4].sum(); // 10
  
  /// Other similar methods
  [1, 2, 3, 4].max();  // 4
  [1, 2, 3, 4].min();  // 1
  [1, 2, 3, 4].average(); // 2.5
  [1, 2, 3, 4].chunks(3); // [[1, 2, 3], [4]]
```

### List<Future>
```dart
  final futures = [
    http.get(Uri.parse('https://httpbin.org/delay/2')),
    Future.delayed(Duration(seconds: 1), () => 999),
    Future.delayed(Duration(seconds: 3), () => "Last one"),
    Future.value("Instant"),
    Future.error("Boom!"),
    Future.value(CustomObject(name: "Test")),
  ];

final results = await futures.all(
    delayMillis: 200, // optional stagger
    onProgress: (done, total, current) {
      print("Progress: $done/$total");
    },
    onAnySuccess: (value, index) {
      print("Success [$index]: $value (${value.runtimeType})");
    },
    onAnyError: (error, stack, index) {
      print("Failed [$index]: $error");
    },
);
// results is List<dynamic> in exact original order
print(results);
// → [Response, 999, "Last one", "Instant", null, Instance of 'CustomObject']
```

### Date

```dart
  DateTime now = DateTime.now();

  print(now.isToday); // true
  print(now.timeOnly.toString()); // 11:56:23.647266
  print(now.addDays(1).dateOnly); // 2025/10/21
  print(now.formatted); // 2025-10-21
```

#### Time

```dart
final time = Time(15, 30);
print(time.toString()); // 15:30:00.000000

```

#### Utils

```dart
  print(Utils.isEmpty([])); // true
  print(Utils.fastUUID()); // 8c3acae0-fd12-4061-b714-119095c6ddda
  print(Utils.unique([3,7,8,9], [1,2,3,9])); // [3,7,8,9,1,2]
  print(Utils.pickup({"kk": {"pp": 3}}), "pp"); // [3]
  /// Other similar methods
  /// Utils.areListsEqual(list1, list2);
  /// Utils.areMapsEqual(map1, map2)
```


## Additional information
Feel free to file an issue if you have any problem.
