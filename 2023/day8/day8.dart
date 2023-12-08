import '../utils.dart';

var lines = getLines(dayNumber: 8);

// Part 1 Done in 25:57
// Part 2 Done in 4:32:00

void main(List<String> args) async {
  String directions = lines[0];
  Map<String, Map<String, String>> nodeMap = {'L': {}, 'R': {}};
  for (int i = 2; i < lines.length; i++) {
    var directions = getWordsListFromString(lines[i]);
    nodeMap['L']![directions[0]] = directions[1];
    nodeMap['R']![directions[0]] = directions[2];
  }

  //* Part 1
  String loc = 'AAA';
  int count = 0;
  while (loc != 'ZZZ') {
    loc = nodeMap[directions[count % directions.length]]![loc]!;
    count++;
  }
  print('Part 1 Answer: $count');

  //* Part 2
  List<String> locations = nodeMap['L']!.keys.toList();
  List<int> allLoops = [];
  for (String location in locations) {
    var loopLength = getZLoops(location, nodeMap, directions);
    allLoops.add(loopLength);
  }

  int ans = findLCMForList(allLoops);
  print('Part 2 Answer: $ans');
}

int getZLoops(String location, Map nodeMap, String directions) {
  bool isEndFound = false;
  int count = 0;
  List<int> zLoops = [];
  while (!isEndFound) {
    int directionIndex = count % directions.length;
    String direction = directions[directionIndex];
    location = nodeMap[direction]![location]!;
    if (location[2] == 'Z') zLoops.add(count);
    if (zLoops.length >= 3) isEndFound = true;
    count++;
  }
  return zLoops[2] - zLoops[1];
}

int findLCMForList(List<int> numbers) {
  if (numbers.isEmpty) {
    throw ArgumentError("Input list must not be empty");
  }

  int lcm = numbers.first;

  for (int i = 1; i < numbers.length; i++) {
    lcm = _calculateLCM(lcm, numbers[i]);
  }

  return lcm;
}

int _calculateLCM(int a, int b) {
  // Calculate the Greatest Common Divisor (GCD)
  int gcd = _calculateGCD(a, b);

  // Use the formula: LCM(a, b) = (a * b) / GCD(a, b)
  int lcm = (a * b) ~/ gcd;

  return lcm;
}

int _calculateGCD(int a, int b) {
  while (b != 0) {
    int remainder = a % b;
    a = b;
    b = remainder;
  }
  return a;
}
