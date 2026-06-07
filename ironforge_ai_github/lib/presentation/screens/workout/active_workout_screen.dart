// lib/presentation/screens/workout/active_workout_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/database/exercise_database.dart';
import '../../../data/models/workout_model.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common/gradient_button.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  Timer? _elapsedTimer;
  Timer? _restTimer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startElapsedTimer();
  }

  void _startElapsedTimer() {
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds++);
      // Also tick rest timer
      final active = ref.read(activeWorkoutProvider);
      if (active != null && active.isResting) {
        ref.read(activeWorkoutProvider.notifier).decrementRest();
      }
    });
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  String _formatElapsed() {
    final h = _elapsedSeconds ~/ 3600;
    final m = (_elapsedSeconds % 3600) ~/ 60;
    final s = _elapsedSeconds % 60;
    if (h > 0) return '${h}h ${m.toString().padLeft(2, '0')}m';
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final workoutState = ref.watch(activeWorkoutProvider);

    if (workoutState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/workout'));
      return const SizedBox.shrink();
    }

    if (workoutState.isCompleted) {
      return _WorkoutCompletedScreen(
        state: workoutState,
        duration: _elapsedSeconds,
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (await _confirmCancel(context)) {
          ref.read(activeWorkoutProvider.notifier).cancelWorkout();
          if (mounted) context.go('/workout');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: AppColors.background,
                  leading: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () async {
                      if (await _confirmCancel(context)) {
                        ref.read(activeWorkoutProvider.notifier).cancelWorkout();
                        context.go('/workout');
                      }
                    },
                  ),
                  title: Column(
                    children: [
                      Text(workoutState.workout.name, style: const TextStyle(
                        fontFamily: 'Rajdhani', fontSize: 18, fontWeight: FontWeight.w700,
                      )),
                      Text(_formatElapsed(), style: const TextStyle(
                        fontFamily: 'Exo2', fontSize: 12, color: AppColors.primary,
                      )),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => _finishWorkout(context, ref),
                      child: const Text('FINISH', style: TextStyle(
                        fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      )),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(6),
                    child: LinearProgressIndicator(
                      value: workoutState.progressPercent,
                      backgroundColor: AppColors.border,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      minHeight: 3,
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final exercise = workoutState.workout.exercises[index];
                        final isCurrent = index == workoutState.currentExerciseIndex;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _ExerciseCard(
                            exercise: exercise,
                            exerciseIndex: index,
                            isCurrent: isCurrent,
                            workoutState: workoutState,
                          ),
                        );
                      },
                      childCount: workoutState.workout.exercises.length,
                    ),
                  ),
                ),
              ],
            ),

            // Rest timer overlay
            if (workoutState.isResting)
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: _RestTimerBar(
                  state: workoutState,
                  onSkip: () => ref.read(activeWorkoutProvider.notifier).skipRest(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmCancel(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Cancel Workout?', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 20, fontWeight: FontWeight.w700)),
        content: const Text('Your progress will be lost.', style: TextStyle(fontFamily: 'Exo2', color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CONTINUE')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('CANCEL WORKOUT', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _finishWorkout(BuildContext context, WidgetRef ref) async {
    await ref.read(activeWorkoutProvider.notifier).finishWorkout();
  }
}

class _ExerciseCard extends ConsumerStatefulWidget {
  final WorkoutExerciseModel exercise;
  final int exerciseIndex;
  final bool isCurrent;
  final ActiveWorkoutState workoutState;

  const _ExerciseCard({
    required this.exercise,
    required this.exerciseIndex,
    required this.isCurrent,
    required this.workoutState,
  });

  @override
  ConsumerState<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends ConsumerState<_ExerciseCard> {
  final List<TextEditingController> _weightControllers = [];
  final List<TextEditingController> _repsControllers = [];

  @override
  void initState() {
    super.initState();
    for (var set in widget.exercise.sets) {
      _weightControllers.add(TextEditingController(text: set.weight > 0 ? set.weight.toStringAsFixed(1) : ''));
      _repsControllers.add(TextEditingController(text: '${set.reps}'));
    }
  }

  @override
  void dispose() {
    for (var c in _weightControllers) c.dispose();
    for (var c in _repsControllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exerciseData = ExerciseDatabase.getById(widget.exercise.exerciseId);
    final completedSets = widget.exercise.sets.where((s) => s.isCompleted).length;
    final totalSets = widget.exercise.sets.length;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: widget.isCurrent ? AppColors.card : AppColors.surface,
        border: Border.all(
          color: widget.isCurrent ? AppColors.primary.withOpacity(0.5) : AppColors.border,
          width: widget.isCurrent ? 1 : 0.5,
        ),
      ),
      child: Column(
        children: [
          // Exercise header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text(
                    '${widget.exerciseIndex + 1}',
                    style: const TextStyle(fontFamily: 'Rajdhani', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                  )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.exercise.exerciseName, style: const TextStyle(
                        fontFamily: 'Rajdhani', fontSize: 18, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      )),
                      Text('$completedSets / $totalSets sets done', style: const TextStyle(
                        fontFamily: 'Exo2', fontSize: 12, color: AppColors.textTertiary,
                      )),
                    ],
                  ),
                ),
                if (exerciseData != null)
                  IconButton(
                    icon: const Icon(Icons.info_outline_rounded, color: AppColors.textTertiary, size: 20),
                    onPressed: () => context.push('/exercises/${exerciseData.id}'),
                  ),
              ],
            ),
          ),

          // Set headers
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Row(
              children: const [
                SizedBox(width: 36, child: Text('SET', style: TextStyle(fontFamily: 'Exo2', fontSize: 10, color: AppColors.textTertiary, letterSpacing: 1))),
                SizedBox(width: 12),
                Expanded(child: Text('WEIGHT (kg)', style: TextStyle(fontFamily: 'Exo2', fontSize: 10, color: AppColors.textTertiary, letterSpacing: 1), textAlign: TextAlign.center)),
                SizedBox(width: 12),
                Expanded(child: Text('REPS', style: TextStyle(fontFamily: 'Exo2', fontSize: 10, color: AppColors.textTertiary, letterSpacing: 1), textAlign: TextAlign.center)),
                SizedBox(width: 12),
                SizedBox(width: 40),
              ],
            ),
          ),

          // Sets
          ...widget.exercise.sets.asMap().entries.map((entry) {
            final i = entry.key;
            final set = entry.value;
            return _SetRow(
              set: set,
              setIndex: i,
              exerciseIndex: widget.exerciseIndex,
              weightController: _weightControllers[i],
              repsController: _repsControllers[i],
              onComplete: (weight, reps) {
                HapticFeedback.lightImpact();
                ref.read(activeWorkoutProvider.notifier).completeSet(
                  widget.exerciseIndex, i, weight, reps,
                );
              },
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SetRow extends StatelessWidget {
  final WorkoutSetModel set;
  final int setIndex, exerciseIndex;
  final TextEditingController weightController, repsController;
  final Function(double weight, int reps) onComplete;

  const _SetRow({
    required this.set,
    required this.setIndex,
    required this.exerciseIndex,
    required this.weightController,
    required this.repsController,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: set.isCompleted ? AppColors.primary.withOpacity(0.08) : Colors.transparent,
      ),
      child: Row(
        children: [
          // Set number
          SizedBox(
            width: 36,
            child: Center(
              child: Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: set.isCompleted ? AppColors.primary : AppColors.surfaceVariant,
                ),
                child: Center(
                  child: set.isCompleted
                      ? const Icon(Icons.check_rounded, color: Colors.black, size: 16)
                      : Text('${setIndex + 1}', style: const TextStyle(
                          fontFamily: 'Rajdhani', fontSize: 14, fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        )),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Weight input
          Expanded(
            child: TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              enabled: !set.isCompleted,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Rajdhani', fontSize: 20, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 20),
                filled: true,
                fillColor: set.isCompleted ? Colors.transparent : AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text('×', style: TextStyle(color: AppColors.textTertiary, fontSize: 18)),
          const SizedBox(width: 8),
          // Reps input
          Expanded(
            child: TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              enabled: !set.isCompleted,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Rajdhani', fontSize: 20, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 20),
                filled: true,
                fillColor: set.isCompleted ? Colors.transparent : AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Complete button
          SizedBox(
            width: 40,
            child: set.isCompleted
                ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 28)
                : GestureDetector(
                    onTap: () {
                      final weight = double.tryParse(weightController.text) ?? 0;
                      final reps = int.tryParse(repsController.text) ?? 0;
                      if (reps > 0) onComplete(weight, reps);
                    },
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary, width: 1.5),
                      ),
                      child: const Icon(Icons.check_rounded, color: AppColors.primary, size: 20),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _RestTimerBar extends StatelessWidget {
  final ActiveWorkoutState state;
  final VoidCallback onSkip;

  const _RestTimerBar({required this.state, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    final progress = state.restSecondsRemaining / 
        (state.currentExercise?.sets.firstOrNull?.restSeconds ?? 90);
    
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.timer_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text('REST', style: TextStyle(
                fontFamily: 'Rajdhani', fontSize: 14, fontWeight: FontWeight.w600,
                color: AppColors.textTertiary, letterSpacing: 2,
              )),
              const Spacer(),
              Text(
                '${state.restSecondsRemaining}s',
                style: const TextStyle(
                  fontFamily: 'Rajdhani', fontSize: 28, fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onSkip,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary, width: 1),
                  ),
                  child: const Text('SKIP', style: TextStyle(
                    fontFamily: 'Rajdhani', fontSize: 14, fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 4,
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 1, duration: 300.ms, curve: Curves.easeOut);
  }
}

class _WorkoutCompletedScreen extends ConsumerWidget {
  final ActiveWorkoutState state;
  final int duration;

  const _WorkoutCompletedScreen({required this.state, required this.duration});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalVolume = state.workout.exercises.fold(0.0, (total, ex) =>
        total + ex.sets.fold(0.0, (s, set) => s + (set.isCompleted ? set.weight * set.reps : 0)));
    final completedSets = state.workout.exercises.fold(0, (total, ex) =>
        total + ex.sets.where((s) => s.isCompleted).length);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Text('🏆', style: const TextStyle(fontSize: 80))
                  .animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 16),
              const Text('WORKOUT COMPLETE!', style: TextStyle(
                fontFamily: 'Rajdhani', fontSize: 32, fontWeight: FontWeight.w700,
                color: AppColors.primary, letterSpacing: 2,
              )).animate(delay: 300.ms).fadeIn(),
              const SizedBox(height: 8),
              Text(state.workout.name, style: const TextStyle(
                fontFamily: 'Exo2', fontSize: 16, color: AppColors.textSecondary,
              )).animate(delay: 400.ms).fadeIn(),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem('Duration', '${duration ~/ 60}m', Icons.timer_outlined),
                  _StatItem('Volume', '${(totalVolume / 1000).toStringAsFixed(1)}t', Icons.fitness_center_rounded),
                  _StatItem('Sets', '$completedSets', Icons.repeat_rounded),
                ],
              ).animate(delay: 500.ms).fadeIn(),
              const Spacer(),
              GradientButton(
                onPressed: () {
                  ref.read(activeWorkoutProvider.notifier).cancelWorkout();
                  context.go('/home');
                },
                label: 'BACK TO HOME',
                height: 52,
              ).animate(delay: 600.ms).fadeIn(),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  ref.read(activeWorkoutProvider.notifier).cancelWorkout();
                  context.go('/tracking');
                },
                child: const Text('VIEW HISTORY'),
              ).animate(delay: 700.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StatItem(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(
          fontFamily: 'Rajdhani', fontSize: 24, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        )),
        Text(label, style: const TextStyle(
          fontFamily: 'Exo2', fontSize: 12, color: AppColors.textTertiary,
        )),
      ],
    );
  }
}
