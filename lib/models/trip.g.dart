// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripAdapter extends TypeAdapter<Trip> {
  @override
  final int typeId = 6;

  @override
  Trip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trip(
      id: fields[0] as String?,
      title: fields[1] as String,
      type: fields[2] as TripType,
      status: fields[3] as TripStatus?,
      startDate: fields[4] as DateTime?,
      endDate: fields[5] as DateTime?,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
      items: (fields[8] as List?)?.cast<TripItem>(),
      description: fields[9] as String?,
      notes: (fields[10] as List?)?.cast<String>(),
      coverPhotoUrl: fields[11] as String?,
      operatorBooking: fields[12] as OperatorBooking?,
      activeJourneyId: fields[13] as String?,
      completedJourneyIds: (fields[14] as List?)?.cast<String>(),
      userId: fields[15] as String,
      isArchived: fields[16] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Trip obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.items)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.notes)
      ..writeByte(11)
      ..write(obj.coverPhotoUrl)
      ..writeByte(12)
      ..write(obj.operatorBooking)
      ..writeByte(13)
      ..write(obj.activeJourneyId)
      ..writeByte(14)
      ..write(obj.completedJourneyIds)
      ..writeByte(15)
      ..write(obj.userId)
      ..writeByte(16)
      ..write(obj.isArchived);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TripItemAdapter extends TypeAdapter<TripItem> {
  @override
  final int typeId = 7;

  @override
  TripItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripItem(
      id: fields[0] as String?,
      type: fields[1] as TripItemType,
      referenceId: fields[2] as String,
      name: fields[3] as String,
      description: fields[4] as String?,
      latitude: fields[5] as double,
      longitude: fields[6] as double,
      scheduledDate: fields[7] as DateTime?,
      orderIndex: fields[8] as int?,
      isVisited: fields[9] as bool?,
      visitedAt: fields[10] as DateTime?,
      visitJourneyId: fields[11] as String?,
      notes: fields[12] as String?,
      photoUrls: (fields[13] as List?)?.cast<String>(),
      coverPhotoUrl: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TripItem obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.referenceId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.latitude)
      ..writeByte(6)
      ..write(obj.longitude)
      ..writeByte(7)
      ..write(obj.scheduledDate)
      ..writeByte(8)
      ..write(obj.orderIndex)
      ..writeByte(9)
      ..write(obj.isVisited)
      ..writeByte(10)
      ..write(obj.visitedAt)
      ..writeByte(11)
      ..write(obj.visitJourneyId)
      ..writeByte(12)
      ..write(obj.notes)
      ..writeByte(13)
      ..write(obj.photoUrls)
      ..writeByte(14)
      ..write(obj.coverPhotoUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OperatorBookingAdapter extends TypeAdapter<OperatorBooking> {
  @override
  final int typeId = 8;

  @override
  OperatorBooking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OperatorBooking(
      operatorId: fields[0] as String,
      operatorName: fields[1] as String,
      operatorPhone: fields[2] as String?,
      operatorEmail: fields[3] as String?,
      confirmationCode: fields[4] as String,
      priceKES: fields[5] as double,
      currency: fields[6] as String?,
      bookedAt: fields[7] as DateTime?,
      includedServices: (fields[8] as List?)?.cast<String>(),
      excludedServices: (fields[9] as List?)?.cast<String>(),
      accommodationType: fields[10] as String?,
      numberOfGuests: fields[11] as int?,
      isPaid: fields[12] as bool?,
      isConfirmed: fields[13] as bool?,
      cancellationPolicy: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OperatorBooking obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.operatorId)
      ..writeByte(1)
      ..write(obj.operatorName)
      ..writeByte(2)
      ..write(obj.operatorPhone)
      ..writeByte(3)
      ..write(obj.operatorEmail)
      ..writeByte(4)
      ..write(obj.confirmationCode)
      ..writeByte(5)
      ..write(obj.priceKES)
      ..writeByte(6)
      ..write(obj.currency)
      ..writeByte(7)
      ..write(obj.bookedAt)
      ..writeByte(8)
      ..write(obj.includedServices)
      ..writeByte(9)
      ..write(obj.excludedServices)
      ..writeByte(10)
      ..write(obj.accommodationType)
      ..writeByte(11)
      ..write(obj.numberOfGuests)
      ..writeByte(12)
      ..write(obj.isPaid)
      ..writeByte(13)
      ..write(obj.isConfirmed)
      ..writeByte(14)
      ..write(obj.cancellationPolicy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperatorBookingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
