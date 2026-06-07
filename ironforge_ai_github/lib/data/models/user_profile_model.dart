// lib/data/models/user_profile_model.dart

import 'package:hive/hive.dart';

part 'user_profile_model.g.dart';

@HiveType(typeId: 1)
class UserProfileModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  double weightKg;

  @HiveField(3)
  double heightCm;

  @HiveField(4)
  String gender; // male, female, other

  @HiveField(5)
  String fitnessLevel; // beginner, intermediate, advanced

  @HiveField(6)
  String strengthLevel; // weak, average, strong

  @HiveField(7)
  String primaryGoal; // muscle_gain, strength, fat_loss, athletic, general, recomposition

  @HiveField(8)
  List<String> availableEquipment;

  @HiveField(9)
  int workoutDaysPerWeek;

  @HiveField(10)
  String? activeWorkoutProgramId;

  @HiveField(11)
  DateTime createdAt;

  @HiveField(12)
  int workoutStreak;

  @HiveField(13)
  DateTime? lastWorkoutDate;

  @HiveField(14)
  double targetWeightKg;

  @HiveField(15)
  String? profileImagePath;

  @HiveField(16)
  bool onboardingCompleted;

  UserProfileModel({
    required this.name,
    required this.age,
    required this.weightKg,
    required this.heightCm,
    required this.gender,
    required this.fitnessLevel,
    required this.strengthLevel,
    required this.primaryGoal,
    required this.availableEquipment,
    required this.workoutDaysPerWeek,
    this.activeWorkoutProgramId,
    required this.createdAt,
    this.workoutStreak = 0,
    this.lastWorkoutDate,
    required this.targetWeightKg,
    this.profileImagePath,
    this.onboardingCompleted = false,
  });

  double get bmi => weightKg / ((heightCm / 100) * (heightCm / 100));

  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  // TDEE calculation (Mifflin-St Jeor)
  double get bmr {
    if (gender == 'male') {
      return 10 * weightKg + 6.25 * heightCm - 5 * age + 5;
    }
    return 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
  }

  double get tdee {
    double activityMultiplier;
    switch (workoutDaysPerWeek) {
      case 1:
      case 2:
        activityMultiplier = 1.375;
        break;
      case 3:
      case 4:
        activityMultiplier = 1.55;
        break;
      case 5:
      case 6:
        activityMultiplier = 1.725;
        break;
      default:
        activityMultiplier = 1.9;
    }
    return bmr * activityMultiplier;
  }

  // Macro calculations based on goal
  Map<String, double> get dailyMacros {
    double calories = tdee;
    double protein, carbs, fat;

    switch (primaryGoal) {
      case 'muscle_gain':
        calories = tdee + 300;
        protein = weightKg * 2.2;
        fat = (calories * 0.25) / 9;
        carbs = (calories - (protein * 4) - (fat * 9)) / 4;
        break;
      case 'fat_loss':
        calories = tdee - 400;
        protein = weightKg * 2.4;
        fat = (calories * 0.30) / 9;
        carbs = (calories - (protein * 4) - (fat * 9)) / 4;
        break;
      case 'strength':
        calories = tdee + 200;
        protein = weightKg * 2.0;
        fat = (calories * 0.30) / 9;
        carbs = (calories - (protein * 4) - (fat * 9)) / 4;
        break;
      default:
        protein = weightKg * 1.8;
        fat = (calories * 0.28) / 9;
        carbs = (calories - (protein * 4) - (fat * 9)) / 4;
    }

    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  // Daily water intake recommendation (ml)
  double get dailyWaterMl {
    return weightKg * 35 + (workoutDaysPerWeek > 3 ? 500 : 0);
  }

  UserProfileModel copyWith({
    String? name,
    int? age,
    double? weightKg,
    double? heightCm,
    String? gender,
    String? fitnessLevel,
    String? strengthLevel,
    String? primaryGoal,
    List<String>? availableEquipment,
    int? workoutDaysPerWeek,
    String? activeWorkoutProgramId,
    DateTime? createdAt,
    int? workoutStreak,
    DateTime? lastWorkoutDate,
    double? targetWeightKg,
    String? profileImagePath,
    bool? onboardingCompleted,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      gender: gender ?? this.gender,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      strengthLevel: strengthLevel ?? this.strengthLevel,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      availableEquipment: availableEquipment ?? this.availableEquipment,
      workoutDaysPerWeek: workoutDaysPerWeek ?? this.workoutDaysPerWeek,
      activeWorkoutProgramId: activeWorkoutProgramId ?? this.activeWorkoutProgramId,
      createdAt: createdAt ?? this.createdAt,
      workoutStreak: workoutStreak ?? this.workoutStreak,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}
