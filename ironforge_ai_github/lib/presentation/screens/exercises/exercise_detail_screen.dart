// lib/presentation/screens/exercises/exercise_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/database/exercise_database.dart';
import '../../../data/models/exercise_model.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common/gradient_button.dart';

class ExerciseDetailScreen extends ConsumerStatefulWidget {
  final String exerciseId;
  const ExerciseDetailScreen({super.key, required this.exerciseId});

  @override
  ConsumerState<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends ConsumerState<ExerciseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  YoutubePlayerController? _ytController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    final exercise = ExerciseDatabase.getById(widget.exerciseId);
    if (exercise?.youtubeVideoId != null) {
      _ytController = YoutubePlayerController(
        initialVideoId: exercise!.youtubeVideoId!,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ytController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercise = ExerciseDatabase.getById(widget.exerciseId);
    if (exercise == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(),
        body: const Center(child: Text('Exercise not found')),
      );
    }

    final isFav = ref.watch(favoritesProvider).contains(exercise.id);
    final alternatives = ExerciseDatabase.getAlternatives(exercise);

    Widget headerWidget = _ExerciseHeroImage(exercise: exercise);
    if (_ytController != null) {
      headerWidget = YoutubePlayer(
        controller: _ytController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.primary,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: _ytController != null ? 230 : 160,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_rounded, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                  child: Icon(
                    isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isFav ? AppColors.error : Colors.white, size: 20,
                  ),
                ),
                onPressed: () => ref.read(favoritesProvider.notifier).toggle(exercise.id),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(background: headerWidget),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise.name, style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.1,
                  )),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8, runSpacing: 6,
                    children: [
                      _Tag(exercise.targetMuscle, AppColors.primary),
                      _Tag(exercise.difficulty, _diffColor(exercise.difficulty)),
                      _Tag(exercise.category.toUpperCase(), AppColors.secondary),
                      ...exercise.equipment.take(2).map((e) => _Tag(e, AppColors.textTertiary)),
                    ],
                  ),
                  if (exercise.secondaryMuscles.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text('Also works: ${exercise.secondaryMuscles.join(', ')}',
                        style: const TextStyle(fontSize: 13, color: AppColors.textTertiary)),
                  ],
                  const SizedBox(height: 16),
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: const [Tab(text: 'HOW TO'), Tab(text: 'TIPS'), Tab(text: 'SAFETY'), Tab(text: 'ALTERNATIVES')],
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 520,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _InstructionsTab(exercise: exercise),
                    _TipsTab(exercise: exercise),
                    _SafetyTab(exercise: exercise),
                    _AlternativesTab(alternatives: alternatives),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: GradientButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Start a workout to add exercises!')),
            ),
            label: 'ADD TO WORKOUT',
            icon: Icons.add_rounded,
          ),
        ),
      ),
    );
  }

  Color _diffColor(String d) {
    switch (d.toLowerCase()) {
      case 'beginner': return AppColors.success;
      case 'intermediate': return AppColors.warning;
      default: return AppColors.error;
    }
  }
}

class _ExerciseHeroImage extends StatelessWidget {
  final ExerciseModel exercise;
  const _ExerciseHeroImage({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final color = _getMuscleColor(exercise.targetMuscle);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.3), AppColors.background],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Text(_getMuscleEmoji(exercise.targetMuscle), style: const TextStyle(fontSize: 72)),
          Text(exercise.targetMuscle, style: TextStyle(fontSize: 14, color: color.withOpacity(0.8))),
        ],
      ),
    );
  }

  Color _getMuscleColor(String m) {
    switch (m.toLowerCase()) {
      case 'chest': return AppColors.chest;
      case 'back': return AppColors.back;
      case 'shoulders': return AppColors.shoulders;
      case 'biceps': return AppColors.biceps;
      case 'triceps': return AppColors.triceps;
      case 'abs': return AppColors.abs;
      case 'legs': return AppColors.legs;
      default: return AppColors.primary;
    }
  }

  String _getMuscleEmoji(String m) {
    switch (m.toLowerCase()) {
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
}

class _InstructionsTab extends StatelessWidget {
  final ExerciseModel exercise;
  const _InstructionsTab({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...exercise.instructions.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: Center(child: Text('${e.key + 1}', style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black,
                  ))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(e.value, style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary, height: 1.5,
                ))),
              ],
            ),
          )),
          const SizedBox(height: 12),
          _InfoBox(icon: Icons.air_rounded, color: AppColors.secondary, title: 'BREATHING',
              content: exercise.breathingInstructions),
          const SizedBox(height: 10),
          _InfoBox(icon: Icons.lightbulb_outline_rounded, color: AppColors.primary, title: 'COACH NOTES',
              content: exercise.trainingNotes),
        ],
      ),
    );
  }
}

class _TipsTab extends StatelessWidget {
  final ExerciseModel exercise;
  const _TipsTab({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Common Mistakes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...exercise.commonMistakes.map((m) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(m, style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary, height: 1.4,
                ))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _SafetyTab extends StatelessWidget {
  final ExerciseModel exercise;
  const _SafetyTab({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Injury Prevention', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...exercise.injuryPreventionTips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.shield_outlined, color: AppColors.success, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(tip, style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary, height: 1.4,
                ))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _AlternativesTab extends StatelessWidget {
  final List<ExerciseModel> alternatives;
  const _AlternativesTab({required this.alternatives});

  @override
  Widget build(BuildContext context) {
    if (alternatives.isEmpty) {
      return const EmptyState(emoji: '🤷', title: 'No alternatives', subtitle: 'No similar exercises found.');
    }
    return SingleChildScrollView(
      child: Column(
        children: alternatives.map((alt) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () => context.push('/exercises/${alt.id}'),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.surfaceVariant,
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Row(
                children: [
                  Text(_emoji(alt.targetMuscle), style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alt.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      Text('${alt.targetMuscle} · ${alt.difficulty}', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                    ],
                  )),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                ],
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }

  String _emoji(String m) {
    switch (m.toLowerCase()) {
      case 'chest': return '🫀';
      case 'back': return '🦊';
      case 'shoulders': return '💎';
      case 'biceps': return '💪';
      default: return '⚡';
    }
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, content;
  const _InfoBox({required this.icon, required this.color, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color, letterSpacing: 1)),
          ]),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color.withOpacity(0.12),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
