// lib/presentation/screens/exercises/exercises_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common/gradient_button.dart';
import '../../../data/models/exercise_model.dart';

class ExercisesScreen extends ConsumerStatefulWidget {
  const ExercisesScreen({super.key});

  @override
  ConsumerState<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends ConsumerState<ExercisesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = ref.watch(filteredExercisesProvider);
    final selectedMuscle = ref.watch(selectedMuscleGroupProvider);
    final query = ref.watch(exerciseSearchQueryProvider);

    final muscles = ['Chest', 'Back', 'Shoulders', 'Biceps', 'Triceps',
      'Forearms', 'Abs', 'Legs', 'Calves', 'Glutes', 'Full Body'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('EXERCISES'),
            floating: true,
            snap: true,
            backgroundColor: AppColors.background,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(108),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  children: [
                    // Search bar
                    TextField(
                      controller: _searchController,
                      onChanged: (v) => ref.read(exerciseSearchQueryProvider.notifier).state = v,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search exercises...',
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textTertiary),
                        suffixIcon: query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, color: AppColors.textTertiary),
                                onPressed: () {
                                  _searchController.clear();
                                  ref.read(exerciseSearchQueryProvider.notifier).state = '';
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Muscle filter
                    SizedBox(
                      height: 36,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          MuscleGroupChip(
                            muscle: 'All',
                            selected: selectedMuscle == null,
                            onTap: () => ref.read(selectedMuscleGroupProvider.notifier).state = null,
                          ),
                          const SizedBox(width: 8),
                          ...muscles.map((m) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: MuscleGroupChip(
                              muscle: m,
                              selected: selectedMuscle == m,
                              onTap: () => ref.read(selectedMuscleGroupProvider.notifier).state =
                                  selectedMuscle == m ? null : m,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (filtered.isEmpty)
            SliverFillRemaining(
              child: const EmptyState(
                emoji: '🔍',
                title: 'No exercises found',
                subtitle: 'Try a different search or filter.',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ExerciseCard(exercise: filtered[index])
                        .animate(delay: Duration(milliseconds: index * 30))
                        .fadeIn()
                        .slideY(begin: 0.05),
                  ),
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends ConsumerWidget {
  final ExerciseModel exercise;
  const _ExerciseCard({required this.exercise});

  Color _getMuscleColor() {
    switch (exercise.targetMuscle.toLowerCase()) {
      case 'chest': return AppColors.chest;
      case 'back': return AppColors.back;
      case 'shoulders': return AppColors.shoulders;
      case 'biceps': return AppColors.biceps;
      case 'triceps': return AppColors.triceps;
      case 'abs': return AppColors.abs;
      case 'legs': return AppColors.legs;
      case 'calves': return AppColors.calves;
      case 'glutes': return AppColors.glutes;
      case 'forearms': return AppColors.forearms;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _getMuscleColor();
    final isFav = ref.watch(favoritesProvider).contains(exercise.id);

    return GestureDetector(
      onTap: () => context.push('/exercises/${exercise.id}'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.card,
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            // Muscle color indicator
            Container(
              width: 4, height: 52,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            // Muscle icon
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  _getMuscleEmoji(exercise.targetMuscle),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise.name, style: const TextStyle(
                    fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  )),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _Pill(exercise.targetMuscle, color),
                      const SizedBox(width: 6),
                      _Pill(exercise.difficulty, _getDifficultyColor(exercise.difficulty)),
                      if (exercise.category == 'compound') ...[
                        const SizedBox(width: 6),
                        _Pill('Compound', AppColors.textTertiary),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isFav ? AppColors.error : AppColors.textTertiary,
                    size: 20,
                  ),
                  onPressed: () => ref.read(favoritesProvider.notifier).toggle(exercise.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(height: 4),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getMuscleEmoji(String muscle) {
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
      case 'forearms': return '🤜';
      default: return '⚡';
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner': return AppColors.success;
      case 'intermediate': return AppColors.warning;
      case 'advanced': return AppColors.error;
      default: return AppColors.textTertiary;
    }
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  const _Pill(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: TextStyle(
        fontFamily: 'Exo2', fontSize: 10, fontWeight: FontWeight.w600, color: color,
      )),
    );
  }
}
