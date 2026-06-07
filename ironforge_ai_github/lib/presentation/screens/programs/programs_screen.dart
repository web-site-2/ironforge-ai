// lib/presentation/screens/programs/programs_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/program_model.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common/gradient_button.dart';

class ProgramsScreen extends ConsumerWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programs = ref.watch(programsProvider);
    final activeProgram = programs.where((p) => p.isActive).firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('PROGRAMS'),
        backgroundColor: AppColors.background,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Active program banner
                if (activeProgram != null) ...[
                  _ActiveProgramCard(program: activeProgram),
                  const SizedBox(height: 24),
                ],

                // All programs
                const SectionHeader(title: 'All Programs'),
                const SizedBox(height: 12),

                ...programs.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _ProgramCard(program: entry.value)
                      .animate(delay: Duration(milliseconds: entry.key * 60))
                      .fadeIn()
                      .slideY(begin: 0.05),
                )),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveProgramCard extends ConsumerWidget {
  final ProgramModel program;
  const _ActiveProgramCard({required this.program});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedDays = program.programDays.where((d) => d.isCompleted).length;
    final totalDays = program.programDays.length;
    final progress = totalDays > 0 ? completedDays / totalDays : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D2B22), Color(0xFF0A1A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('ACTIVE PROGRAM', style: TextStyle(
                  fontFamily: 'Exo2', fontSize: 11, fontWeight: FontWeight.w600,
                  color: AppColors.primary, letterSpacing: 1,
                )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(program.name, style: const TextStyle(
            fontFamily: 'Rajdhani', fontSize: 24, fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          )),
          Text('Week ${program.currentWeek} of ${program.durationWeeks} · ${program.daysPerWeek} days/week',
              style: const TextStyle(fontFamily: 'Exo2', fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progress', style: const TextStyle(
                          fontFamily: 'Exo2', fontSize: 12, color: AppColors.textTertiary,
                        )),
                        Text('$completedDays/$totalDays days', style: const TextStyle(
                          fontFamily: 'Exo2', fontSize: 12, color: AppColors.primary,
                        )),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GradientButton(
            onPressed: () => context.go('/programs/${program.id}'),
            label: 'VIEW PROGRAM',
            height: 42,
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}

class _ProgramCard extends ConsumerWidget {
  final ProgramModel program;
  const _ProgramCard({required this.program});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = program.isActive;

    return GestureDetector(
      onTap: () => context.push('/programs/${program.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isActive ? AppColors.primary.withOpacity(0.06) : AppColors.card,
          border: Border.all(
            color: isActive ? AppColors.primary.withOpacity(0.4) : AppColors.border,
            width: isActive ? 1 : 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isActive)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: const [
                              Icon(Icons.circle, color: AppColors.primary, size: 8),
                              SizedBox(width: 6),
                              Text('ACTIVE', style: TextStyle(
                                fontFamily: 'Exo2', fontSize: 10, fontWeight: FontWeight.w700,
                                color: AppColors.primary, letterSpacing: 1.5,
                              )),
                            ],
                          ),
                        ),
                      Text(program.name, style: const TextStyle(
                        fontFamily: 'Rajdhani', fontSize: 20, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      )),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getDiffColor(program.difficulty).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(program.difficulty, style: TextStyle(
                    fontFamily: 'Exo2', fontSize: 11, fontWeight: FontWeight.w600,
                    color: _getDiffColor(program.difficulty),
                  )),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(program.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'Exo2', fontSize: 13, color: AppColors.textTertiary, height: 1.4)),
            const SizedBox(height: 12),
            Row(
              children: [
                _InfoChip(Icons.calendar_today_outlined, '${program.durationWeeks}w'),
                const SizedBox(width: 8),
                _InfoChip(Icons.repeat_rounded, '${program.daysPerWeek}x/week'),
                const SizedBox(width: 8),
                _InfoChip(Icons.person_outline_rounded, program.fitnessLevel),
                const Spacer(),
                ...program.targetGoals.take(1).map((g) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(_goalLabel(g), style: const TextStyle(
                    fontFamily: 'Exo2', fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600,
                  )),
                )),
              ],
            ),
            const SizedBox(height: 12),
            // Key features
            Wrap(
              spacing: 6, runSpacing: 6,
              children: program.keyFeatures.take(3).map((f) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Text(f, style: const TextStyle(
                  fontFamily: 'Exo2', fontSize: 10, color: AppColors.textSecondary,
                )),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDiffColor(String d) {
    switch (d.toLowerCase()) {
      case 'beginner': return AppColors.success;
      case 'intermediate': return AppColors.warning;
      default: return AppColors.error;
    }
  }

  String _goalLabel(String g) {
    switch (g) {
      case 'muscle_gain': return 'Muscle';
      case 'strength': return 'Strength';
      case 'fat_loss': return 'Fat Loss';
      case 'athletic': return 'Athletic';
      case 'general': return 'General';
      case 'recomposition': return 'Recomp';
      default: return g;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textTertiary),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(
          fontFamily: 'Exo2', fontSize: 12, color: AppColors.textTertiary,
        )),
      ],
    );
  }
}
