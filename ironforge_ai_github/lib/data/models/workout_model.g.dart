// lib/data/models/workout_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_model.dart';

class WorkoutSetModelAdapter extends TypeAdapter<WorkoutSetModel> {
  @override
  final int typeId = 2;

  @override
  WorkoutSetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutSetModel(
      setNumber: fields[0] as int,
      weight: fields[1] as double,
      reps: fields[2] as int,
      restSeconds: fields[3] as int,
      isCompleted: fields[4] as bool,
      setType: fields[5] as String,
      notes: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutSetModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.setNumber)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.reps)
      ..writeByte(3)
      ..write(obj.restSeconds)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.setType)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutExerciseModelAdapter extends TypeAdapter<WorkoutExerciseModel> {
  @override
  final int typeId = 3;

  @override
  WorkoutExerciseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutExerciseModel(
      exerciseId: fields[0] as String,
      exerciseName: fields[1] as String,
      sets: (fields[2] as List).cast<WorkoutSetModel>(),
      orderIndex: fields[3] as int,
      notes: fields[4] as String?,
      isSuperset: fields[5] as bool,
      supersetWith: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutExerciseModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.exerciseId)
      ..writeByte(1)
      ..write(obj.exerciseName)
      ..writeByte(2)
      ..write(obj.sets)
      ..writeByte(3)
      ..write(obj.orderIndex)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.isSuperset)
      ..writeByte(6)
      ..write(obj.supersetWith);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutExerciseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutModelAdapter extends TypeAdapter<WorkoutModel> {
  @override
  final int typeId = 4;

  @override
  WorkoutModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      exercises: (fields[3] as List).cast<WorkoutExerciseModel>(),
      targetMuscleGroup: fields[4] as String,
      estimatedDurationMinutes: fields[5] as int,
      difficulty: fields[6] as String,
      createdAt: fields[7] as DateTime,
      isCustom: fields[8] as bool,
      programId: fields[9] as String?,
      weekNumber: fields[10] as int,
      dayNumber: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.exercises)
      ..writeByte(4)
      ..write(obj.targetMuscleGroup)
      ..writeByte(5)
      ..write(obj.estimatedDurationMinutes)
      ..writeByte(6)
      ..write(obj.difficulty)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.isCustom)
      ..writeByte(9)
      ..write(obj.programId)
      ..writeByte(10)
      ..write(obj.weekNumber)
      ..writeByte(11)
      ..write(obj.dayNumber);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutLogModelAdapter extends TypeAdapter<WorkoutLogModel> {
  @override
  final int typeId = 5;

  @override
  WorkoutLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutLogModel(
      id: fields[0] as String,
      workoutId: fields[1] as String,
      workoutName: fields[2] as String,
      startTime: fields[3] as DateTime,
      endTime: fields[4] as DateTime?,
      exercises: (fields[5] as List).cast<WorkoutExerciseModel>(),
      totalVolume: fields[6] as double,
      totalSets: fields[7] as int,
      durationSeconds: fields[8] as int,
      notes: fields[9] as String?,
      rating: fields[10] as int,
      bodyWeight: fields[11] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutLogModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.workoutId)
      ..writeByte(2)
      ..write(obj.workoutName)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.exercises)
      ..writeByte(6)
      ..write(obj.totalVolume)
      ..writeByte(7)
      ..write(obj.totalSets)
      ..writeByte(8)
      ..write(obj.durationSeconds)
      ..writeByte(9)
      ..write(obj.notes)
      ..writeByte(10)
      ..write(obj.rating)
      ..writeByte(11)
      ..write(obj.bodyWeight);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PersonalRecordModelAdapter extends TypeAdapter<PersonalRecordModel> {
  @override
  final int typeId = 6;

  @override
  PersonalRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonalRecordModel(
      exerciseId: fields[0] as String,
      exerciseName: fields[1] as String,
      weightKg: fields[2] as double,
      reps: fields[3] as int,
      achievedAt: fields[4] as DateTime,
      estimatedOneRM: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PersonalRecordModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.exerciseId)
      ..writeByte(1)
      ..write(obj.exerciseName)
      ..writeByte(2)
      ..write(obj.weightKg)
      ..writeByte(3)
      ..write(obj.reps)
      ..writeByte(4)
      ..write(obj.achievedAt)
      ..writeByte(5)
      ..write(obj.estimatedOneRM);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BodyMeasurementModelAdapter extends TypeAdapter<BodyMeasurementModel> {
  @override
  final int typeId = 7;

  @override
  BodyMeasurementModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BodyMeasurementModel(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      weightKg: fields[2] as double,
      bodyFatPercentage: fields[3] as double?,
      chestCm: fields[4] as double?,
      waistCm: fields[5] as double?,
      hipsCm: fields[6] as double?,
      leftArmCm: fields[7] as double?,
      rightArmCm: fields[8] as double?,
      leftThighCm: fields[9] as double?,
      rightThighCm: fields[10] as double?,
      neckCm: fields[11] as double?,
      progressPhotoPath: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BodyMeasurementModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.weightKg)
      ..writeByte(3)
      ..write(obj.bodyFatPercentage)
      ..writeByte(4)
      ..write(obj.chestCm)
      ..writeByte(5)
      ..write(obj.waistCm)
      ..writeByte(6)
      ..write(obj.hipsCm)
      ..writeByte(7)
      ..write(obj.leftArmCm)
      ..writeByte(8)
      ..write(obj.rightArmCm)
      ..writeByte(9)
      ..write(obj.leftThighCm)
      ..writeByte(10)
      ..write(obj.rightThighCm)
      ..writeByte(11)
      ..write(obj.neckCm)
      ..writeByte(12)
      ..write(obj.progressPhotoPath);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BodyMeasurementModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
