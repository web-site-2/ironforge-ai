// lib/data/models/user_profile_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

class UserProfileModelAdapter extends TypeAdapter<UserProfileModel> {
  @override
  final int typeId = 1;

  @override
  UserProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileModel(
      name: fields[0] as String,
      age: fields[1] as int,
      weightKg: fields[2] as double,
      heightCm: fields[3] as double,
      gender: fields[4] as String,
      fitnessLevel: fields[5] as String,
      strengthLevel: fields[6] as String,
      primaryGoal: fields[7] as String,
      availableEquipment: (fields[8] as List).cast<String>(),
      workoutDaysPerWeek: fields[9] as int,
      activeWorkoutProgramId: fields[10] as String?,
      createdAt: fields[11] as DateTime,
      workoutStreak: fields[12] as int,
      lastWorkoutDate: fields[13] as DateTime?,
      targetWeightKg: fields[14] as double,
      profileImagePath: fields[15] as String?,
      onboardingCompleted: fields[16] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.weightKg)
      ..writeByte(3)
      ..write(obj.heightCm)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.fitnessLevel)
      ..writeByte(6)
      ..write(obj.strengthLevel)
      ..writeByte(7)
      ..write(obj.primaryGoal)
      ..writeByte(8)
      ..write(obj.availableEquipment)
      ..writeByte(9)
      ..write(obj.workoutDaysPerWeek)
      ..writeByte(10)
      ..write(obj.activeWorkoutProgramId)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.workoutStreak)
      ..writeByte(13)
      ..write(obj.lastWorkoutDate)
      ..writeByte(14)
      ..write(obj.targetWeightKg)
      ..writeByte(15)
      ..write(obj.profileImagePath)
      ..writeByte(16)
      ..write(obj.onboardingCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
