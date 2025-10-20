import 'package:dart_extension/extensions.dart';
import 'package:dart_extension/src/utils.dart';

void main() {
  /* Double */
  double value = 3.1415926;
  print(value.fixed(decimals: 3)); // 3.141
  print(value.fixed(decimals: 3, round: true)); // 3.142

  /* Num */
  print((4783484).thousands()); // '4,783,484'
  print((125).timer()); // '02:05'

  print((0.5).percentage(fit: true)); // '50%' (instead of '50.00%')
  print((0.501).percentage()); // '50.10%'

  /* String */

  print("3.1415926".digits()); // 3.1415926

  print("4.56%".digits()); // 0.456

  print("-1.e3".digits()); // -1000.0

  print("hello world".toCamelCase()); // helloWorld
  print("Hello World".toSnakeCase()); // hello_world

  '12345'.chunks(2); // ['12', '34', '5']

  /// Other extension methods
  "qwerty".chunks(3); // ["qwe", "rty];
  "Hello".bytes(); // [72, 101, 108, 108, 111]
  "qwerty你好".bytesCount; // 10
  "Hello".bytesChunks(2); // [[72, 101], [108, 108], [111]]
  "hello".capitalize(); // return Hello
  "{}".isJson; // true
  "test@gmail.com".isEmail; // true
  "xxxxxxxx".isCreditCard; // false
  "dZ9GK_ee83".isStrongPassword; // true

  /* Map */

  Map<String, dynamic> headers = {};
  final {"requestId": requestId, "silent": silent} = headers.destructure();

  /* Iterate or List */

  final numbers = <int>[1, 2, 3, 5, 6, 7];
  var result = numbers.find((element) => element < 5); // 1
  result = numbers.find((element) => element > 5); // 6
  result = numbers.find((element) => element > 10); // null
  result = numbers.find((element) => element > 10, orElse: () => -1); // -1
  /// other api `findIndex` return index of target element, return -1 otherwise

  var numbersArr = [
    [
      1,
      2,
      [7, 8]
    ],
    [3, 5]
  ];
  print(numbersArr.flat()); // (1, 2, [7, 8], 3, 5)
  print(numbersArr.flat(depth: 2)); // (1, 2, 7, 8, 3, 5)

  ['a', 'aa', 'aaa'].sum((s) => s.length); // 6
  [1, 2, 3, 4].sum(); // 10

  /// Other similar methods
  [1, 2, 3, 4].max(); // 4
  [1, 2, 3, 4].min(); // 1
  [1, 2, 3, 4].average(); // 2.5
  [1, 2, 3, 4].chunks(3); // [[1, 2, 3], [4]]

  /* DateTime */
  DateTime now = DateTime.now();

  print(now.isToday); // true
  print(now.timeOnly.toString()); // 11:56:23.647266
  print(now.addDays(1).dateOnly); // 2025/10/21

  /* Time */

  final time = const Time(15, 30);
  print(time.toString()); // 15:30:00.000000

  /* Utils */

  print(Utils.fastUUID()); // 8c3acae0-fd12-4061-b714-119095c6ddda
  print(Utils.pickup({
    "kk": {"pp": 3}
  }, "pp")); // [3]
  print(Utils.isEmpty([])); // true
}
