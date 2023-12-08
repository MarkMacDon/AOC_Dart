import 'dart:isolate';
import '../utils.dart';

var lines = getLines(dayNumber: 5);

//PART 1
main() async {
  final stopwatch = Stopwatch()..start();
  var (organizedLayers, seedsLayer) = getOrganizedLayersAndSeeds(lines);
  List<(int, int)> seedPairs = getSeedPairs(seedsLayer);
  List<(int, int)> splitSeedPairs = getSplitSeedPairs(seedPairs, 30000000);
  int? lowestLocation;

  await threadCalculateSeed(splitSeedPairs, organizedLayers).then((value) {
    for (var result in value) {
      lowestLocation == null || result < lowestLocation
          ? lowestLocation = result
          : null;
    }
  });
  print('Executed Async in ${stopwatch.elapsed}, Location: $lowestLocation');

  stopwatch.reset();

  int lowestLocationSync = getLowestLocation(seedPairs, organizedLayers);
  print('Executed Sync in ${stopwatch.elapsed}, Location: $lowestLocationSync');
}

int getLowestLocation(seedPairs, organizedLayers) {
  int? lowestLocation;
  for (int f = 0; f < seedPairs.length; f++) {
    print('Starting seed pair ${f + 1} of ${seedPairs.length}');
    for (int i = 0; i < seedPairs[f].$2; i++) {
      var seed = transformSeed(seedPairs[f].$1 + i, organizedLayers);

      lowestLocation == null || seed < lowestLocation
          ? lowestLocation = seed
          : null;
    }
  }
  return lowestLocation!;
}

// Organzie Data to more usable format
typedef AlmanacMapLayers = List<List<List<int>>>;
(AlmanacMapLayers, List<int>) getOrganizedLayersAndSeeds(List<String> lines) {
  RegExp numRegex = RegExp(r'\d+');
  List<List<int>> layers = [];
  List<int> layerList = [];
  for (int k = 0; k < lines.length; k++) {
    var words = lines[k].split(' ');
    for (var word in words) {
      if (numRegex.hasMatch(word)) {
        layerList.add(int.parse(numRegex.firstMatch(word)!.group(0)!));
      } else {
        if (layerList.isNotEmpty) {
          layers.add([...layerList]);
          layerList = [];
        }
      }
    }
  }
  if (layerList.isNotEmpty) {
    layers.add([...layerList]);
  }

  AlmanacMapLayers organizedLayers = [];
  for (int i = 1; i < layers.length; i++) {
    List<List<int>> sublayers = [];
    List<int> sublayer = [];
    for (int j = 0; j < layers[i].length; j++) {
      sublayer.add(layers[i][j]);
      if (j > 1 && (j + 1) % 3 == 0) {
        sublayers.add([...sublayer]);
        sublayer = [];
      }
    }
    organizedLayers.add([...sublayers]);
    sublayers = [];
  }
  return (organizedLayers, layers[0]);
}

// (start, range)
List<(int, int)> getSeedPairs(List<int> seedsLayer) => seedsLayer
    .asMap()
    .entries
    .map<(int, int)?>(
        (e) => e.key.isEven ? (e.value, seedsLayer[e.key + 1]) : null)
    .where((element) => element != null)
    .map((e) => e!)
    .toList();

// (start, range)
List<(int, int)> getSplitSeedPairs(List<(int, int)> seedPairs, int splitSize) {
  List<(int, int)> result = [];
  for (var seedPair in seedPairs) {
    int start = seedPair.$1;
    int end = start + seedPair.$2;

    for (int i = start; i < end; i += splitSize) {
      result.add((i, splitSize));
    }
  }

  return result;
}

int transformSeed(int seed, AlmanacMapLayers organizedLayers) {
  for (var layer in organizedLayers) {
    int newSeed = seed;
    for (var almanacMap in layer) {
      if (seed >= almanacMap[1] && seed < almanacMap[1] + almanacMap[2]) {
        newSeed = almanacMap[0] + seed - almanacMap[1];
        break;
      }
    }
    if (newSeed != seed) seed = newSeed;
  }
  return seed;
}

// Using isolates to calculate the seeds in parallel.
Future<List<dynamic>> threadCalculateSeed(seedPairs, organizedLayers) async {
  final results = <Future>[];
  for (int f = 0; f < seedPairs.length; f++) {
    print('Starting seed pair ${f + 1} of ${seedPairs.length}');

    // Create a new isolate and send the seed pair and the organized layers.
    final receivePort = ReceivePort();
    Isolate.spawn(calculateSeed, [receivePort.sendPort, organizedLayers]);
    final sendPort = await receivePort.first;
    final reply = ReceivePort();
    sendPort.send([seedPairs[f], reply.sendPort]);
    results.add(reply.first);
  }

  return await Future.wait(results);
}

// This function will be run in each isolate.
void calculateSeed(List<dynamic> args) {
  // Receive the initial message containing the seed pair and the organized layers.
  final port = ReceivePort();
  final sendPort = args[0] as SendPort;
  final organizedLayers = args[1] as AlmanacMapLayers;
  sendPort.send(port.sendPort);
  port.listen((message) {
    final seedPair = message[0];
    final replyTo = message[1];
    int? lowestLocation;
    for (int i = 0; i < seedPair.$2; i++) {
      var seed = seedPair.$1 + i;
      seed = transformSeed(seed, organizedLayers);
      lowestLocation == null || seed < lowestLocation
          ? lowestLocation = seed
          : null;
    }
    // Send the result back to the main isolate.
    replyTo.send(lowestLocation);
  });
}
