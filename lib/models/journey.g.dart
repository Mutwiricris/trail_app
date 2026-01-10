// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WaypointAdapter extends TypeAdapter<Waypoint> {
  @override
  final int typeId = 1;

  @override
  Waypoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Waypoint(
      id: fields[0] as String,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      timestamp: fields[3] as DateTime,
      name: fields[4] as String?,
      note: fields[5] as String?,
      photoUrls: (fields[6] as List?)?.cast<String>(),
      altitude: fields[7] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Waypoint obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.note)
      ..writeByte(6)
      ..write(obj.photoUrls)
      ..writeByte(7)
      ..write(obj.altitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaypointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JourneyAdapter extends TypeAdapter<Journey> {
  @override
  final int typeId = 0;

  @override
  Journey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Journey(
      id: fields[0] as String,
      title: fields[1] as String,
      type: fields[2] as JourneyType,
      startTime: fields[3] as DateTime,
      endTime: fields[4] as DateTime?,
      waypoints: (fields[5] as List?)?.cast<Waypoint>(),
      distanceKm: fields[6] as double,
      photoUrls: (fields[7] as List?)?.cast<String>(),
      description: fields[8] as String?,
      isActive: fields[9] as bool,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Journey obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.waypoints)
      ..writeByte(6)
      ..write(obj.distanceKm)
      ..writeByte(7)
      ..write(obj.photoUrls)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JourneyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
