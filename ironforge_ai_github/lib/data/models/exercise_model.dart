// lib/data/models/exercise_model.dart

import 'package:hive/hive.dart';

part 'exercise_model.g.dart';

@HiveType(typeId: 0)
class ExerciseModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String targetMuscle;

  @HiveField(3)
  final List<String> secondaryMuscles;

  @HiveField(4)
  final String difficulty; // Beginner, Intermediate, Advanced

  @HiveField(5)
  final List<String> equipment;

  @HiveField(6)
  final List<String> instructions;

  @HiveField(7)
  final List<String> commonMistakes;

  @HiveField(8)
  final List<String> injuryPreventionTips;

  @HiveField(9)
  final String breathingInstructions;

  @HiveField(10)
  final String trainingNotes;

  @HiveField(11)
  final List<String> alternatives;

  @HiveField(12)
  final String? youtubeVideoId;

  @HiveField(13)
  final String? glbModelPath;

  @HiveField(14)
  final String category; // compound, isolation, bodyweight

  @HiveField(15)
  final bool isFavorite;

  @HiveField(16)
  final String? personalNote;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.targetMuscle,
    required this.secondaryMuscles,
    required this.difficulty,
    required this.equipment,
    required this.instructions,
    required this.commonMistakes,
    required this.injuryPreventionTips,
    required this.breathingInstructions,
    required this.trainingNotes,
    required this.alternatives,
    this.youtubeVideoId,
    this.glbModelPath,
    required this.category,
    this.isFavorite = false,
    this.personalNote,
  });

  ExerciseModel copyWith({
    String? id,
    String? name,
    String? targetMuscle,
    List<String>? secondaryMuscles,
    String? difficulty,
    List<String>? equipment,
    List<String>? instructions,
    List<String>? commonMistakes,
    List<String>? injuryPreventionTips,
    String? breathingInstructions,
    String? trainingNotes,
    List<String>? alternatives,
    String? youtubeVideoId,
    String? glbModelPath,
    String? category,
    bool? isFavorite,
    String? personalNote,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      targetMuscle: targetMuscle ?? this.targetMuscle,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      difficulty: difficulty ?? this.difficulty,
      equipment: equipment ?? this.equipment,
      instructions: instructions ?? this.instructions,
      commonMistakes: commonMistakes ?? this.commonMistakes,
      injuryPreventionTips: injuryPreventionTips ?? this.injuryPreventionTips,
      breathingInstructions: breathingInstructions ?? this.breathingInstructions,
      trainingNotes: trainingNotes ?? this.trainingNotes,
      alternatives: alternatives ?? this.alternatives,
      youtubeVideoId: youtubeVideoId ?? this.youtubeVideoId,
      glbModelPath: glbModelPath ?? this.glbModelPath,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      personalNote: personalNote ?? this.personalNote,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'targetMuscle': targetMuscle,
        'secondaryMuscles': secondaryMuscles,
        'difficulty': difficulty,
        'equipment': equipment,
        'instructions': instructions,
        'commonMistakes': commonMistakes,
        'injuryPreventionTips': injuryPreventionTips,
        'breathingInstructions': breathingInstructions,
        'trainingNotes': trainingNotes,
        'alternatives': alternatives,
        'youtubeVideoId': youtubeVideoId,
        'glbModelPath': glbModelPath,
        'category': category,
        'isFavorite': isFavorite,
        'personalNote': personalNote,
      };
}

// Muscle Group enum for filtering
enum MuscleGroup {
  chest,
  back,
  shoulders,
  biceps,
  triceps,
  forearms,
  abs,
  legs,
  calves,
  glutes,
  fullBody,
}

extension MuscleGroupExtension on MuscleGroup {
  String get displayName {
    switch (this) {
      case MuscleGroup.chest: return 'Chest';
      case MuscleGroup.back: return 'Back';
      case MuscleGroup.shoulders: return 'Shoulders';
      case MuscleGroup.biceps: return 'Biceps';
      case MuscleGroup.triceps: return 'Triceps';
      case MuscleGroup.forearms: return 'Forearms';
      case MuscleGroup.abs: return 'Abs';
      case MuscleGroup.legs: return 'Legs';
      case MuscleGroup.calves: return 'Calves';
      case MuscleGroup.glutes: return 'Glutes';
      case MuscleGroup.fullBody: return 'Full Body';
    }
  }

  String get emoji {
    switch (this) {
      case MuscleGroup.chest: return '💪';
      case MuscleGroup.back: return '🏋️';
      case MuscleGroup.shoulders: return '🔝';
      case MuscleGroup.biceps: return '💪';
      case MuscleGroup.triceps: return '🤜';
      case MuscleGroup.forearms: return '🦾';
      case MuscleGroup.abs: return '🔥';
      case MuscleGroup.legs: return '🦵';
      case MuscleGroup.calves: return '🦶';
      case MuscleGroup.glutes: return '🍑';
      case MuscleGroup.fullBody: return '⚡';
    }
  }
}

enum Difficulty { beginner, intermediate, advanced }

extension DifficultyExtension on Difficulty {
  String get displayName {
    switch (this) {
      case Difficulty.beginner: return 'Beginner';
      case Difficulty.intermediate: return 'Intermediate';
      case Difficulty.advanced: return 'Advanced';
    }
  }
}

enum EquipmentType {
  barbell,
  dumbbell,
  machine,
  cable,
  bodyweight,
  resistanceBand,
  kettlebell,
  ezBar,
  pullUpBar,
  dipBars,
  bench,
  smithMachine,
}

extension EquipmentTypeExtension on EquipmentType {
  String get displayName {
    switch (this) {
      case EquipmentType.barbell: return 'Barbell';
      case EquipmentType.dumbbell: return 'Dumbbell';
      case EquipmentType.machine: return 'Machine';
      case EquipmentType.cable: return 'Cable';
      case EquipmentType.bodyweight: return 'Bodyweight';
      case EquipmentType.resistanceBand: return 'Resistance Band';
      case EquipmentType.kettlebell: return 'Kettlebell';
      case EquipmentType.ezBar: return 'EZ Bar';
      case EquipmentType.pullUpBar: return 'Pull-Up Bar';
      case EquipmentType.dipBars: return 'Dip Bars';
      case EquipmentType.bench: return 'Bench';
      case EquipmentType.smithMachine: return 'Smith Machine';
    }
  }
}
