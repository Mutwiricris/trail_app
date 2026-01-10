// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemoryAdapter extends TypeAdapter<Memory> {
  @override
  final int typeId = 2;

  @override
  Memory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Memory(
      id: fields[0] as String,
      journeyId: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String?,
      originalDate: fields[4] as DateTime,
      photoUrl: fields[5] as String?,
      stats: (fields[6] as Map).cast<String, dynamic>(),
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Memory obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.journeyId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.originalDate)
      ..writeByte(5)
      ..write(obj.photoUrl)
      ..writeByte(6)
      ..write(obj.stats)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
