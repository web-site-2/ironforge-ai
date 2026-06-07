// lib/data/repositories/workout_generator.dart

import '../models/workout_model.dart';
import '../models/user_profile_model.dart';
import '../models/exercise_model.dart';
import '../database/exercise_database.dart';
import 'package:uuid/uuid.dart';

class WorkoutGenerator {
  static final _uuid = Uuid();

  static WorkoutModel generateWorkout({
    required UserProfileModel user,
    required String targetMuscleGroup,
    required String workoutName,
  }) {
    final exercises = _selectExercises(user, targetMuscleGroup);
    final estimatedDuration = _estimateDuration(exercises.length, user);

    return WorkoutModel(
      id: _uuid.v4(),
      name: workoutName,
      description: _generateDescription(targetMuscleGroup, user),
      exercises: exercises,
      targetMuscleGroup: targetMuscleGroup,
      estimatedDurationMinutes: estimatedDuration,
      difficulty: user.fitnessLevel,
      createdAt: DateTime.now(),
      isCustom: true,
    );
  }

  static List<WorkoutExerciseModel> _selectExercises(
      UserProfileModel user, String muscleGroup) {
    final allForMuscle = ExerciseDatabase.getByMuscleGroup(muscleGroup);
    final byEquipment = ExerciseDatabase.getByEquipment(user.availableEquipment);
    final filtered = allForMuscle
        .where((e) => byEquipment.any((b) => b.id == e.id))
        .toList();

    // If no equipment match, fall back to bodyweight
    final exercises = filtered.isEmpty ? allForMuscle.take(3).toList() : filtered;

    // Determine exercise count based on fitness level
    int compoundCount, isolationCount;
    switch (user.fitnessLevel) {
      case 'beginner':
        compoundCount = 2;
        isolationCount = 1;
        break;
      case 'advanced':
        compoundCount = 3;
        isolationCount = 3;
        break;
      default:
        compoundCount = 2;
        isolationCount = 2;
    }

    final compounds = exercises.where((e) => e.category == 'compound').toList();
    final isolations = exercises.where((e) => e.category == 'isolation').toList();

    final selected = <String>{};
    final result = <WorkoutExerciseModel>[];
    int orderIndex = 0;

    // Add compounds first
    for (var i = 0; i < compoundCount && i < compounds.length; i++) {
      if (selected.add(compounds[i].id)) {
        result.add(_buildExercise(compounds[i], user, orderIndex++));
      }
    }

    // Add isolations
    for (var i = 0; i < isolationCount && i < isolations.length; i++) {
      if (selected.add(isolations[i].id)) {
        result.add(_buildExercise(isolations[i], user, orderIndex++));
      }
    }

    // Fill remaining with any available
    for (var ex in exercises) {
      if (result.length >= (compoundCount + isolationCount)) break;
      if (selected.add(ex.id)) {
        result.add(_buildExercise(ex, user, orderIndex++));
      }
    }

    return result;
  }

  static WorkoutExerciseModel _buildExercise(
      ExerciseModel exercise, UserProfileModel user, int orderIndex) {
    final config = _getSetsAndReps(user, exercise.category);
    final sets = List.generate(
      config['sets'] as int,
      (i) => WorkoutSetModel(
        setNumber: i + 1,
        weight: _suggestWeight(user, exercise.name),
        reps: config['reps'] as int,
        restSeconds: config['rest'] as int,
        setType: i == 0 ? 'warmup' : 'normal',
      ),
    );
    return WorkoutExerciseModel(
      exerciseId: exercise.id,
      exerciseName: exercise.name,
      sets: sets,
      orderIndex: orderIndex,
    );
  }

  static Map<String, int> _getSetsAndReps(UserProfileModel user, String category) {
    final isCompound = category == 'compound';

    switch (user.primaryGoal) {
      case 'strength':
        return {
          'sets': user.strengthLevel == 'advanced' ? 5 : 4,
          'reps': isCompound ? 5 : 8,
          'rest': isCompound ? 180 : 120,
        };
      case 'fat_loss':
        return {
          'sets': 3,
          'reps': isCompound ? 15 : 20,
          'rest': 60,
        };
      case 'muscle_gain':
      default:
        int sets = 3;
        int reps = isCompound ? 8 : 12;
        int rest = isCompound ? 120 : 90;

        if (user.strengthLevel == 'strong') {
          sets = 4;
          reps = isCompound ? 6 : 10;
        } else if (user.strengthLevel == 'weak') {
          reps = isCompound ? 10 : 15;
        }

        return {'sets': sets, 'reps': reps, 'rest': rest};
    }
  }

  static double _suggestWeight(UserProfileModel user, String exerciseName) {
    // Suggest starting weight based on bodyweight and strength level
    final bw = user.weightKg;
    double multiplier;
    switch (user.strengthLevel) {
      case 'strong':
        multiplier = 0.8;
        break;
      case 'weak':
        multiplier = 0.3;
        break;
      default:
        multiplier = 0.5;
    }

    // Adjust per exercise type
    final lower = exerciseName.toLowerCase();
    if (lower.contains('squat')) return (bw * multiplier * 1.2).roundToDouble();
    if (lower.contains('deadlift')) return (bw * multiplier * 1.5).roundToDouble();
    if (lower.contains('bench') || lower.contains('press')) {
      return (bw * multiplier * 0.8).roundToDouble();
    }
    if (lower.contains('curl') || lower.contains('extension')) {
      return (bw * multiplier * 0.2).roundToDouble();
    }
    if (lower.contains('push') || lower.contains('bodyweight')) return 0;
    return (bw * multiplier * 0.5).roundToDouble();
  }

  static int _estimateDuration(int exerciseCount, UserProfileModel user) {
    final setsPerExercise = user.fitnessLevel == 'beginner' ? 3 : 4;
    final restPerSet = user.primaryGoal == 'fat_loss' ? 60 : 90;
    final timePerSet = 45; // seconds per set
    return ((exerciseCount * setsPerExercise * (timePerSet + restPerSet)) / 60)
        .round()
        .clamp(30, 120);
  }

  static String _generateDescription(String muscle, UserProfileModel user) {
    return 'A ${user.fitnessLevel} level $muscle workout tailored to your ${user.primaryGoal.replaceAll('_', ' ')} goal. '
        'Designed for ${user.workoutDaysPerWeek} training days per week with ${user.availableEquipment.join(", ")} equipment.';
  }

  // Generate a full weekly program
  static List<WorkoutModel> generateWeeklyPlan(UserProfileModel user) {
    final splits = _getSplitForUser(user);
    return splits.asMap().entries.map((entry) {
      final dayIndex = entry.key;
      final muscle = entry.value;
      return generateWorkout(
        user: user,
        targetMuscleGroup: muscle,
        workoutName: '${muscle} Day ${dayIndex + 1}',
      );
    }).toList();
  }

  static List<String> _getSplitForUser(UserProfileModel user) {
    switch (user.workoutDaysPerWeek) {
      case 1:
      case 2:
        return List.generate(user.workoutDaysPerWeek, (_) => 'Full Body');
      case 3:
        return ['Full Body', 'Full Body', 'Full Body'];
      case 4:
        return ['Chest', 'Back', 'Legs', 'Shoulders'];
      case 5:
        return ['Chest', 'Back', 'Legs', 'Shoulders', 'Arms'];
      case 6:
        return ['Chest', 'Back', 'Legs', 'Shoulders', 'Arms', 'Full Body'];
      default:
        return ['Full Body'];
    }
  }
}
