import 'dart:io';
import 'package:path/path.dart' as path;

main() {
  String? getFirstDigit(String line) {
    for (int i = 0; i < line.length; i++) {
      int? number = int.tryParse(line[i]);
      if (number != null) {
        return line[i];
      }
    }
    return null;
  }

  String? getLastDigit(String line) {
    for (int i = line.length - 1; i >= 0; i--) {
      int? number = int.tryParse(line[i]);
      if (number != null) {
        return line[i];
      }
    }
    return null;
  }

  //Part 1
  var filePath = path.join(Directory.current.path, 'day1/day1_data.txt');
  File file = File(filePath);
  var lines = file.readAsLinesSync();
  int sum = 0;
  for (String line in lines) {
    String firstDigit = getFirstDigit(line) ?? '';
    String lastDigit = getLastDigit(line) ?? '';
    int value = int.parse(firstDigit + lastDigit);
    sum += value;
  }
  print(sum);

  //Part 2
  filePath = path.join(Directory.current.path, 'day1/day1_data_part2.txt');
  lines = file.readAsLinesSync();
  sum = 0;
  const Map<String, String> words = {
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9',
    '1': '1',
    '2': '2',
    '3': '3',
    '4': '4',
    '5': '5',
    '6': '6',
    '7': '7',
    '8': '8',
    '9': '9',
  };
  int getNum(String line) {
    (String, int) first = ('', line.length);
    (String, int) last = ('', 0);
    for (var key in words.keys) {
      if (line.contains(key)) {
        int firstIdx = line.indexOf(key);
        int lastIdx = line.lastIndexOf(key);
        if (first.$1.isEmpty || first.$2 > firstIdx) {
          first = (key, firstIdx);
        }
        if (last.$1.isEmpty || last.$2 < lastIdx) {
          last = (key, lastIdx);
        }
      }
    }

    String firstDigit = words[first.$1]!;
    String secondDigit = words[last.$1]!;

    return int.parse(firstDigit + secondDigit);
  }

  for (String line in lines) {
    sum += getNum(line);
  }
  print(sum);
}
