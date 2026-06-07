// lib/data/models/program_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_model.dart';

class ProgramModelAdapter extends TypeAdapter<ProgramModel> {
  @override
  final int typeId = 8;

  @override
  ProgramModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgramModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      type: fields[3] as String,
      durationWeeks: fields[4] as int,
      daysPerWeek: fields[5] as int,
      difficulty: fields[6] as String,
      targetGoals: (fields[7] as List).cast<String>(),
      requiredEquipment: (fields[8] as List).cast<String>(),
      programDays: (fields[9] as List).cast<ProgramDayModel>(),
      isCustom: fields[10] as bool,
      createdByUserId: fields[11] as String?,
      createdAt: fields[12] as DateTime,
      isActive: fields[13] as bool,
      currentWeek: fields[14] as int,
      currentDay: fields[15] as int,
      imageAsset: fields[16] as String?,
      keyFeatures: (fields[17] as List).cast<String>(),
      fitnessLevel: fields[18] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProgramModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.durationWeeks)
      ..writeByte(5)
      ..write(obj.daysPerWeek)
      ..writeByte(6)
      ..write(obj.difficulty)
      ..writeByte(7)
      ..write(obj.targetGoals)
      ..writeByte(8)
      ..write(obj.requiredEquipment)
      ..writeByte(9)
      ..write(obj.programDays)
      ..writeByte(10)
      ..write(obj.isCustom)
      ..writeByte(11)
      ..write(obj.createdByUserId)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.isActive)
      ..writeByte(14)
      ..write(obj.currentWeek)
      ..writeByte(15)
      ..write(obj.currentDay)
      ..writeByte(16)
      ..write(obj.imageAsset)
      ..writeByte(17)
      ..write(obj.keyFeatures)
      ..writeByte(18)
      ..write(obj.fitnessLevel);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgramModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProgramDayModelAdapter extends TypeAdapter<ProgramDayModel> {
  @override
  final int typeId = 9;

  @override
  ProgramDayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgramDayModel(
      weekNumber: fields[0] as int,
      dayNumber: fields[1] as int,
      workoutId: fields[2] as String,
      workoutName: fields[3] as String,
      muscleGroup: fields[4] as String,
      isCompleted: fields[5] as bool,
      completedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ProgramDayModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.weekNumber)
      ..writeByte(1)
      ..write(obj.dayNumber)
      ..writeByte(2)
      ..write(obj.workoutId)
      ..writeByte(3)
      ..write(obj.workoutName)
      ..writeByte(4)
      ..write(obj.muscleGroup)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgramDayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
