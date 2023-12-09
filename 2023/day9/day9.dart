import '../utils.dart';

var lines = getLines(dayNumber: 9);

main() {
  // Part 1
  List<int> allRowEnds = [];
  for (var line in lines) {
    var row = getNumsListFromStringKeepingNegatives(line);
    var nextRow = row;
    var rowEnds = [row.last];
    while (!nextRow.every((element) => element == 0)) {
      nextRow = getNextRow(nextRow);
      rowEnds.add(nextRow.last);
    }
    allRowEnds.add(rowEnds.reduce((value, element) => value + element));
  }

  var ans = allRowEnds.reduce((value, element) => element + value);
  print('Part 1 Answer: $ans');

  // Part 2
  List<int> allRowStarts = [];
  for (var line in lines) {
    var row = getNumsListFromStringKeepingNegatives(line);
    var nextRow = row;
    var rowStarts = [row.first];
    while (!nextRow.every((element) => element == 0)) {
      nextRow = getNextRow(nextRow);
      rowStarts.add(nextRow.first);
    }
    int rowStartTotal = rowStarts.reversed
        .fold(0, (previousValue, element) => element - previousValue);
    allRowStarts.add(rowStartTotal);
  }

  var ans2 = allRowStarts.reduce((value, element) => element + value);
  print('Part 2 Answer: $ans2');
}

List<int> getNextRow(List<int> row) {
  List<int> nextRow = [];
  for (var i = 0; i < row.length - 1; i++) {
    nextRow.add(row[i + 1] - row[i]);
  }
  return nextRow;
}
