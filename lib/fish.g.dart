// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fish.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FishAdapter extends TypeAdapter<Fish> {
  @override
  final int typeId = 0;

  @override
  Fish read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Fish(
      species: fields[0] as String,
      weight: fields[1] as double,
      length: fields[2] as double,
      imageBytes: fields[3] as Uint8List,
      caughtOn: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Fish obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.species)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.length)
      ..writeByte(3)
      ..write(obj.imageBytes)
      ..writeByte(4)
      ..write(obj.caughtOn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FishAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
