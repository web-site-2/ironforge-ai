// lib/presentation/screens/programs/program_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/program_model.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common/gradient_button.dart';

class ProgramDetailScreen extends ConsumerWidget {
  final String programId;
  const ProgramDetailScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programs = ref.watch(programsProvider);
    final program = programs.where((p) => p.id == programId).firstOrNull;

    if (program == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: Text('Program not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _ProgramHeader(program: program),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats row
                Row(
                  children: [
                    Expanded(child: _StatBox('Duration', '${program.durationWeeks} weeks')),
                    const SizedBox(width: 10),
                    Expanded(child: _StatBox('Frequency', '${program.daysPerWeek}x / week')),
                    const SizedBox(width: 10),
                    Expanded(child: _StatBox('Level', program.fitnessLevel)),
                  ],
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 20),

                // Description
                Text('About This Program', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(program.description, style: const TextStyle(
                  fontFamily: 'Exo2', fontSize: 14, color: AppColors.textSecondary, height: 1.6,
                )).animate(delay: 150.ms).fadeIn(),

                const SizedBox(height: 20),

                // Key features
                Text('Key Features', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                ...program.keyFeatures.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(e.value, style: const TextStyle(
                        fontFamily: 'Exo2', fontSize: 14, color: AppColors.textSecondary,
                      ))),
                    ],
                  ).animate(delay: Duration(milliseconds: 200 + e.key * 50)).fadeIn(),
                )),

                const SizedBox(height: 20),

                // Equipment
                Text('Required Equipment', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: program.requiredEquipment.map((eq) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border, width: 0.5),
                    ),
                    child: Text(eq, style: const TextStyle(
                      fontFamily: 'Exo2', fontSize: 12, color: AppColors.textSecondary,
                    )),
                  )).toList(),
                ).animate(delay: 300.ms).fadeIn(),

                const SizedBox(height: 20),

                // Program schedule
                Text('Weekly Schedule', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                ...program.programDays.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _ScheduleRow(day: e.value, index: e.key)
                      .animate(delay: Duration(milliseconds: 350 + e.key * 40)).fadeIn(),
                )),

                const SizedBox(height: 24),

                // Goals
                Text('Training Goals', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: program.targetGoals.map((g) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Text(_goalLabel(g), style: const TextStyle(
                      fontFamily: 'Exo2', fontSize: 13, fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    )),
                  )).toList(),
                ).animate(delay: 400.ms).fadeIn(),
              ]),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: program.isActive
              ? OutlinedButton(
                  onPressed: () => ref.read(programsProvider.notifier).activateProgram(''),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: const Text('DEACTIVATE PROGRAM'),
                )
              : GradientButton(
                  onPressed: () async {
                    await ref.read(programsProvider.notifier).activateProgram(program.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${program.name} activated!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      context.pop();
                    }
                  },
                  label: 'START THIS PROGRAM',
                  icon: Icons.play_arrow_rounded,
                  height: 52,
                ),
        ),
      ),
    );
  }

  String _goalLabel(String g) {
    switch (g) {
      case 'muscle_gain': return '💪 Muscle Gain';
      case 'strength': return '🏋️ Strength';
      case 'fat_loss': return '🔥 Fat Loss';
      case 'athletic': return '⚡ Athletic';
      case 'general': return '🎯 General Fitness';
      case 'recomposition': return '⚖️ Recomposition';
      default: return g;
    }
  }
}

class _ProgramHeader extends StatelessWidget {
  final ProgramModel program;
  const _ProgramHeader({required this.program});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D2B22), Color(0xFF0A0A0A)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (program.isActive)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.circle, color: AppColors.primary, size: 8),
                    SizedBox(width: 6),
                    Text('CURRENTLY ACTIVE', style: TextStyle(
                      fontFamily: 'Exo2', fontSize: 11, fontWeight: FontWeight.w700,
                      color: AppColors.primary, letterSpacing: 1,
                    )),
                  ],
                ),
              ),
            Text(program.name, style: const TextStyle(
              fontFamily: 'Rajdhani', fontSize: 28, fontWeight: FontWeight.w700,
              color: AppColors.textPrimary, height: 1.1,
            )),
            Text(program.type.replaceAll('_', ' ').toUpperCase(), style: const TextStyle(
              fontFamily: 'Exo2', fontSize: 12, color: AppColors.textTertiary, letterSpacing: 2,
            )),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  const _StatBox(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surfaceVariant,
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(
            fontFamily: 'Rajdhani', fontSize: 18, fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ), textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(
            fontFamily: 'Exo2', fontSize: 11, color: AppColors.textTertiary,
          ), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final ProgramDayModel day;
  final int index;
  const _ScheduleRow({required this.day, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: day.isCompleted ? AppColors.primary.withOpacity(0.06) : AppColors.surfaceVariant,
        border: Border.all(
          color: day.isCompleted ? AppColors.primary.withOpacity(0.3) : AppColors.border,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: day.isCompleted ? AppColors.primary : AppColors.border,
            ),
            child: Center(
              child: day.isCompleted
                  ? const Icon(Icons.check_rounded, color: Colors.black, size: 16)
                  : Text('${index + 1}', style: const TextStyle(
                      fontFamily: 'Rajdhani', fontSize: 14, fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(day.workoutName, style: const TextStyle(
                  fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                )),
                Text(day.muscleGroup, style: const TextStyle(
                  fontFamily: 'Exo2', fontSize: 12, color: AppColors.textTertiary,
                )),
              ],
            ),
          ),
          if (day.isCompleted)
            const Text('✅', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
