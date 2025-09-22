import 'package:hive/hive.dart';

part 'fish.g.dart';


@HiveType(typeId: 0)
class Fish {
  @HiveField(0)
  String species;

  @HiveField(1)
  double? weight;

  @HiveField(2)
  double? length;

  @HiveField(3)
  String imagePath;

  @HiveField(4)
  DateTime caughtOn;

  Fish({
    required this.species,
    this.weight,
    this.length,
    required this.imagePath,
    required this.caughtOn,
  });
}