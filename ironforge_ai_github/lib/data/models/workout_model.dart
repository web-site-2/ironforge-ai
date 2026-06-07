// lib/data/models/workout_model.dart

import 'package:hive/hive.dart';

part 'workout_model.g.dart';

@HiveType(typeId: 2)
class WorkoutSetModel {
  @HiveField(0)
  final int setNumber;

  @HiveField(1)
  double weight;

  @HiveField(2)
  int reps;

  @HiveField(3)
  int restSeconds;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  String setType; // normal, warmup, dropset, failureset

  @HiveField(6)
  String? notes;

  WorkoutSetModel({
    required this.setNumber,
    required this.weight,
    required this.reps,
    this.restSeconds = 90,
    this.isCompleted = false,
    this.setType = 'normal',
    this.notes,
  });

  WorkoutSetModel copyWith({
    int? setNumber,
    double? weight,
    int? reps,
    int? restSeconds,
    bool? isCompleted,
    String? setType,
    String? notes,
  }) {
    return WorkoutSetModel(
      setNumber: setNumber ?? this.setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      restSeconds: restSeconds ?? this.restSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      setType: setType ?? this.setType,
      notes: notes ?? this.notes,
    );
  }
}

@HiveType(typeId: 3)
class WorkoutExerciseModel {
  @HiveField(0)
  final String exerciseId;

  @HiveField(1)
  final String exerciseName;

  @HiveField(2)
  List<WorkoutSetModel> sets;

  @HiveField(3)
  int orderIndex;

  @HiveField(4)
  String? notes;

  @HiveField(5)
  bool isSuperset;

  @HiveField(6)
  String? supersetWith;

  WorkoutExerciseModel({
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    required this.orderIndex,
    this.notes,
    this.isSuperset = false,
    this.supersetWith,
  });

  double get totalVolume {
    return sets.fold(0, (total, set) => total + (set.weight * set.reps));
  }

  WorkoutExerciseModel copyWith({
    String? exerciseId,
    String? exerciseName,
    List<WorkoutSetModel>? sets,
    int? orderIndex,
    String? notes,
    bool? isSuperset,
    String? supersetWith,
  }) {
    return WorkoutExerciseModel(
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      sets: sets ?? this.sets,
      orderIndex: orderIndex ?? this.orderIndex,
      notes: notes ?? this.notes,
      isSuperset: isSuperset ?? this.isSuperset,
      supersetWith: supersetWith ?? this.supersetWith,
    );
  }
}

@HiveType(typeId: 4)
class WorkoutModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  List<WorkoutExerciseModel> exercises;

  @HiveField(4)
  String targetMuscleGroup;

  @HiveField(5)
  int estimatedDurationMinutes;

  @HiveField(6)
  String difficulty;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  bool isCustom;

  @HiveField(9)
  String? programId;

  @HiveField(10)
  int weekNumber;

  @HiveField(11)
  int dayNumber;

  WorkoutModel({
    required this.id,
    required this.name,
    this.description,
    required this.exercises,
    required this.targetMuscleGroup,
    required this.estimatedDurationMinutes,
    required this.difficulty,
    required this.createdAt,
    this.isCustom = false,
    this.programId,
    this.weekNumber = 1,
    this.dayNumber = 1,
  });

  int get totalSets => exercises.fold(0, (total, ex) => total + ex.sets.length);
  int get totalExercises => exercises.length;
}

@HiveType(typeId: 5)
class WorkoutLogModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String workoutId;

  @HiveField(2)
  final String workoutName;

  @HiveField(3)
  final DateTime startTime;

  @HiveField(4)
  DateTime? endTime;

  @HiveField(5)
  final List<WorkoutExerciseModel> exercises;

  @HiveField(6)
  double totalVolume;

  @HiveField(7)
  int totalSets;

  @HiveField(8)
  int durationSeconds;

  @HiveField(9)
  String? notes;

  @HiveField(10)
  int rating; // 1-5

  @HiveField(11)
  double? bodyWeight;

  WorkoutLogModel({
    required this.id,
    required this.workoutId,
    required this.workoutName,
    required this.startTime,
    this.endTime,
    required this.exercises,
    required this.totalVolume,
    required this.totalSets,
    required this.durationSeconds,
    this.notes,
    this.rating = 3,
    this.bodyWeight,
  });

  bool get isCompleted => endTime != null;
}

@HiveType(typeId: 6)
class PersonalRecordModel extends HiveObject {
  @HiveField(0)
  final String exerciseId;

  @HiveField(1)
  final String exerciseName;

  @HiveField(2)
  double weightKg;

  @HiveField(3)
  int reps;

  @HiveField(4)
  DateTime achievedAt;

  @HiveField(5)
  double estimatedOneRM;

  PersonalRecordModel({
    required this.exerciseId,
    required this.exerciseName,
    required this.weightKg,
    required this.reps,
    required this.achievedAt,
    required this.estimatedOneRM,
  });

  // Epley formula for 1RM
  static double calculateOneRM(double weight, int reps) {
    if (reps == 1) return weight;
    return weight * (1 + reps / 30);
  }
}

@HiveType(typeId: 7)
class BodyMeasurementModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final double weightKg;

  @HiveField(3)
  double? bodyFatPercentage;

  @HiveField(4)
  double? chestCm;

  @HiveField(5)
  double? waistCm;

  @HiveField(6)
  double? hipsCm;

  @HiveField(7)
  double? leftArmCm;

  @HiveField(8)
  double? rightArmCm;

  @HiveField(9)
  double? leftThighCm;

  @HiveField(10)
  double? rightThighCm;

  @HiveField(11)
  double? neckCm;

  @HiveField(12)
  String? progressPhotoPath;

  BodyMeasurementModel({
    required this.id,
    required this.date,
    required this.weightKg,
    this.bodyFatPercentage,
    this.chestCm,
    this.waistCm,
    this.hipsCm,
    this.leftArmCm,
    this.rightArmCm,
    this.leftThighCm,
    this.rightThighCm,
    this.neckCm,
    this.progressPhotoPath,
  });
}
