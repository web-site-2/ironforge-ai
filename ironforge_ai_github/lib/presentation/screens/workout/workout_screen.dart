// lib/presentation/screens/workout/workout_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/database/exercise_database.dart';
import '../../../data/models/workout_model.dart';
import '../../../data/repositories/workout_generator.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common/gradient_button.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('WORKOUT'),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick start
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('QUICK START', style: TextStyle(
                    fontFamily: 'Rajdhani', fontSize: 13, fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary, letterSpacing: 2,
                  )),
                  const SizedBox(height: 8),
                  const Text('Start an empty workout', style: TextStyle(
                    fontFamily: 'Rajdhani', fontSize: 22, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  )),
                  const SizedBox(height: 4),
                  const Text('Add exercises and track your sets freely.',
                      style: TextStyle(fontFamily: 'Exo2', fontSize: 13, color: AppColors.textTertiary)),
                  const SizedBox(height: 16),
                  GradientButton(
                    onPressed: () {
                      final emptyWorkout = WorkoutModel(
                        id: const Uuid().v4(),
                        name: 'Quick Workout',
                        exercises: [],
                        targetMuscleGroup: 'Full Body',
                        estimatedDurationMinutes: 60,
                        difficulty: 'Intermediate',
                        createdAt: DateTime.now(),
                        isCustom: true,
                      );
                      ref.read(activeWorkoutProvider.notifier).startWorkout(emptyWorkout);
                      context.go('/workout/active');
                    },
                    label: 'START EMPTY WORKOUT',
                    icon: Icons.add_rounded,
                    height: 46,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 24),

            // AI Generate
            if (profile != null) ...[
              const SectionHeader(title: 'AI Generated Workouts'),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    'Chest', 'Back', 'Legs', 'Shoulders', 'Arms', 'Full Body',
                  ].asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _AIWorkoutCard(
                      muscle: e.value,
                      profile: profile,
                    ).animate(delay: Duration(milliseconds: 200 + e.key * 60)).fadeIn(),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Muscle group workouts
            const SectionHeader(title: 'By Muscle Group'),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                'Chest', 'Back', 'Legs', 'Shoulders', 'Biceps', 'Triceps',
                'Abs', 'Glutes', 'Calves', 'Full Body',
              ].asMap().entries.map((e) => _MuscleWorkoutCard(
                muscle: e.value,
                profile: profile,
              ).animate(delay: Duration(milliseconds: e.key * 50)).fadeIn()).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AIWorkoutCard extends ConsumerWidget {
  final String muscle;
  final dynamic profile;
  const _AIWorkoutCard({required this.muscle, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final workout = WorkoutGenerator.generateWorkout(
          user: profile,
          targetMuscleGroup: muscle,
          workoutName: '$muscle Workout · ${DateFormat('MMM d').format(DateTime.now())}',
        );
        ref.read(activeWorkoutProvider.notifier).startWorkout(workout);
        context.go('/workout/active');
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [AppColors.primary.withOpacity(0.2), AppColors.secondary.withOpacity(0.1)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 20),
            const Spacer(),
            Text(muscle, style: const TextStyle(
              fontFamily: 'Rajdhani', fontSize: 18, fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            )),
            Text('AI Generated', style: const TextStyle(
              fontFamily: 'Exo2', fontSize: 11, color: AppColors.primary,
            )),
          ],
        ),
      ),
    );
  }
}

class _MuscleWorkoutCard extends ConsumerWidget {
  final String muscle;
  final dynamic profile;
  const _MuscleWorkoutCard({required this.muscle, required this.profile});

  Color _getColor() {
    switch (muscle.toLowerCase()) {
      case 'chest': return AppColors.chest;
      case 'back': return AppColors.back;
      case 'shoulders': return AppColors.shoulders;
      case 'biceps': return AppColors.biceps;
      case 'triceps': return AppColors.triceps;
      case 'abs': return AppColors.abs;
      case 'legs': return AppColors.legs;
      case 'calves': return AppColors.calves;
      case 'glutes': return AppColors.glutes;
      default: return AppColors.primary;
    }
  }

  String _getEmoji() {
    switch (muscle.toLowerCase()) {
      case 'chest': return '🫀';
      case 'back': return '🦊';
      case 'shoulders': return '💎';
      case 'biceps': return '💪';
      case 'triceps': return '🦾';
      case 'abs': return '🔥';
      case 'legs': return '🦵';
      case 'calves': return '🦶';
      case 'glutes': return '🍑';
      default: return '⚡';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _getColor();
    final exerciseCount = ExerciseDatabase.getByMuscleGroup(muscle).length;

    return GestureDetector(
      onTap: () {
        if (profile != null) {
          final workout = WorkoutGenerator.generateWorkout(
            user: profile,
            targetMuscleGroup: muscle,
            workoutName: '$muscle Day',
          );
          ref.read(activeWorkoutProvider.notifier).startWorkout(workout);
          context.go('/workout/active');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: color.withOpacity(0.08),
          border: Border.all(color: color.withOpacity(0.3), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_getEmoji(), style: const TextStyle(fontSize: 28)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(muscle, style: TextStyle(
                  fontFamily: 'Rajdhani', fontSize: 18, fontWeight: FontWeight.w700, color: color,
                )),
                Text('$exerciseCount exercises', style: const TextStyle(
                  fontFamily: 'Exo2', fontSize: 11, color: AppColors.textTertiary,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
