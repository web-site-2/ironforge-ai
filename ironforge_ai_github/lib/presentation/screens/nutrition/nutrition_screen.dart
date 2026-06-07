// lib/presentation/screens/nutrition/nutrition_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common/gradient_button.dart';

class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutrition = ref.watch(nutritionProvider);
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('NUTRITION'),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily calorie target card
            _CalorieRingCard(nutrition: nutrition)
                .animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 20),

            // Macro cards
            const SectionHeader(title: 'Daily Macros'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _MacroCard(
                  label: 'Protein',
                  amount: nutrition.targetProtein.round(),
                  unit: 'g',
                  color: AppColors.error,
                  icon: '🥩',
                  description: '${(nutrition.targetProtein * 4).round()} kcal',
                )),
                const SizedBox(width: 10),
                Expanded(child: _MacroCard(
                  label: 'Carbs',
                  amount: nutrition.targetCarbs.round(),
                  unit: 'g',
                  color: AppColors.warning,
                  icon: '🍚',
                  description: '${(nutrition.targetCarbs * 4).round()} kcal',
                )),
                const SizedBox(width: 10),
                Expanded(child: _MacroCard(
                  label: 'Fat',
                  amount: nutrition.targetFat.round(),
                  unit: 'g',
                  color: AppColors.secondary,
                  icon: '🥑',
                  description: '${(nutrition.targetFat * 9).round()} kcal',
                )),
              ],
            ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 20),

            // Water tracker
            const SectionHeader(title: 'Water Intake'),
            const SizedBox(height: 12),
            _WaterTrackerCard(nutrition: nutrition)
                .animate(delay: 300.ms).fadeIn(),

            const SizedBox(height: 20),

            // Protein calculator
            if (profile != null) ...[
              const SectionHeader(title: 'Protein Calculator'),
              const SizedBox(height: 12),
              _ProteinCalculatorCard(profile: profile)
                  .animate(delay: 400.ms).fadeIn(),
              const SizedBox(height: 20),
            ],

            // Nutrition tips
            const SectionHeader(title: 'Nutrition Guidelines'),
            const SizedBox(height: 12),
            _NutritionTipsCard(
              goal: profile?.primaryGoal ?? 'general',
            ).animate(delay: 500.ms).fadeIn(),

            const SizedBox(height: 20),

            // Meal timing
            const SectionHeader(title: 'Meal Timing'),
            const SizedBox(height: 12),
            _MealTimingCard().animate(delay: 600.ms).fadeIn(),
          ],
        ),
      ),
    );
  }
}

class _CalorieRingCard extends StatelessWidget {
  final NutritionState nutrition;
  const _CalorieRingCard({required this.nutrition});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          SizedBox(
            width: 100, height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100, height: 100,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 8,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(Colors.transparent),
                  ),
                ),
                SizedBox(
                  width: 100, height: 100,
                  child: CircularProgressIndicator(
                    value: 0.75,
                    strokeWidth: 8,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${nutrition.targetCalories.round()}',
                      style: const TextStyle(
                        fontFamily: 'Rajdhani', fontSize: 22, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text('kcal', style: TextStyle(
                      fontFamily: 'Exo2', fontSize: 11, color: AppColors.textTertiary,
                    )),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Daily Target', style: TextStyle(
                  fontFamily: 'Rajdhani', fontSize: 22, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                )),
                const SizedBox(height: 4),
                const Text('Based on your goal and activity level.', style: TextStyle(
                  fontFamily: 'Exo2', fontSize: 13, color: AppColors.textTertiary, height: 1.4,
                )),
                const SizedBox(height: 12),
                _MacroBar('P', nutrition.targetProtein, nutrition.targetProtein + nutrition.targetCarbs + nutrition.targetFat, AppColors.error),
                const SizedBox(height: 6),
                _MacroBar('C', nutrition.targetCarbs, nutrition.targetProtein + nutrition.targetCarbs + nutrition.targetFat, AppColors.warning),
                const SizedBox(height: 6),
                _MacroBar('F', nutrition.targetFat, nutrition.targetProtein + nutrition.targetCarbs + nutrition.targetFat, AppColors.secondary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final double value, total;
  final Color color;
  const _MacroBar(this.label, this.value, this.total, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 14, child: Text(label, style: TextStyle(
          fontFamily: 'Exo2', fontSize: 11, fontWeight: FontWeight.w700, color: color,
        ))),
        const SizedBox(width: 6),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: total > 0 ? (value / total).clamp(0.0, 1.0) : 0,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text('${value.round()}g', style: const TextStyle(
          fontFamily: 'Exo2', fontSize: 11, color: AppColors.textTertiary,
        )),
      ],
    );
  }
}

class _MacroCard extends StatelessWidget {
  final String label, unit, icon, description;
  final int amount;
  final Color color;

  const _MacroCard({
    required this.label, required this.amount, required this.unit,
    required this.color, required this.icon, required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              text: '$amount',
              style: TextStyle(fontFamily: 'Rajdhani', fontSize: 24, fontWeight: FontWeight.w700, color: color),
              children: [
                TextSpan(text: unit, style: const TextStyle(fontSize: 14, color: AppColors.textTertiary)),
              ],
            ),
          ),
          Text(label, style: const TextStyle(fontFamily: 'Exo2', fontSize: 12, color: AppColors.textSecondary)),
          Text(description, style: const TextStyle(fontFamily: 'Exo2', fontSize: 10, color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}

class _WaterTrackerCard extends ConsumerWidget {
  final NutritionState nutrition;
  const _WaterTrackerCard({required this.nutrition});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = (nutrition.consumedWaterMl / nutrition.targetWaterMl).clamp(0.0, 1.0);
    final remaining = (nutrition.targetWaterMl - nutrition.consumedWaterMl).clamp(0.0, double.infinity);

    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              const Text('💧', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(nutrition.consumedWaterMl / 1000).toStringAsFixed(1)} L',
                          style: const TextStyle(
                            fontFamily: 'Rajdhani', fontSize: 24, fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                        Text(
                          '/ ${(nutrition.targetWaterMl / 1000).toStringAsFixed(1)} L target',
                          style: const TextStyle(fontFamily: 'Exo2', fontSize: 12, color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      remaining > 0
                          ? '${(remaining / 1000).toStringAsFixed(1)} L remaining'
                          : '🎉 Daily goal reached!',
                      style: TextStyle(
                        fontFamily: 'Exo2', fontSize: 12,
                        color: remaining > 0 ? AppColors.textTertiary : AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Quick add buttons
          Row(
            children: [
              _WaterButton(ml: 150, ref: ref),
              const SizedBox(width: 8),
              _WaterButton(ml: 250, ref: ref),
              const SizedBox(width: 8),
              _WaterButton(ml: 500, ref: ref),
              const SizedBox(width: 8),
              _WaterButton(ml: 750, ref: ref),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.textTertiary, size: 20),
                onPressed: () => ref.read(nutritionProvider.notifier).resetWater(),
                tooltip: 'Reset',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaterButton extends StatelessWidget {
  final int ml;
  final WidgetRef ref;
  const _WaterButton({required this.ml, required this.ref});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ref.read(nutritionProvider.notifier).addWater(ml.toDouble()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.secondary.withOpacity(0.12),
          border: Border.all(color: AppColors.secondary.withOpacity(0.3), width: 0.5),
        ),
        child: Text(
          ml >= 1000 ? '${ml / 1000}L' : '${ml}ml',
          style: const TextStyle(
            fontFamily: 'Exo2', fontSize: 12, fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
      ),
    );
  }
}

class _ProteinCalculatorCard extends StatelessWidget {
  final dynamic profile;
  const _ProteinCalculatorCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final weight = profile.weightKg as double;
    final goal = profile.primaryGoal as String;

    double multiplier;
    String recommendation;

    switch (goal) {
      case 'muscle_gain':
        multiplier = 2.2;
        recommendation = 'For muscle building, aim for 2.0–2.4g per kg.';
        break;
      case 'fat_loss':
        multiplier = 2.4;
        recommendation = 'Higher protein preserves muscle during a cut.';
        break;
      case 'strength':
        multiplier = 2.0;
        recommendation = 'Strength training requires adequate protein for recovery.';
        break;
      default:
        multiplier = 1.8;
        recommendation = 'General fitness recommendation is 1.6–2.0g per kg.';
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🥩', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${(weight * multiplier).round()}g / day', style: const TextStyle(
                    fontFamily: 'Rajdhani', fontSize: 24, fontWeight: FontWeight.w700,
                    color: AppColors.error,
                  )),
                  Text('${multiplier}g × ${weight.toStringAsFixed(0)}kg bodyweight', style: const TextStyle(
                    fontFamily: 'Exo2', fontSize: 12, color: AppColors.textTertiary,
                  )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(recommendation, style: const TextStyle(
            fontFamily: 'Exo2', fontSize: 13, color: AppColors.textSecondary, height: 1.4,
          )),
          const SizedBox(height: 12),
          // Per meal breakdown
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.surfaceVariant,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ProteinMeal('Per meal (3)', (weight * multiplier / 3).round()),
                _ProteinMeal('Per meal (4)', (weight * multiplier / 4).round()),
                _ProteinMeal('Per meal (5)', (weight * multiplier / 5).round()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProteinMeal extends StatelessWidget {
  final String label;
  final int amount;
  const _ProteinMeal(this.label, this.amount);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${amount}g', style: const TextStyle(
          fontFamily: 'Rajdhani', fontSize: 18, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        )),
        Text(label, style: const TextStyle(
          fontFamily: 'Exo2', fontSize: 10, color: AppColors.textTertiary,
        )),
      ],
    );
  }
}

class _NutritionTipsCard extends StatelessWidget {
  final String goal;
  const _NutritionTipsCard({required this.goal});

  List<Map<String, String>> _getTips() {
    switch (goal) {
      case 'muscle_gain':
        return [
          {'icon': '🕐', 'tip': 'Eat within 1-2 hours post-workout to maximize recovery.'},
          {'icon': '🍽️', 'tip': 'Eat in a caloric surplus of 200-400 kcal above TDEE.'},
          {'icon': '🥛', 'tip': 'Prioritize complete protein sources at every meal.'},
          {'icon': '💤', 'tip': 'Quality sleep is when most muscle growth occurs.'},
        ];
      case 'fat_loss':
        return [
          {'icon': '📉', 'tip': 'Moderate deficit of 300-500 kcal for sustainable fat loss.'},
          {'icon': '🥩', 'tip': 'High protein preserves muscle mass during a cut.'},
          {'icon': '🥦', 'tip': 'Fill half your plate with vegetables for satiety.'},
          {'icon': '💧', 'tip': 'Often hunger signals are actually thirst — hydrate first.'},
        ];
      case 'strength':
        return [
          {'icon': '⚡', 'tip': 'Eat carbs before training for energy and performance.'},
          {'icon': '🔧', 'tip': 'Protein post-workout initiates muscle protein synthesis.'},
          {'icon': '🍌', 'tip': 'Simple carbs immediately pre-workout for quick energy.'},
          {'icon': '😴', 'tip': 'Strength peaks in the late afternoon — schedule training then.'},
        ];
      default:
        return [
          {'icon': '🎯', 'tip': 'Consistency beats perfection — stick to your targets most days.'},
          {'icon': '🥗', 'tip': 'Eat mostly whole, unprocessed foods.'},
          {'icon': '💧', 'tip': 'Staying hydrated improves performance and recovery.'},
          {'icon': '📏', 'tip': 'Track your food for at least 2 weeks to learn portions.'},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: _getTips().map((tip) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tip['icon']!, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(tip['tip']!, style: const TextStyle(
                  fontFamily: 'Exo2', fontSize: 13, color: AppColors.textSecondary, height: 1.4,
                )),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

class _MealTimingCard extends StatelessWidget {
  const _MealTimingCard();

  @override
  Widget build(BuildContext context) {
    final meals = [
      {'time': 'Wake up', 'advice': 'Hydrate first. Wait 30-60 min before eating.', 'icon': '☀️'},
      {'time': 'Breakfast', 'advice': 'High protein. Sets muscle protein synthesis for the day.', 'icon': '🍳'},
      {'time': 'Pre-Workout (1-2h before)', 'advice': 'Mixed meal with carbs and protein. Avoid heavy fat.', 'icon': '⚡'},
      {'time': 'Post-Workout (within 2h)', 'advice': 'Fast-digesting protein + carbs. Best anabolic window.', 'icon': '🔧'},
      {'time': 'Evening', 'advice': 'Casein protein or cottage cheese helps overnight recovery.', 'icon': '🌙'},
    ];

    return GlassCard(
      child: Column(
        children: meals.map((m) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(m['icon']!, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m['time']!, style: const TextStyle(
                      fontFamily: 'Rajdhani', fontSize: 15, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )),
                    Text(m['advice']!, style: const TextStyle(
                      fontFamily: 'Exo2', fontSize: 12, color: AppColors.textTertiary, height: 1.4,
                    )),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }
}
