import '../utils.dart';

main() {
  var lines = getLines(dayNumber: 2);
  int sum = 0;
  int sum2 = 0;
  const Map<String, int> colors = {
    'green': 0,
    'red': 0,
    'blue': 0,
  };
  for (String line in lines) {
    List<String> segments = line.split(':');
    int gameID = int.parse(segments.first.split('').sublist(5).join(''));
    List<String> pulls = segments.last.split(';');

    if (isGamePossible(pulls, colors)) {
      sum += gameID;
    }

    var colorCounts = getColorCounts(pulls, colors);
    int power = colorCounts.reduce((value, element) => value * element);
    sum2 += power;
  }
  print('Part 1 Answer: $sum');
  print('Part 2 Answer: $sum2');
}

bool isGamePossible(List<String> pulls, Map<String, int> colors) {
  for (var pull in pulls) {
    var newColors = colors.map((key, value) => MapEntry(key, 0));
    List<String> balls = pull.split(', ');

    for (var ball in balls) {
      String color = ball.split(' ').last;
      int number = getNumsListFromString(ball).first;
      newColors[color] = newColors[color]! + number;
    }
    if (newColors['red']! > 12 ||
        newColors['green']! > 13 ||
        newColors['blue']! > 14) {
      return false;
    }
  }
  return true;
}

List<int> getColorCounts(List<String> pulls, Map<String, int> colors) {
  var newColors = colors.map((key, value) => MapEntry(key, 0));
  for (var pull in pulls) {
    List<String> balls = pull.split(', ');
    for (var ball in balls) {
      String color = ball.split(' ').last;
      int number = getNumsListFromString(ball).first;
      if (number > newColors[color]!) {
        newColors[color] = number;
      }
    }
  }
  return newColors.values.toList();
}
