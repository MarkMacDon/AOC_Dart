import '../utils.dart';

var lines = getLines(dayNumber: 3);

main() {
  int sum = 0;
  for (int j = 0; j < lines.length; j++) {
    RegExp regExp = RegExp(r'\d+');
    Iterable<Match> matches = regExp.allMatches(lines[j]);

    // Start Index, Number
    Map<int, int> numbers = matches.fold<Map<int, int>>({}, (prev, element) {
      prev[element.start] = int.parse(element.group(0)!);
      return prev;
    });

    String? aboveLine = j > 0 ? lines[j - 1] : null;
    String? belowLine = j < lines.length - 1 ? lines[j + 1] : null;

    for (int index in numbers.keys) {
      List<int> indexesForNumber = [];

      for (int i = 0; i < numbers[index]!.toString().length; i++) {
        indexesForNumber.add(index + i);
      }
      if (indexesForNumber.last < lines[j].length - 1) {
        indexesForNumber.add(indexesForNumber.last + 1);
      }
      if (indexesForNumber.first > 0) {
        indexesForNumber.insert(0, indexesForNumber.first - 1);
      }
      if (check(indexesForNumber, aboveLine, belowLine, lines[j])) {
        sum += numbers[index]!;
      }
    }
  }
  print('Part 1 Answer: $sum');

  /// Part 2
  int sum2 = 0;
  for (int j = 0; j < lines.length; j++) {
    String? aboveLine = j > 0 ? lines[j - 1] : null;
    String? belowLine = j < lines.length - 1 ? lines[j + 1] : null;

    String sameLine = lines[j];
    RegExp regExp = RegExp(r'\*');
    Iterable<Match> gearMatches = regExp.allMatches(sameLine);
    for (Match gear in gearMatches) {
      int? start = gear.start > 0 ? gear.start - 1 : null;
      int gearIdx = gear.start;
      int? end = gear.end < sameLine.length - 1 ? gear.end : null;
      List<int?> checks = [start, gearIdx, end];

      /// check above
      List<int> aboveIndexes = [];
      List<int> belowIndexes = [];
      List<int> sameIndexes = [];
      for (int? checkIdx in checks) {
        if (checkIdx == null) {
          continue;
        }
        if (int.tryParse(aboveLine![checkIdx]) != null) {
          aboveIndexes.add(checkIdx);
        }

        if (int.tryParse(belowLine![checkIdx]) != null) {
          belowIndexes.add(checkIdx);
        }
        if (int.tryParse(sameLine[checkIdx]) != null) {
          sameIndexes.add(checkIdx);
        }
      }
      if (aboveIndexes.length > 1) {
        if (aboveIndexes[1] == aboveIndexes[0] + 1) {
          aboveIndexes = [aboveIndexes[0]];
        }
      }
      if (belowIndexes.length > 1) {
        if (belowIndexes[1] == belowIndexes[0] + 1) {
          belowIndexes = [belowIndexes[0]];
        }
      }

      RegExp numRegex = RegExp(r'\d+');
      List<int> gearRatios = [];
      if (aboveIndexes.isNotEmpty) {
        Iterable<Match> numMatches = numRegex.allMatches(lines[j - 1]);
        for (var index in aboveIndexes) {
          for (var match in numMatches) {
            if (match.start <= index && match.end > index) {
              gearRatios.add(int.parse(match.group(0)!));
            }
          }
        }
      }
      if (belowIndexes.isNotEmpty) {
        Iterable<Match> numMatches = numRegex.allMatches(lines[j + 1]);
        for (var index in belowIndexes) {
          for (var match in numMatches) {
            if (match.start <= index && match.end > index) {
              gearRatios.add(int.parse(match.group(0)!));
            }
          }
        }
      }
      if (sameIndexes.isNotEmpty) {
        Iterable<Match> numMatches = numRegex.allMatches(lines[j]);
        for (var index in sameIndexes) {
          for (var match in numMatches) {
            if (match.start <= index && match.end > index) {
              gearRatios.add(int.parse(match.group(0)!));
            }
          }
        }
      }
      if (gearRatios.length > 1) {
        sum2 += gearRatios.reduce((a, b) => a * b);
      }
    }
  }
  print('Part 2 Answer: $sum2');
}

bool check(
    List<int> indexes, String? aboveLine, String? belowLine, String sameLine) {
  // get num digits in int
  for (int index in indexes) {
    if (aboveLine != null &&
        aboveLine[index] != '.' &&
        int.tryParse(aboveLine[index]) == null) {
      return true;
    }
    if (belowLine != null &&
        belowLine[index] != '.' &&
        int.tryParse(belowLine[index]) == null) {
      return true;
    }
  }

  if (sameLine[indexes.first] != '.' &&
      int.tryParse(sameLine[indexes.first]) == null) {
    return true;
  }
  if (sameLine[indexes.last] != '.' &&
      int.tryParse(sameLine[indexes.last]) == null) {
    return true;
  }

  return false;
}
