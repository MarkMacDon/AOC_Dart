import '../utils.dart';

var lines = getLines(dayNumber: 6);
void main() {
  List<int> times = getNumsListFromString(lines[0]);
  List<int> distances = getNumsListFromString(lines[1]);

  int productOfWaysToWin = times
      .asMap()
      .entries
      .map((e) => getNumWaysToWin(times[e.key], distances[e.key]))
      .toList()
      .reduce((value, element) => value * element);
  print('Part 1 Answer: $productOfWaysToWin');

  int bigTime = int.parse(times.join(''));
  int bigDistance = int.parse(distances.join(''));
  int totalWaysToWin = getNumWaysToWin(bigTime, bigDistance);
  print('Part 2 Answer: $totalWaysToWin');
}

int getNumWaysToWin(int time, int distance) {
  int numWays = 0;
  for (int i = 1; i < time; i++) {
    if (i * (time - i) > distance) {
      numWays++;
    }
  }
  return numWays;
}
