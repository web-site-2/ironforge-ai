// lib/presentation/screens/onboarding/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/user_profile_model.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common/gradient_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  // Form data
  final _nameController = TextEditingController();
  int _age = 25;
  double _weight = 75;
  double _height = 175;
  String _gender = 'male';
  String _fitnessLevel = 'beginner';
  String _strengthLevel = 'average';
  String _goal = 'muscle_gain';
  List<String> _equipment = ['Full Gym'];
  int _daysPerWeek = 4;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finish() async {
    final profile = UserProfileModel(
      name: _nameController.text.isEmpty ? 'Athlete' : _nameController.text,
      age: _age,
      weightKg: _weight,
      heightCm: _height,
      gender: _gender,
      fitnessLevel: _fitnessLevel,
      strengthLevel: _strengthLevel,
      primaryGoal: _goal,
      availableEquipment: _equipment,
      workoutDaysPerWeek: _daysPerWeek,
      createdAt: DateTime.now(),
      targetWeightKg: _weight,
      onboardingCompleted: true,
    );
    await ref.read(userProfileProvider.notifier).save(profile);
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: List.generate(6, (i) => Expanded(
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: i <= _currentPage
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                )),
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _WelcomePage(nameController: _nameController),
                  _BodyPage(
                    age: _age, weight: _weight, height: _height, gender: _gender,
                    onAgeChanged: (v) => setState(() => _age = v),
                    onWeightChanged: (v) => setState(() => _weight = v),
                    onHeightChanged: (v) => setState(() => _height = v),
                    onGenderChanged: (v) => setState(() => _gender = v),
                  ),
                  _FitnessLevelPage(
                    selected: _fitnessLevel,
                    onChanged: (v) => setState(() => _fitnessLevel = v),
                  ),
                  _StrengthLevelPage(
                    selected: _strengthLevel,
                    onChanged: (v) => setState(() => _strengthLevel = v),
                  ),
                  _GoalPage(
                    selected: _goal,
                    onChanged: (v) => setState(() => _goal = v),
                  ),
                  _EquipmentPage(
                    selected: _equipment,
                    daysPerWeek: _daysPerWeek,
                    onEquipmentChanged: (v) => setState(() => _equipment = v),
                    onDaysChanged: (v) => setState(() => _daysPerWeek = v),
                  ),
                ],
              ),
            ),

            // Navigation
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: _prevPage,
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: GradientButton(
                      onPressed: _nextPage,
                      label: _currentPage == 5 ? 'START TRAINING' : 'CONTINUE',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  final TextEditingController nameController;
  const _WelcomePage({required this.nameController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          ShaderMask(
            shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
            child: const Text(
              'WELCOME TO\nIRONFORGE AI',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 38,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.1,
                letterSpacing: 1,
              ),
            ),
          ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
          const SizedBox(height: 12),
          Text(
            'Your personal AI fitness coach. Let\'s build your profile.',
            style: Theme.of(context).textTheme.bodyLarge,
          ).animate(delay: 200.ms).fadeIn(),
          const SizedBox(height: 48),
          Text('What should we call you?',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: nameController,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 18),
            decoration: const InputDecoration(
              hintText: 'Your name',
              prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
            ),
            textCapitalization: TextCapitalization.words,
          ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2),
        ],
      ),
    );
  }
}

class _BodyPage extends StatelessWidget {
  final int age;
  final double weight, height;
  final String gender;
  final Function(int) onAgeChanged;
  final Function(double) onWeightChanged;
  final Function(double) onHeightChanged;
  final Function(String) onGenderChanged;

  const _BodyPage({
    required this.age, required this.weight, required this.height,
    required this.gender, required this.onAgeChanged,
    required this.onWeightChanged, required this.onHeightChanged,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('Your Body', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('We use this to calculate your nutrition and program.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),

          // Gender
          Text('Gender', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              _GenderChip(label: 'Male', icon: '♂', selected: gender == 'male',
                  onTap: () => onGenderChanged('male')),
              const SizedBox(width: 12),
              _GenderChip(label: 'Female', icon: '♀', selected: gender == 'female',
                  onTap: () => onGenderChanged('female')),
              const SizedBox(width: 12),
              _GenderChip(label: 'Other', icon: '⚧', selected: gender == 'other',
                  onTap: () => onGenderChanged('other')),
            ],
          ),

          const SizedBox(height: 28),
          _SliderField(
            label: 'Age',
            value: age.toDouble(),
            min: 15, max: 70, divisions: 55,
            displayValue: '$age years',
            onChanged: (v) => onAgeChanged(v.round()),
          ),
          const SizedBox(height: 20),
          _SliderField(
            label: 'Weight',
            value: weight,
            min: 40, max: 200, divisions: 160,
            displayValue: '${weight.toStringAsFixed(1)} kg',
            onChanged: onWeightChanged,
          ),
          const SizedBox(height: 20),
          _SliderField(
            label: 'Height',
            value: height,
            min: 140, max: 220, divisions: 80,
            displayValue: '${height.toStringAsFixed(0)} cm',
            onChanged: onHeightChanged,
          ),
        ],
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label, icon;
  final bool selected;
  final VoidCallback onTap;
  const _GenderChip({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected ? AppColors.primary.withOpacity(0.15) : AppColors.surfaceVariant,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 0.5,
            ),
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(
                fontFamily: 'Exo2', fontSize: 12, fontWeight: FontWeight.w600,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliderField extends StatelessWidget {
  final String label, displayValue;
  final double value, min, max;
  final int divisions;
  final Function(double) onChanged;
  const _SliderField({required this.label, required this.value, required this.min,
    required this.max, required this.divisions, required this.displayValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Text(displayValue, style: const TextStyle(
                fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w700,
                color: AppColors.primary,
              )),
            ),
          ],
        ),
        Slider(value: value, min: min, max: max, divisions: divisions, onChanged: onChanged),
      ],
    );
  }
}

class _FitnessLevelPage extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;
  const _FitnessLevelPage({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('Fitness Level', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('How long have you been training consistently?',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),
          _LevelCard(
            value: 'beginner', selected: selected, onTap: onChanged,
            title: 'Beginner', subtitle: 'Less than 1 year of consistent training',
            icon: '🌱', color: AppColors.success,
          ),
          const SizedBox(height: 12),
          _LevelCard(
            value: 'intermediate', selected: selected, onTap: onChanged,
            title: 'Intermediate', subtitle: '1-3 years of consistent training',
            icon: '💪', color: AppColors.warning,
          ),
          const SizedBox(height: 12),
          _LevelCard(
            value: 'advanced', selected: selected, onTap: onChanged,
            title: 'Advanced', subtitle: '3+ years of serious training',
            icon: '⚡', color: AppColors.error,
          ),
        ],
      ),
    );
  }
}

class _StrengthLevelPage extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;
  const _StrengthLevelPage({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('Current Strength', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('This calibrates your starting weights and volume.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),
          _LevelCard(
            value: 'weak', selected: selected, onTap: onChanged,
            title: 'Building Base',
            subtitle: 'Squat < 1x bodyweight, Bench < 0.75x bodyweight',
            icon: '🔰', color: AppColors.info,
          ),
          const SizedBox(height: 12),
          _LevelCard(
            value: 'average', selected: selected, onTap: onChanged,
            title: 'Average Strength',
            subtitle: 'Squat ~1.5x bodyweight, Bench ~1x bodyweight',
            icon: '⚖️', color: AppColors.warning,
          ),
          const SizedBox(height: 12),
          _LevelCard(
            value: 'strong', selected: selected, onTap: onChanged,
            title: 'Strong',
            subtitle: 'Squat 2x+ bodyweight, Bench 1.5x+ bodyweight',
            icon: '🏆', color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _GoalPage extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;
  const _GoalPage({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final goals = [
      {'value': 'muscle_gain', 'title': 'Build Muscle', 'subtitle': 'Maximize hypertrophy and size', 'icon': '💪'},
      {'value': 'strength', 'title': 'Gain Strength', 'subtitle': 'Increase your 1RM on big lifts', 'icon': '🏋️'},
      {'value': 'fat_loss', 'title': 'Lose Fat', 'subtitle': 'Burn fat while preserving muscle', 'icon': '🔥'},
      {'value': 'athletic', 'title': 'Athletic Performance', 'subtitle': 'Speed, power and conditioning', 'icon': '⚡'},
      {'value': 'general', 'title': 'General Fitness', 'subtitle': 'Get fit, healthy and active', 'icon': '🎯'},
      {'value': 'recomposition', 'title': 'Body Recomposition', 'subtitle': 'Build muscle and lose fat', 'icon': '⚖️'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('Primary Goal', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Your program will be designed around this goal.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          ...goals.map((g) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _LevelCard(
              value: g['value']!, selected: selected, onTap: onChanged,
              title: g['title']!, subtitle: g['subtitle']!,
              icon: g['icon']!, color: AppColors.primary,
            ),
          )),
        ],
      ),
    );
  }
}

class _EquipmentPage extends StatelessWidget {
  final List<String> selected;
  final int daysPerWeek;
  final Function(List<String>) onEquipmentChanged;
  final Function(int) onDaysChanged;

  const _EquipmentPage({required this.selected, required this.daysPerWeek,
    required this.onEquipmentChanged, required this.onDaysChanged});

  @override
  Widget build(BuildContext context) {
    final options = ['Full Gym', 'Home Gym', 'Dumbbells Only', 'Resistance Bands', 'Bodyweight Only'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('Equipment & Schedule', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('What equipment do you have access to?',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          ...options.map((opt) {
            final isSelected = selected.contains(opt);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () {
                  if (opt == 'Full Gym' || opt == 'Bodyweight Only') {
                    onEquipmentChanged([opt]);
                  } else {
                    final newList = List<String>.from(selected)
                      ..remove('Full Gym')
                      ..remove('Bodyweight Only');
                    if (isSelected) newList.remove(opt);
                    else newList.add(opt);
                    onEquipmentChanged(newList.isEmpty ? ['Full Gym'] : newList);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected ? AppColors.primary.withOpacity(0.12) : AppColors.surfaceVariant,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 1.5 : 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                          color: isSelected ? AppColors.primary : AppColors.textTertiary, size: 22),
                      const SizedBox(width: 12),
                      Text(opt, style: TextStyle(
                        fontFamily: 'Exo2', fontSize: 15, fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                      )),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 24),
          Text('Days Per Week', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (i) {
              final day = i + 1;
              final isSel = daysPerWeek == day;
              return GestureDetector(
                onTap: () => onDaysChanged(day),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSel ? AppColors.primary : AppColors.surfaceVariant,
                    border: Border.all(color: isSel ? AppColors.primary : AppColors.border),
                  ),
                  child: Center(child: Text('$day', style: TextStyle(
                    fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w700,
                    color: isSel ? Colors.black : AppColors.textSecondary,
                  ))),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final String value, selected, title, subtitle, icon;
  final Color color;
  final Function(String) onTap;

  const _LevelCard({required this.value, required this.selected, required this.title,
    required this.subtitle, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? color.withOpacity(0.12) : AppColors.surfaceVariant,
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(
                    fontFamily: 'Rajdhani', fontSize: 18, fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  )),
                  Text(subtitle, style: const TextStyle(
                    fontFamily: 'Exo2', fontSize: 12, color: AppColors.textTertiary,
                  )),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: color, size: 22),
          ],
        ),
      ),
    );
  }
}
