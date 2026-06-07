// lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common/gradient_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final logs = ref.watch(workoutLogsProvider);
    final recovery = ref.watch(recoveryStatusProvider);
    final prs = ref.watch(personalRecordsProvider);

    final recentLogs = logs.take(3).toList();
    final weeklyCount = logs.where((log) { final weekAgo = DateTime.now().subtract(const Duration(days: 7)); return log.startTime.isAfter(weekAgo); }).length; // ignore: unused_local_variable


    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            snap: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: const TextStyle(
                      fontFamily: 'Exo2', fontSize: 13, color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    profile?.name ?? 'Athlete',
                    style: const TextStyle(
                      fontFamily: 'Rajdhani', fontSize: 24, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary, letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_fire_department_rounded,
                              color: AppColors.primary, size: 16),
                          const SizedBox(width: 4),
                          Text('${profile?.workoutStreak ?? 0}', style: const TextStyle(
                            fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Today's workout card
                _TodayWorkoutCard(profile: profile)
                    .animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

                const SizedBox(height: 20),

                // Stats row
                Row(
                  children: [
                    Expanded(child: StatCard(
                      label: 'This Week',
                      value: '$weeklyCount',
                      unit: 'workouts',
                      icon: Icons.calendar_today_rounded,
                      color: AppColors.primary,
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: StatCard(
                      label: 'Total PRs',
                      value: '${prs.length}',
                      unit: 'records',
                      icon: Icons.emoji_events_rounded,
                      color: AppColors.warning,
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: StatCard(
                      label: 'Streak',
                      value: '${profile?.workoutStreak ?? 0}',
                      unit: 'days',
                      icon: Icons.local_fire_department_rounded,
                      color: AppColors.error,
                    )),
                  ],
                ).animate(delay: 200.ms).fadeIn(),

                const SizedBox(height: 20),

                // Recovery status
                const SectionHeader(title: 'Recovery Status'),
                const SizedBox(height: 12),
                _RecoveryGrid(recovery: recovery)
                    .animate(delay: 300.ms).fadeIn(),

                const SizedBox(height: 20),

                // Nutrition quick view
                if (profile != null) ...[
                  const SectionHeader(title: 'Daily Nutrition'),
                  const SizedBox(height: 12),
                  _NutritionCard(profile: profile)
                      .animate(delay: 400.ms).fadeIn(),
                  const SizedBox(height: 20),
                ],

                // Recent workouts
                SectionHeader(
                  title: 'Recent Workouts',
                  actionLabel: 'See All',
                  onAction: () => context.go('/tracking'),
                ),
                const SizedBox(height: 12),
                if (recentLogs.isEmpty)
                  const EmptyState(
                    emoji: '🏋️',
                    title: 'No workouts yet',
                    subtitle: 'Start your first workout to see history here.',
                  )
                else
                  ...recentLogs.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _WorkoutLogCard(log: e.value),
                  ).animate(delay: Duration(milliseconds: 500 + e.key * 100)).fadeIn()),

                const SizedBox(height: 20),

                // Quick actions
                const SectionHeader(title: 'Quick Actions'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _QuickActionCard(
                      icon: Icons.add_rounded,
                      label: 'New Workout',
                      color: AppColors.primary,
                      onTap: () => context.go('/workout'),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _QuickActionCard(
                      icon: Icons.search_rounded,
                      label: 'Exercises',
                      color: AppColors.secondary,
                      onTap: () => context.go('/exercises'),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _QuickActionCard(
                      icon: Icons.calendar_month_rounded,
                      label: 'Programs',
                      color: AppColors.warning,
                      onTap: () => context.go('/programs'),
                    )),
                  ],
                ).animate(delay: 600.ms).fadeIn(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }
}

class _TodayWorkoutCard extends ConsumerWidget {
  final dynamic profile;
  const _TodayWorkoutCard({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programs = ref.watch(programsProvider);
    final activeProgram = programs.where((p) => p.isActive).firstOrNull;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D2B22), Color(0xFF0A1A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 0.5),
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
                child: Text(
                  DateFormat('EEE, MMM d').format(DateTime.now()),
                  style: const TextStyle(
                    fontFamily: 'Exo2', fontSize: 12, color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.play_circle_fill_rounded, color: AppColors.primary, size: 28),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            activeProgram != null
                ? activeProgram.programDays.firstOrNull?.workoutName ?? "Today's Workout"
                : "Today's Workout",
            style: const TextStyle(
              fontFamily: 'Rajdhani', fontSize: 24, fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            activeProgram != null
                ? activeProgram.name
                : 'Create or select a program to get started',
            style: const TextStyle(fontFamily: 'Exo2', fontSize: 13, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 16),
          GradientButton(
            onPressed: () => context.go('/workout'),
            label: 'START WORKOUT',
            icon: Icons.play_arrow_rounded,
            height: 46,
          ),
        ],
      ),
    );
  }
}

class _RecoveryGrid extends StatelessWidget {
  final Map<String, RecoveryStatus> recovery;
  const _RecoveryGrid({required this.recovery});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: recovery.entries.map((e) {
        final color = e.value == RecoveryStatus.recovered
            ? AppColors.success
            : e.value == RecoveryStatus.partiallyRecovered
                ? AppColors.warning
                : AppColors.error;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color.withOpacity(0.12),
            border: Border.all(color: color.withOpacity(0.3), width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(e.value.emoji, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 6),
              Text(e.key, style: TextStyle(
                fontFamily: 'Exo2', fontSize: 12, fontWeight: FontWeight.w600, color: color,
              )),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _NutritionCard extends ConsumerWidget {
  final dynamic profile;
  const _NutritionCard({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutrition = ref.watch(nutritionProvider);
    final waterProgress = nutrition.consumedWaterMl / nutrition.targetWaterMl;

    return GlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MacroItem('Calories', '${nutrition.targetCalories.round()}', 'kcal', AppColors.primary),
              _MacroItem('Protein', '${nutrition.targetProtein.round()}', 'g', AppColors.error),
              _MacroItem('Carbs', '${nutrition.targetCarbs.round()}', 'g', AppColors.warning),
              _MacroItem('Fat', '${nutrition.targetFat.round()}', 'g', AppColors.secondary),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.water_drop_rounded, color: AppColors.secondary, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: waterProgress.clamp(0.0, 1.0),
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(nutrition.consumedWaterMl / 1000).toStringAsFixed(1)}L / ${(nutrition.targetWaterMl / 1000).toStringAsFixed(1)}L',
                style: const TextStyle(fontFamily: 'Exo2', fontSize: 11, color: AppColors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label, value, unit;
  final Color color;
  const _MacroItem(this.label, this.value, this.unit, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(
          fontFamily: 'Rajdhani', fontSize: 20, fontWeight: FontWeight.w700, color: color,
        )),
        Text(unit, style: const TextStyle(
          fontFamily: 'Exo2', fontSize: 10, color: AppColors.textTertiary,
        )),
        Text(label, style: const TextStyle(
          fontFamily: 'Exo2', fontSize: 11, color: AppColors.textSecondary,
        )),
      ],
    );
  }
}

class _WorkoutLogCard extends StatelessWidget {
  final dynamic log;
  const _WorkoutLogCard({required this.log});

  @override
  Widget build(BuildContext context) {
    final duration = Duration(seconds: log.durationSeconds);
    return GlassCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fitness_center_rounded, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(log.workoutName, style: const TextStyle(
                  fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                )),
                Text(
                  '${DateFormat('MMM d').format(log.startTime)} · '
                  '${duration.inMinutes}min · '
                  '${log.totalSets} sets',
                  style: const TextStyle(fontFamily: 'Exo2', fontSize: 12, color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          Text(
            '${(log.totalVolume / 1000).toStringAsFixed(1)}t',
            style: const TextStyle(
              fontFamily: 'Rajdhani', fontSize: 18, fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.3), width: 0.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(
              fontFamily: 'Exo2', fontSize: 11, fontWeight: FontWeight.w600, color: color,
            ), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
