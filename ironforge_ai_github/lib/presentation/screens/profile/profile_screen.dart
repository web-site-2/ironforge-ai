// lib/presentation/screens/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common/gradient_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final achievements = ref.watch(achievementsProvider);
    final logs = ref.watch(workoutLogsProvider);

    if (profile == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final unlockedAchievements = achievements.where((a) => a.isUnlocked).toList();
    final totalVolume = logs.fold(0.0, (s, l) => s + l.totalVolume);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.background,
            title: const Text('PROFILE'),
            flexibleSpace: FlexibleSpaceBar(
              background: _ProfileHeader(profile: profile),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats overview
                Row(
                  children: [
                    Expanded(child: StatCard(
                      label: 'Workouts',
                      value: '${logs.length}',
                      icon: Icons.fitness_center_rounded,
                      color: AppColors.primary,
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: StatCard(
                      label: 'Total Volume',
                      value: '${(totalVolume / 1000).toStringAsFixed(0)}',
                      unit: 'tons',
                      icon: Icons.bar_chart_rounded,
                      color: AppColors.secondary,
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: StatCard(
                      label: 'Best Streak',
                      value: '${profile.workoutStreak}',
                      unit: 'days',
                      icon: Icons.local_fire_department_rounded,
                      color: AppColors.error,
                    )),
                  ],
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 20),

                // Profile details
                const SectionHeader(title: 'Profile Details'),
                const SizedBox(height: 12),
                _ProfileDetailsCard(profile: profile)
                    .animate(delay: 200.ms).fadeIn(),

                const SizedBox(height: 20),

                // Achievements
                SectionHeader(
                  title: 'Achievements',
                  actionLabel: '${unlockedAchievements.length}/${achievements.length}',
                ),
                const SizedBox(height: 12),
                _AchievementsSection(achievements: achievements)
                    .animate(delay: 300.ms).fadeIn(),

                const SizedBox(height: 20),

                // Edit profile button
                GradientButton(
                  onPressed: () => _showEditProfileSheet(context, ref, profile),
                  label: 'EDIT PROFILE',
                  icon: Icons.edit_rounded,
                ).animate(delay: 400.ms).fadeIn(),

                const SizedBox(height: 12),

                OutlinedButton(
                  onPressed: () => _confirmReset(context, ref),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('RESET ALL DATA'),
                ).animate(delay: 450.ms).fadeIn(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, WidgetRef ref, dynamic profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _EditProfileSheet(profile: profile),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Reset All Data?', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 20, fontWeight: FontWeight.w700)),
        content: const Text('This will delete all your workouts, records, and progress. This cannot be undone.', style: TextStyle(fontFamily: 'Exo2', color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('RESET', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final currentProfile = ref.read(userProfileProvider);
      if (currentProfile != null) {
        final updated = currentProfile.copyWith(onboardingCompleted: false);
        await ref.read(userProfileProvider.notifier).save(updated);
      }
      if (context.mounted) context.go('/onboarding');
    }
  }
}

class _ProfileHeader extends StatelessWidget {
  final dynamic profile;
  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D2B22), Color(0xFF0A0A0A)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 20, spreadRadius: 4),
              ],
            ),
            child: Center(
              child: Text(
                (profile.name as String).isNotEmpty ? (profile.name as String)[0].toUpperCase() : 'A',
                style: const TextStyle(
                  fontFamily: 'Rajdhani', fontSize: 36, fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(profile.name as String, style: const TextStyle(
            fontFamily: 'Rajdhani', fontSize: 24, fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          )),
          Text(
            '${_fitnessLevelLabel(profile.fitnessLevel as String)} · ${_goalLabel(profile.primaryGoal as String)}',
            style: const TextStyle(fontFamily: 'Exo2', fontSize: 13, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  String _fitnessLevelLabel(String l) {
    switch (l) {
      case 'beginner': return 'Beginner';
      case 'intermediate': return 'Intermediate';
      default: return 'Advanced';
    }
  }

  String _goalLabel(String g) {
    switch (g) {
      case 'muscle_gain': return 'Building Muscle';
      case 'strength': return 'Getting Stronger';
      case 'fat_loss': return 'Losing Fat';
      case 'athletic': return 'Athletic Performance';
      case 'general': return 'General Fitness';
      case 'recomposition': return 'Body Recomp';
      default: return g;
    }
  }
}

class _ProfileDetailsCard extends StatelessWidget {
  final dynamic profile;
  const _ProfileDetailsCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          _DetailRow('Age', '${profile.age} years'),
          const Divider(color: AppColors.border, height: 16),
          _DetailRow('Weight', '${profile.weightKg} kg'),
          const Divider(color: AppColors.border, height: 16),
          _DetailRow('Height', '${profile.heightCm} cm'),
          const Divider(color: AppColors.border, height: 16),
          _DetailRow('BMI', '${profile.bmi.toStringAsFixed(1)} (${profile.bmiCategory})'),
          const Divider(color: AppColors.border, height: 16),
          _DetailRow('Training Days', '${profile.workoutDaysPerWeek}x per week'),
          const Divider(color: AppColors.border, height: 16),
          _DetailRow('Equipment', (profile.availableEquipment as List<String>).join(', ')),
          const Divider(color: AppColors.border, height: 16),
          _DetailRow('TDEE', '${profile.tdee.round()} kcal/day'),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label, value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Exo2', fontSize: 14, color: AppColors.textTertiary)),
        Text(value, style: const TextStyle(
          fontFamily: 'Exo2', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
        )),
      ],
    );
  }
}

class _AchievementsSection extends StatelessWidget {
  final List<Achievement> achievements;
  const _AchievementsSection({required this.achievements});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.5,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: achievement.isUnlocked
                ? AppColors.warning.withOpacity(0.08)
                : AppColors.surfaceVariant,
            border: Border.all(
              color: achievement.isUnlocked
                  ? AppColors.warning.withOpacity(0.4)
                  : AppColors.border,
              width: achievement.isUnlocked ? 1 : 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(achievement.icon, style: TextStyle(
                    fontSize: 22,
                    color: achievement.isUnlocked ? null : const Color(0xFF404040),
                  )),
                  const Spacer(),
                  if (!achievement.isUnlocked)
                    const Icon(Icons.lock_outline_rounded, color: AppColors.textTertiary, size: 14),
                ],
              ),
              const Spacer(),
              Text(achievement.title, style: TextStyle(
                fontFamily: 'Rajdhani', fontSize: 14, fontWeight: FontWeight.w700,
                color: achievement.isUnlocked ? AppColors.textPrimary : AppColors.textTertiary,
              )),
              const SizedBox(height: 4),
              if (!achievement.isUnlocked)
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: achievement.progress,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation(
                      achievement.isUnlocked ? AppColors.warning : AppColors.textTertiary,
                    ),
                    minHeight: 3,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _EditProfileSheet extends ConsumerStatefulWidget {
  final dynamic profile;
  const _EditProfileSheet({required this.profile});

  @override
  ConsumerState<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<_EditProfileSheet> {
  late TextEditingController _nameController;
  late double _weight;
  late int _daysPerWeek;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name as String);
    _weight = widget.profile.weightKg as double;
    _daysPerWeek = widget.profile.workoutDaysPerWeek as int;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: AppColors.border, borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Edit Profile', style: TextStyle(
            fontFamily: 'Rajdhani', fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
          )),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Weight (kg)', style: TextStyle(fontFamily: 'Exo2', fontSize: 14, color: AppColors.textSecondary)),
              Text('${_weight.toStringAsFixed(1)} kg', style: const TextStyle(
                fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary,
              )),
            ],
          ),
          Slider(value: _weight, min: 40, max: 200, divisions: 160, onChanged: (v) => setState(() => _weight = v)),
          const SizedBox(height: 8),
          const Text('Training Days / Week', style: TextStyle(fontFamily: 'Exo2', fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (i) {
              final day = i + 1;
              final sel = _daysPerWeek == day;
              return GestureDetector(
                onTap: () => setState(() => _daysPerWeek = day),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: sel ? AppColors.primary : AppColors.surfaceVariant,
                    border: Border.all(color: sel ? AppColors.primary : AppColors.border),
                  ),
                  child: Center(child: Text('$day', style: TextStyle(
                    fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w700,
                    color: sel ? Colors.black : AppColors.textSecondary,
                  ))),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          GradientButton(
            onPressed: () async {
              final updated = widget.profile.copyWith(
                name: _nameController.text.isEmpty ? 'Athlete' : _nameController.text,
                weightKg: _weight,
                workoutDaysPerWeek: _daysPerWeek,
              );
              await ref.read(userProfileProvider.notifier).update(updated);
              if (context.mounted) Navigator.pop(context);
            },
            label: 'SAVE CHANGES',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
