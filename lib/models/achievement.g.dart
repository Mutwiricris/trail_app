// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAchievementProgressAdapter
    extends TypeAdapter<UserAchievementProgress> {
  @override
  final int typeId = 4;

  @override
  UserAchievementProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAchievementProgress(
      userId: fields[0] as String,
      progressValues: (fields[1] as Map?)?.cast<String, int>(),
      unlockedAchievements: (fields[2] as List?)?.cast<String>(),
      totalXP: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserAchievementProgress obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.progressValues)
      ..writeByte(2)
      ..write(obj.unlockedAchievements)
      ..writeByte(3)
      ..write(obj.totalXP);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAchievementProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
