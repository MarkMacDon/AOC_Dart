import 'dart:io';

import 'package:path/path.dart' as path;

List<String> getLines({required int dayNumber}) {
  /// assumes data.txt is in the same directory as day$dayNumber.dart
  var dataPath = path.join(Directory.current.path, 'day$dayNumber/data.txt');
  File file = File(dataPath);
  return file.readAsLinesSync();
}

List<int> getNumsListFromString(String string) {
  return RegExp(r'\d+')
      .allMatches(string)
      .map<int>((e) => int.parse(e.group(0)!))
      .toList();
}

List<int> getNumsListFromStringKeepingNegatives(String string) {
  return RegExp(r'-?\d+')
      .allMatches(string)
      .map<int>((e) => int.parse(e.group(0)!))
      .toList();
}

List<String> getWordsListFromString(String string) {
  return RegExp(r'\w+')
      .allMatches(string)
      .map<String>((e) => e.group(0)!)
      .toList();
}
