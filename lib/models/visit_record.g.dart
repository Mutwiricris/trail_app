// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitRecordAdapter extends TypeAdapter<VisitRecord> {
  @override
  final int typeId = 10;

  @override
  VisitRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisitRecord(
      id: fields[0] as String?,
      placeId: fields[1] as String,
      placeType: fields[2] as String,
      placeName: fields[3] as String,
      visitedAt: fields[4] as DateTime?,
      visitType: fields[5] as VisitType,
      visitLatitude: fields[6] as double,
      visitLongitude: fields[7] as double,
      distanceFromPlaceMeters: fields[8] as double?,
      journeyId: fields[9] as String?,
      waypointId: fields[10] as String?,
      userId: fields[11] as String,
      photoUrls: (fields[12] as List?)?.cast<String>(),
      notes: fields[13] as String?,
      userRating: fields[14] as double?,
      createdAt: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, VisitRecord obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.placeId)
      ..writeByte(2)
      ..write(obj.placeType)
      ..writeByte(3)
      ..write(obj.placeName)
      ..writeByte(4)
      ..write(obj.visitedAt)
      ..writeByte(5)
      ..write(obj.visitType)
      ..writeByte(6)
      ..write(obj.visitLatitude)
      ..writeByte(7)
      ..write(obj.visitLongitude)
      ..writeByte(8)
      ..write(obj.distanceFromPlaceMeters)
      ..writeByte(9)
      ..write(obj.journeyId)
      ..writeByte(10)
      ..write(obj.waypointId)
      ..writeByte(11)
      ..write(obj.userId)
      ..writeByte(12)
      ..write(obj.photoUrls)
      ..writeByte(13)
      ..write(obj.notes)
      ..writeByte(14)
      ..write(obj.userRating)
      ..writeByte(15)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
