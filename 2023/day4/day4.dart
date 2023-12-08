import 'dart:math' as math;

import '../utils.dart';

var lines = getLines(dayNumber: 4);

main() {
  int sum = 0;
  for (String line in lines) {
    List<int> winningNumbers;
    List<int> myNumbers;
    (winningNumbers, myNumbers) = getWinningNumbersAndMyNumbers(line);

    int winCount = winningNumbers.fold(
      0,
      (prev, element) => myNumbers.contains(element) ? prev + 1 : prev,
    );

    winCount == 1 || winCount == 0
        ? sum += winCount
        : sum += math.pow(2, winCount - 1).toInt();
  }
  print('Part 1 Answer: $sum');

  // Part 2

  // <card, numCards>
  Map<int, int> cardCounts = {};
  for (int i = 0; i < lines.length; i++) {
    List<int> winningNumbers;
    List<int> myNumbers;
    (winningNumbers, myNumbers) = getWinningNumbersAndMyNumbers(lines[i]);

    int matches = winningNumbers.fold(
        0, (prev, element) => myNumbers.contains(element) ? prev + 1 : prev);

    final currentCardCount = (cardCounts[i + 1] ?? 0) + 1;
    for (int k = 0; k < currentCardCount; k++) {
      for (int j = 1; j <= matches; j++) {
        cardCounts[i + j + 1] = (cardCounts[i + j + 1] ?? 0) + 1;
      }
    }
  }
  int totalCards = cardCounts.values
          .fold<int>(0, (previousValue, element) => previousValue + element) +
      lines.length;
  print('Part 2 Answer: $totalCards');
}

(List<int>, List<int>) getWinningNumbersAndMyNumbers(String line) {
  final splitLine = line.split('|');
  final String myNumbersString = splitLine.last;
  final String winningNumbersString = splitLine[0].split(':').last;
  final myNumbers = getNumsListFromString(myNumbersString);
  final winningNumbers = getNumsListFromString(winningNumbersString);
  return (winningNumbers, myNumbers);
}
