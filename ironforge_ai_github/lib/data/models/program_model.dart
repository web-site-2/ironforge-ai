// lib/data/models/program_model.dart

import 'package:hive/hive.dart';

part 'program_model.g.dart';

@HiveType(typeId: 8)
class ProgramModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String type; // ppl, upper_lower, arnold, bro_split, full_body, powerlifting, etc.

  @HiveField(4)
  final int durationWeeks;

  @HiveField(5)
  final int daysPerWeek;

  @HiveField(6)
  final String difficulty;

  @HiveField(7)
  final List<String> targetGoals;

  @HiveField(8)
  final List<String> requiredEquipment;

  @HiveField(9)
  final List<ProgramDayModel> programDays;

  @HiveField(10)
  final bool isCustom;

  @HiveField(11)
  final String? createdByUserId;

  @HiveField(12)
  final DateTime createdAt;

  @HiveField(13)
  bool isActive;

  @HiveField(14)
  int currentWeek;

  @HiveField(15)
  int currentDay;

  @HiveField(16)
  final String? imageAsset;

  @HiveField(17)
  final List<String> keyFeatures;

  @HiveField(18)
  final String fitnessLevel;

  ProgramModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.durationWeeks,
    required this.daysPerWeek,
    required this.difficulty,
    required this.targetGoals,
    required this.requiredEquipment,
    required this.programDays,
    this.isCustom = false,
    this.createdByUserId,
    required this.createdAt,
    this.isActive = false,
    this.currentWeek = 1,
    this.currentDay = 1,
    this.imageAsset,
    required this.keyFeatures,
    required this.fitnessLevel,
  });
}

@HiveType(typeId: 9)
class ProgramDayModel {
  @HiveField(0)
  final int weekNumber;

  @HiveField(1)
  final int dayNumber;

  @HiveField(2)
  final String workoutId;

  @HiveField(3)
  final String workoutName;

  @HiveField(4)
  final String muscleGroup;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  DateTime? completedAt;

  ProgramDayModel({
    required this.weekNumber,
    required this.dayNumber,
    required this.workoutId,
    required this.workoutName,
    required this.muscleGroup,
    this.isCompleted = false,
    this.completedAt,
  });
}
