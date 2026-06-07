// lib/data/models/exercise_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseModelAdapter extends TypeAdapter<ExerciseModel> {
  @override
  final int typeId = 0;

  @override
  ExerciseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseModel(
      id: fields[0] as String,
      name: fields[1] as String,
      targetMuscle: fields[2] as String,
      secondaryMuscles: (fields[3] as List).cast<String>(),
      difficulty: fields[4] as String,
      equipment: (fields[5] as List).cast<String>(),
      instructions: (fields[6] as List).cast<String>(),
      commonMistakes: (fields[7] as List).cast<String>(),
      injuryPreventionTips: (fields[8] as List).cast<String>(),
      breathingInstructions: fields[9] as String,
      trainingNotes: fields[10] as String,
      alternatives: (fields[11] as List).cast<String>(),
      youtubeVideoId: fields[12] as String?,
      glbModelPath: fields[13] as String?,
      category: fields[14] as String,
      isFavorite: fields[15] as bool,
      personalNote: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.targetMuscle)
      ..writeByte(3)
      ..write(obj.secondaryMuscles)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.equipment)
      ..writeByte(6)
      ..write(obj.instructions)
      ..writeByte(7)
      ..write(obj.commonMistakes)
      ..writeByte(8)
      ..write(obj.injuryPreventionTips)
      ..writeByte(9)
      ..write(obj.breathingInstructions)
      ..writeByte(10)
      ..write(obj.trainingNotes)
      ..writeByte(11)
      ..write(obj.alternatives)
      ..writeByte(12)
      ..write(obj.youtubeVideoId)
      ..writeByte(13)
      ..write(obj.glbModelPath)
      ..writeByte(14)
      ..write(obj.category)
      ..writeByte(15)
      ..write(obj.isFavorite)
      ..writeByte(16)
      ..write(obj.personalNote);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
