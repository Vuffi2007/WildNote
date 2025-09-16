import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'fish.g.dart';


@HiveType(typeId: 0)
class Fish {
  @HiveField(0)
  String species;

  @HiveField(1)
  double weight;

  @HiveField(2)
  double length;

  @HiveField(3)
  Uint8List imageBytes;

  @HiveField(4)
  DateTime caughtOn;

  Fish({
    required this.species,
    required this.weight,
    required this.length,
    required this.imageBytes,
    required this.caughtOn,
  });
}