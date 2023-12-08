import 'dart:math';
import '../utils.dart';

final fiveOfAKind = 1e16.toInt();
final fourOfAKind = 1e15.toInt();
final fullHouse = 1e14.toInt();
final threeOfAKind = 1e13.toInt();
final twoPair = 1e12.toInt();
final onePair = 1e11.toInt();
final highCard = 1e10.toInt();

const cardsValueMapJacksWild = {
  'A': 14,
  'K': 13,
  'Q': 12,
  'J': 1,
  'T': 10,
  '9': 9,
  '8': 8,
  '7': 7,
  '6': 6,
  '5': 5,
  '4': 4,
  '3': 3,
  '2': 2,
};

const cardsValueMap = {
  'A': 15,
  'K': 14,
  'Q': 13,
  'J': 12,
  'T': 11,
  '9': 10,
  '8': 9,
  '7': 8,
  '6': 7,
  '5': 6,
  '4': 5,
  '3': 4,
  '2': 3,
};

main() {
  var lines = getLines(dayNumber: 7);
  Map<String, int> handBidMap = getHandBidMap(lines);

  var orderedHands = handBidMap.keys.toList()
    ..sort(
      (a, b) => getTotalValue(a).compareTo(
        getTotalValue(b),
      ),
    );

  var total = orderedHands
      .asMap()
      .entries
      .map((e) => (e.key + 1) * handBidMap[e.value]!)
      .reduce((value, element) => value + element);

  print('Part 1 Answer: $total');

  var jackOrderedHands = handBidMap.keys.toList()
    ..sort(
      (a, b) => getTotalValue(a, isJackWild: true).compareTo(
        getTotalValue(b, isJackWild: true),
      ),
    );

  total = jackOrderedHands
      .asMap()
      .entries
      .map((e) => (e.key + 1) * handBidMap[e.value]!)
      .reduce((value, element) => value + element);

  print('Part 2 Answer: $total');
}

Map<String, int> getHandBidMap(List<String> lines) {
  return lines.asMap().entries.fold<Map<String, int>>({}, (newMap, entry) {
    if (newMap.containsKey(entry.key)) {
      throw Exception('Duplicate hand: ${entry.key}');
    }
    var hand = entry.value.split(' ')[0];
    var bid = int.parse(entry.value.split(' ')[1]);
    newMap[hand] = bid;
    return newMap;
  });
}

int getTotalValue(String hand, {bool isJackWild = false}) {
  int baseValue = getHandBaseValue(hand, isJackWild: isJackWild);
  Map<String, int> handMap = hand.split('').fold({}, (newMap, card) {
    newMap.containsKey(card)
        ? newMap[card] = newMap[card]! + 1
        : newMap[card] = 1;
    return newMap;
  });

  if (isJackWild) handMap = makeJacksWild(handMap, baseValue);

  if (handMap.containsValue(5) || handMap.isEmpty) {
    baseValue += fiveOfAKind;
  } else if (handMap.containsValue(4)) {
    baseValue += fourOfAKind;
  } else if (handMap.containsValue(3) && handMap.containsValue(2)) {
    baseValue += fullHouse;
  } else if (handMap.containsValue(3)) {
    baseValue += threeOfAKind;
  } else if (handMap.containsValue(2) && handMap.length == 3) {
    baseValue += twoPair;
  } else if (handMap.containsValue(2)) {
    baseValue += onePair;
  } else {
    baseValue += highCard;
  }
  return baseValue;
}

int getHandBaseValue(String hand, {bool isJackWild = false}) {
  int total = 0;
  for (int i = 0; i < hand.length; i++) {
    var card = hand[i];
    var val = isJackWild ? cardsValueMapJacksWild[card] : cardsValueMap[card];
    total += val! * pow(20, hand.length - i).toInt();
  }
  return total;
}

Map<String, int> makeJacksWild(Map<String, int> handMap, int baseValue) {
  if (handMap.containsKey('J')) {
    int numJacks = handMap['J']!;
    handMap.remove('J');
    if (handMap.isEmpty) {
      handMap['J'] = numJacks;
      numJacks = 0;
    }
    String higestCardKey = handMap.keys.reduce((value, element) =>
        handMap[value]! > handMap[element]! ? value : element);
    handMap[higestCardKey] = handMap[higestCardKey]! + numJacks;
  }
  return handMap;
}
