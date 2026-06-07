// lib/presentation/providers/app_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/exercise_model.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/models/workout_model.dart';
import '../../data/models/program_model.dart';
import '../../data/database/exercise_database.dart';
import '../../data/database/programs_database.dart';
import '../../data/repositories/workout_generator.dart';
import '../../core/constants/app_constants.dart';

// ─── USER PROFILE ─────────────────────────────────────────

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfileModel?>((ref) {
  return UserProfileNotifier();
});

class UserProfileNotifier extends StateNotifier<UserProfileModel?> {
  UserProfileNotifier() : super(null) {
    _load();
  }

  void _load() {
    final box = Hive.box<UserProfileModel>(AppConstants.userProfileBox);
    if (box.isNotEmpty) state = box.getAt(0);
  }

  Future<void> save(UserProfileModel profile) async {
    final box = Hive.box<UserProfileModel>(AppConstants.userProfileBox);
    await box.clear();
    await box.add(profile);
    state = profile;
  }

  Future<void> update(UserProfileModel profile) async {
    await save(profile);
  }

  Future<void> incrementStreak() async {
    if (state == null) return;
    final now = DateTime.now();
    final last = state!.lastWorkoutDate;
    int newStreak = state!.workoutStreak;

    if (last == null) {
      newStreak = 1;
    } else {
      final diff = now.difference(last).inDays;
      if (diff == 1) {
        newStreak++;
      } else if (diff > 1) {
        newStreak = 1;
      }
    }

    await update(state!.copyWith(
      workoutStreak: newStreak,
      lastWorkoutDate: now,
    ));
  }
}

// ─── EXERCISES ────────────────────────────────────────────

final exercisesProvider = Provider<List<ExerciseModel>>((ref) {
  return ExerciseDatabase.allExercises;
});

final exerciseSearchQueryProvider = StateProvider<String>((ref) => '');

final selectedMuscleGroupProvider = StateProvider<String?>((ref) => null);

final selectedDifficultyProvider = StateProvider<String?>((ref) => null);

final selectedEquipmentProvider = StateProvider<String?>((ref) => null);

final filteredExercisesProvider = Provider<List<ExerciseModel>>((ref) {
  final all = ref.watch(exercisesProvider);
  final query = ref.watch(exerciseSearchQueryProvider);
  final muscle = ref.watch(selectedMuscleGroupProvider);
  final difficulty = ref.watch(selectedDifficultyProvider);

  var filtered = all;

  if (query.isNotEmpty) {
    filtered = ExerciseDatabase.search(query);
  }

  if (muscle != null && muscle.isNotEmpty) {
    filtered = filtered
        .where((e) => e.targetMuscle.toLowerCase() == muscle.toLowerCase())
        .toList();
  }

  if (difficulty != null && difficulty.isNotEmpty) {
    filtered = filtered
        .where((e) => e.difficulty.toLowerCase() == difficulty.toLowerCase())
        .toList();
  }

  return filtered;
});

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier() : super([]) {
    _load();
  }

  void _load() {
    final box = Hive.box(AppConstants.favoritesBox);
    final stored = box.get('favorite_exercise_ids');
    if (stored != null) {
      state = List<String>.from(stored as List);
    }
  }

  Future<void> toggle(String exerciseId) async {
    final box = Hive.box(AppConstants.favoritesBox);
    if (state.contains(exerciseId)) {
      state = state.where((id) => id != exerciseId).toList();
    } else {
      state = [...state, exerciseId];
    }
    await box.put('favorite_exercise_ids', state);
  }

  bool isFavorite(String exerciseId) => state.contains(exerciseId);
}

// ─── WORKOUTS ─────────────────────────────────────────────

final workoutLogsProvider =
    StateNotifierProvider<WorkoutLogsNotifier, List<WorkoutLogModel>>((ref) {
  return WorkoutLogsNotifier();
});

class WorkoutLogsNotifier extends StateNotifier<List<WorkoutLogModel>> {
  WorkoutLogsNotifier() : super([]) {
    _load();
  }

  void _load() {
    final box = Hive.box<WorkoutLogModel>(AppConstants.workoutLogsBox);
    state = box.values.toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  Future<void> addLog(WorkoutLogModel log) async {
    final box = Hive.box<WorkoutLogModel>(AppConstants.workoutLogsBox);
    await box.add(log);
    state = [log, ...state];
  }

  List<WorkoutLogModel> getRecentLogs({int limit = 10}) {
    return state.take(limit).toList();
  }

  List<WorkoutLogModel> getLogsForWeek(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    return state
        .where((log) =>
            log.startTime.isAfter(weekStart) &&
            log.startTime.isBefore(weekEnd))
        .toList();
  }

  Map<String, int> getWeeklyWorkoutCounts() {
    final now = DateTime.now();
    final result = <String, int>{};
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final key = '${day.month}/${day.day}';
      result[key] = state
          .where((log) =>
              log.startTime.year == day.year &&
              log.startTime.month == day.month &&
              log.startTime.day == day.day)
          .length;
    }
    return result;
  }
}

// ─── ACTIVE WORKOUT ───────────────────────────────────────

final activeWorkoutProvider =
    StateNotifierProvider<ActiveWorkoutNotifier, ActiveWorkoutState?>((ref) {
  return ActiveWorkoutNotifier(ref);
});

class ActiveWorkoutState {
  final WorkoutModel workout;
  final DateTime startTime;
  final int currentExerciseIndex;
  final int currentSetIndex;
  final bool isResting;
  final int restSecondsRemaining;
  final List<WorkoutExerciseModel> completedExercises;
  final bool isCompleted;

  ActiveWorkoutState({
    required this.workout,
    required this.startTime,
    this.currentExerciseIndex = 0,
    this.currentSetIndex = 0,
    this.isResting = false,
    this.restSecondsRemaining = 0,
    required this.completedExercises,
    this.isCompleted = false,
  });

  ActiveWorkoutState copyWith({
    WorkoutModel? workout,
    DateTime? startTime,
    int? currentExerciseIndex,
    int? currentSetIndex,
    bool? isResting,
    int? restSecondsRemaining,
    List<WorkoutExerciseModel>? completedExercises,
    bool? isCompleted,
  }) {
    return ActiveWorkoutState(
      workout: workout ?? this.workout,
      startTime: startTime ?? this.startTime,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentSetIndex: currentSetIndex ?? this.currentSetIndex,
      isResting: isResting ?? this.isResting,
      restSecondsRemaining: restSecondsRemaining ?? this.restSecondsRemaining,
      completedExercises: completedExercises ?? this.completedExercises,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  double get progressPercent {
    final total = workout.exercises.fold(0, (s, e) => s + e.sets.length);
    if (total == 0) return 0;
    final done = completedExercises.fold(
        0, (s, e) => s + e.sets.where((set) => set.isCompleted).length);
    return done / total;
  }

  WorkoutExerciseModel? get currentExercise {
    if (currentExerciseIndex >= workout.exercises.length) return null;
    return workout.exercises[currentExerciseIndex];
  }
}

class ActiveWorkoutNotifier extends StateNotifier<ActiveWorkoutState?> {
  final Ref _ref;

  ActiveWorkoutNotifier(this._ref) : super(null);

  void startWorkout(WorkoutModel workout) {
    state = ActiveWorkoutState(
      workout: workout,
      startTime: DateTime.now(),
      completedExercises: [],
    );
  }

  void completeSet(int exerciseIndex, int setIndex, double weight, int reps) {
    if (state == null) return;
    final exercises = state!.workout.exercises.map((ex) => ex).toList();
    final exercise = exercises[exerciseIndex];
    final sets = exercise.sets.map((s) => s).toList();
    sets[setIndex] = sets[setIndex].copyWith(
      weight: weight,
      reps: reps,
      isCompleted: true,
    );
    exercises[exerciseIndex] = exercise.copyWith(sets: sets);

    final updatedWorkout = WorkoutModel(
      id: state!.workout.id,
      name: state!.workout.name,
      description: state!.workout.description,
      exercises: exercises,
      targetMuscleGroup: state!.workout.targetMuscleGroup,
      estimatedDurationMinutes: state!.workout.estimatedDurationMinutes,
      difficulty: state!.workout.difficulty,
      createdAt: state!.workout.createdAt,
      isCustom: state!.workout.isCustom,
    );

    state = state!.copyWith(
      workout: updatedWorkout,
      isResting: true,
      restSecondsRemaining: sets[setIndex].restSeconds,
    );
  }

  void decrementRest() {
    if (state == null || !state!.isResting) return;
    if (state!.restSecondsRemaining <= 1) {
      state = state!.copyWith(isResting: false, restSecondsRemaining: 0);
    } else {
      state = state!.copyWith(
          restSecondsRemaining: state!.restSecondsRemaining - 1);
    }
  }

  void skipRest() {
    if (state == null) return;
    state = state!.copyWith(isResting: false, restSecondsRemaining: 0);
  }

  void nextExercise() {
    if (state == null) return;
    final nextIndex = state!.currentExerciseIndex + 1;
    if (nextIndex >= state!.workout.exercises.length) {
      finishWorkout();
    } else {
      state = state!.copyWith(
        currentExerciseIndex: nextIndex,
        currentSetIndex: 0,
      );
    }
  }

  Future<void> finishWorkout() async {
    if (state == null) return;
    final endTime = DateTime.now();
    final duration =
        endTime.difference(state!.startTime).inSeconds;

    double totalVolume = 0;
    int totalSets = 0;
    for (var ex in state!.workout.exercises) {
      for (var set in ex.sets) {
        if (set.isCompleted) {
          totalVolume += set.weight * set.reps;
          totalSets++;
        }
      }
    }

    final log = WorkoutLogModel(
      id: const Uuid().v4(),
      workoutId: state!.workout.id,
      workoutName: state!.workout.name,
      startTime: state!.startTime,
      endTime: endTime,
      exercises: state!.workout.exercises,
      totalVolume: totalVolume,
      totalSets: totalSets,
      durationSeconds: duration,
    );

    await _ref.read(workoutLogsProvider.notifier).addLog(log);
    await _ref.read(userProfileProvider.notifier).incrementStreak();
    await _checkPersonalRecords(state!.workout.exercises);

    state = state!.copyWith(isCompleted: true);
  }

  Future<void> _checkPersonalRecords(List<WorkoutExerciseModel> exercises) async {
    final box = Hive.box<PersonalRecordModel>(AppConstants.personalRecordsBox);
    for (var exercise in exercises) {
      for (var set in exercise.sets) {
        if (!set.isCompleted || set.weight <= 0) continue;
        final oneRM = PersonalRecordModel.calculateOneRM(set.weight, set.reps);
        final existing = box.values
            .where((pr) => pr.exerciseId == exercise.exerciseId)
            .toList();
        if (existing.isEmpty || existing.first.estimatedOneRM < oneRM) {
          final pr = PersonalRecordModel(
            exerciseId: exercise.exerciseId,
            exerciseName: exercise.exerciseName,
            weightKg: set.weight,
            reps: set.reps,
            achievedAt: DateTime.now(),
            estimatedOneRM: oneRM,
          );
          if (existing.isNotEmpty) {
            await existing.first.delete();
          }
          await box.add(pr);
        }
      }
    }
    _ref.invalidate(personalRecordsProvider);
  }

  void cancelWorkout() {
    state = null;
  }
}

// ─── PERSONAL RECORDS ─────────────────────────────────────

final personalRecordsProvider =
    StateNotifierProvider<PersonalRecordsNotifier, List<PersonalRecordModel>>(
        (ref) {
  return PersonalRecordsNotifier();
});

class PersonalRecordsNotifier extends StateNotifier<List<PersonalRecordModel>> {
  PersonalRecordsNotifier() : super([]) {
    _load();
  }

  void _load() {
    final box = Hive.box<PersonalRecordModel>(AppConstants.personalRecordsBox);
    state = box.values.toList()
      ..sort((a, b) => b.achievedAt.compareTo(a.achievedAt));
  }

  PersonalRecordModel? getForExercise(String exerciseId) {
    try {
      return state.firstWhere((pr) => pr.exerciseId == exerciseId);
    } catch (_) {
      return null;
    }
  }
}

// ─── BODY MEASUREMENTS ────────────────────────────────────

final bodyMeasurementsProvider =
    StateNotifierProvider<BodyMeasurementsNotifier, List<BodyMeasurementModel>>(
        (ref) {
  return BodyMeasurementsNotifier();
});

class BodyMeasurementsNotifier extends StateNotifier<List<BodyMeasurementModel>> {
  BodyMeasurementsNotifier() : super([]) {
    _load();
  }

  void _load() {
    final box =
        Hive.box<BodyMeasurementModel>(AppConstants.bodyMeasurementsBox);
    state = box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addMeasurement(BodyMeasurementModel measurement) async {
    final box =
        Hive.box<BodyMeasurementModel>(AppConstants.bodyMeasurementsBox);
    await box.add(measurement);
    state = [measurement, ...state];
  }

  List<Map<String, dynamic>> getWeightHistory() {
    return state.reversed
        .map((m) => {
              'date': m.date,
              'weight': m.weightKg,
            })
        .toList();
  }
}

// ─── PROGRAMS ─────────────────────────────────────────────

final programsProvider =
    StateNotifierProvider<ProgramsNotifier, List<ProgramModel>>((ref) {
  return ProgramsNotifier();
});

class ProgramsNotifier extends StateNotifier<List<ProgramModel>> {
  ProgramsNotifier() : super([]) {
    _load();
  }

  void _load() {
    final box = Hive.box<ProgramModel>(AppConstants.workoutsBox);
    final stored = box.values.toList();
    if (stored.isEmpty) {
      // Load from database defaults
      state = ProgramsDatabase.allPrograms;
    } else {
      state = stored;
    }
  }

  ProgramModel? get activeProgram {
    try {
      return state.firstWhere((p) => p.isActive);
    } catch (_) {
      return null;
    }
  }

  Future<void> activateProgram(String programId) async {
    state = state.map((p) {
      return ProgramModel(
        id: p.id,
        name: p.name,
        description: p.description,
        type: p.type,
        durationWeeks: p.durationWeeks,
        daysPerWeek: p.daysPerWeek,
        difficulty: p.difficulty,
        targetGoals: p.targetGoals,
        requiredEquipment: p.requiredEquipment,
        programDays: p.programDays,
        isCustom: p.isCustom,
        createdAt: p.createdAt,
        isActive: p.id == programId,
        currentWeek: p.currentWeek,
        currentDay: p.currentDay,
        imageAsset: p.imageAsset,
        keyFeatures: p.keyFeatures,
        fitnessLevel: p.fitnessLevel,
      );
    }).toList();
  }
}

// ─── RECOVERY STATUS ──────────────────────────────────────

final recoveryStatusProvider =
    Provider<Map<String, RecoveryStatus>>((ref) {
  final logs = ref.watch(workoutLogsProvider);
  final now = DateTime.now();
  final result = <String, RecoveryStatus>{};

  final muscleGroups = [
    'Chest', 'Back', 'Shoulders', 'Biceps',
    'Triceps', 'Legs', 'Abs', 'Glutes'
  ];

  for (var muscle in muscleGroups) {
    final lastWorkout = logs.where((log) {
      return log.exercises
          .any((ex) => ExerciseDatabase.getById(ex.exerciseId)?.targetMuscle == muscle);
    }).firstOrNull;

    if (lastWorkout == null) {
      result[muscle] = RecoveryStatus.recovered;
    } else {
      final hoursSince = now.difference(lastWorkout.startTime).inHours;
      if (hoursSince < 24) {
        result[muscle] = RecoveryStatus.needsRest;
      } else if (hoursSince < 48) {
        result[muscle] = RecoveryStatus.partiallyRecovered;
      } else {
        result[muscle] = RecoveryStatus.recovered;
      }
    }
  }

  return result;
});

enum RecoveryStatus { recovered, partiallyRecovered, needsRest }

extension RecoveryStatusExtension on RecoveryStatus {
  String get label {
    switch (this) {
      case RecoveryStatus.recovered: return 'Recovered';
      case RecoveryStatus.partiallyRecovered: return 'Partial';
      case RecoveryStatus.needsRest: return 'Needs Rest';
    }
  }

  String get emoji {
    switch (this) {
      case RecoveryStatus.recovered: return '✅';
      case RecoveryStatus.partiallyRecovered: return '🟡';
      case RecoveryStatus.needsRest: return '🔴';
    }
  }
}

// ─── NUTRITION ────────────────────────────────────────────

final nutritionProvider =
    StateNotifierProvider<NutritionNotifier, NutritionState>((ref) {
  final profile = ref.watch(userProfileProvider);
  return NutritionNotifier(profile);
});

class NutritionState {
  final double targetCalories;
  final double targetProtein;
  final double targetCarbs;
  final double targetFat;
  final double targetWaterMl;
  final double consumedWaterMl;
  final Map<String, double> dailyLog;

  NutritionState({
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFat,
    required this.targetWaterMl,
    this.consumedWaterMl = 0,
    this.dailyLog = const {},
  });

  NutritionState copyWith({
    double? targetCalories,
    double? targetProtein,
    double? targetCarbs,
    double? targetFat,
    double? targetWaterMl,
    double? consumedWaterMl,
    Map<String, double>? dailyLog,
  }) {
    return NutritionState(
      targetCalories: targetCalories ?? this.targetCalories,
      targetProtein: targetProtein ?? this.targetProtein,
      targetCarbs: targetCarbs ?? this.targetCarbs,
      targetFat: targetFat ?? this.targetFat,
      targetWaterMl: targetWaterMl ?? this.targetWaterMl,
      consumedWaterMl: consumedWaterMl ?? this.consumedWaterMl,
      dailyLog: dailyLog ?? this.dailyLog,
    );
  }
}

class NutritionNotifier extends StateNotifier<NutritionState> {
  NutritionNotifier(UserProfileModel? profile)
      : super(_buildFromProfile(profile)) {
    _loadTodayWater();
  }

  static NutritionState _buildFromProfile(UserProfileModel? profile) {
    if (profile == null) {
      return NutritionState(
        targetCalories: 2000,
        targetProtein: 150,
        targetCarbs: 250,
        targetFat: 65,
        targetWaterMl: 2500,
      );
    }
    final macros = profile.dailyMacros;
    return NutritionState(
      targetCalories: macros['calories']!,
      targetProtein: macros['protein']!,
      targetCarbs: macros['carbs']!,
      targetFat: macros['fat']!,
      targetWaterMl: profile.dailyWaterMl,
    );
  }

  void _loadTodayWater() {
    final box = Hive.box(AppConstants.nutritionBox);
    final todayKey = _todayKey();
    final stored = box.get(todayKey);
    if (stored != null) {
      state = state.copyWith(consumedWaterMl: (stored as num).toDouble());
    }
  }

  String _todayKey() {
    final now = DateTime.now();
    return 'water_${now.year}_${now.month}_${now.day}';
  }

  Future<void> addWater(double ml) async {
    final box = Hive.box(AppConstants.nutritionBox);
    final newAmount = state.consumedWaterMl + ml;
    await box.put(_todayKey(), newAmount);
    state = state.copyWith(consumedWaterMl: newAmount);
  }

  Future<void> resetWater() async {
    final box = Hive.box(AppConstants.nutritionBox);
    await box.put(_todayKey(), 0.0);
    state = state.copyWith(consumedWaterMl: 0);
  }
}

// ─── REST TIMER ───────────────────────────────────────────

final restTimerProvider =
    StateNotifierProvider<RestTimerNotifier, RestTimerState>((ref) {
  return RestTimerNotifier();
});

class RestTimerState {
  final bool isActive;
  final int totalSeconds;
  final int remainingSeconds;

  RestTimerState({
    this.isActive = false,
    this.totalSeconds = 90,
    this.remainingSeconds = 90,
  });

  double get progress =>
      totalSeconds > 0 ? remainingSeconds / totalSeconds : 0;

  RestTimerState copyWith({
    bool? isActive,
    int? totalSeconds,
    int? remainingSeconds,
  }) {
    return RestTimerState(
      isActive: isActive ?? this.isActive,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }
}

class RestTimerNotifier extends StateNotifier<RestTimerState> {
  RestTimerNotifier() : super(RestTimerState());

  void start(int seconds) {
    state = RestTimerState(
      isActive: true,
      totalSeconds: seconds,
      remainingSeconds: seconds,
    );
  }

  void tick() {
    if (!state.isActive) return;
    if (state.remainingSeconds <= 1) {
      state = state.copyWith(isActive: false, remainingSeconds: 0);
    } else {
      state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
    }
  }

  void stop() {
    state = state.copyWith(isActive: false);
  }

  void addTime(int seconds) {
    state = state.copyWith(
      remainingSeconds: state.remainingSeconds + seconds,
      totalSeconds: state.totalSeconds + seconds,
    );
  }
}

// ─── ACHIEVEMENTS ─────────────────────────────────────────

final achievementsProvider = Provider<List<Achievement>>((ref) {
  final logs = ref.watch(workoutLogsProvider);
  final prs = ref.watch(personalRecordsProvider);
  final profile = ref.watch(userProfileProvider);

  return Achievement.computeAll(
    totalWorkouts: logs.length,
    streak: profile?.workoutStreak ?? 0,
    totalPRs: prs.length,
    totalVolume: logs.fold(0, (s, l) => s + l.totalVolume),
  );
});

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final double progress;
  final int requirement;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    required this.progress,
    required this.requirement,
  });

  static List<Achievement> computeAll({
    required int totalWorkouts,
    required int streak,
    required int totalPRs,
    required double totalVolume,
  }) {
    return [
      Achievement(
        id: 'first_workout',
        title: 'First Step',
        description: 'Complete your first workout',
        icon: '🏆',
        isUnlocked: totalWorkouts >= 1,
        progress: (totalWorkouts / 1).clamp(0.0, 1.0),
        requirement: 1,
      ),
      Achievement(
        id: '10_workouts',
        title: 'Getting Serious',
        description: 'Complete 10 workouts',
        icon: '💪',
        isUnlocked: totalWorkouts >= 10,
        progress: (totalWorkouts / 10).clamp(0.0, 1.0),
        requirement: 10,
      ),
      Achievement(
        id: '50_workouts',
        title: 'Dedicated',
        description: 'Complete 50 workouts',
        icon: '🔥',
        isUnlocked: totalWorkouts >= 50,
        progress: (totalWorkouts / 50).clamp(0.0, 1.0),
        requirement: 50,
      ),
      Achievement(
        id: '100_workouts',
        title: 'Iron Will',
        description: 'Complete 100 workouts',
        icon: '⚡',
        isUnlocked: totalWorkouts >= 100,
        progress: (totalWorkouts / 100).clamp(0.0, 1.0),
        requirement: 100,
      ),
      Achievement(
        id: '7_day_streak',
        title: '7-Day Streak',
        description: 'Train 7 days in a row',
        icon: '🗓️',
        isUnlocked: streak >= 7,
        progress: (streak / 7).clamp(0.0, 1.0),
        requirement: 7,
      ),
      Achievement(
        id: '30_day_streak',
        title: 'Unstoppable',
        description: 'Train 30 days in a row',
        icon: '🌟',
        isUnlocked: streak >= 30,
        progress: (streak / 30).clamp(0.0, 1.0),
        requirement: 30,
      ),
      Achievement(
        id: 'first_pr',
        title: 'New Record',
        description: 'Set your first personal record',
        icon: '🎯',
        isUnlocked: totalPRs >= 1,
        progress: (totalPRs / 1).clamp(0.0, 1.0),
        requirement: 1,
      ),
      Achievement(
        id: '10_prs',
        title: 'PR Machine',
        description: 'Set 10 personal records',
        icon: '🏅',
        isUnlocked: totalPRs >= 10,
        progress: (totalPRs / 10).clamp(0.0, 1.0),
        requirement: 10,
      ),
      Achievement(
        id: '10k_volume',
        title: '10K Club',
        description: 'Lift 10,000 kg total volume',
        icon: '🏋️',
        isUnlocked: totalVolume >= 10000,
        progress: (totalVolume / 10000).clamp(0.0, 1.0),
        requirement: 10000,
      ),
      Achievement(
        id: '100k_volume',
        title: 'Volume King',
        description: 'Lift 100,000 kg total volume',
        icon: '👑',
        isUnlocked: totalVolume >= 100000,
        progress: (totalVolume / 100000).clamp(0.0, 1.0),
        requirement: 100000,
      ),
    ];
  }
}
