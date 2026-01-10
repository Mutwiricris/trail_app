// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WishlistItemAdapter extends TypeAdapter<WishlistItem> {
  @override
  final int typeId = 9;

  @override
  WishlistItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishlistItem(
      id: fields[0] as String?,
      type: fields[1] as WishlistItemType,
      referenceId: fields[2] as String,
      name: fields[3] as String,
      description: fields[4] as String?,
      latitude: fields[5] as double,
      longitude: fields[6] as double,
      coverPhotoUrl: fields[7] as String?,
      rating: fields[8] as double?,
      savedAt: fields[9] as DateTime?,
      userId: fields[10] as String,
      notes: fields[11] as String?,
      priority: fields[12] as int?,
      tags: (fields[13] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, WishlistItem obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.coverPhotoUrl)
      ..writeByte(8)
      ..write(obj.rating)
      ..writeByte(9)
      ..write(obj.savedAt)
      ..writeByte(10)
      ..write(obj.userId)
      ..writeByte(11)
      ..write(obj.notes)
      ..writeByte(12)
      ..write(obj.priority)
      ..writeByte(13)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
