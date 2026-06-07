// lib/data/database/programs_database.dart

import '../models/program_model.dart';

class ProgramsDatabase {
  static List<ProgramModel> get allPrograms => [
        _pushPullLegs,
        _upperLower,
        _beginnerProgram,
        _arnoldSplit,
        _fullBody,
        _powerlifting,
        _hypertrophyProgram,
        _intermediateProgram,
        _advancedProgram,
        _strengthProgram,
        _broSplit,
      ];

  static ProgramModel get _pushPullLegs => ProgramModel(
        id: 'prog_ppl',
        name: 'Push Pull Legs',
        description:
            'The most popular training split among intermediate lifters. Separates muscles by function — pushing muscles (chest, shoulders, triceps), pulling muscles (back, biceps), and legs. Allows for 2x frequency per muscle per week when run 6 days.',
        type: 'ppl',
        durationWeeks: 12,
        daysPerWeek: 6,
        difficulty: 'Intermediate',
        targetGoals: ['muscle_gain', 'strength'],
        requiredEquipment: ['Barbell', 'Dumbbells', 'Cable Machine'],
        keyFeatures: [
          '6-day training split',
          'Each muscle trained 2x per week',
          'Progressive overload built in',
          'Compound + isolation exercise balance',
          'Flexible — run 3 or 6 days',
        ],
        fitnessLevel: 'Intermediate',
        imageAsset: 'assets/images/ppl.png',
        createdAt: DateTime.now(),
        programDays: _generatePPLDays(),
      );

  static ProgramModel get _upperLower => ProgramModel(
        id: 'prog_upper_lower',
        name: 'Upper Lower Split',
        description:
            'A 4-day program that divides workouts into upper body and lower body days. Great for intermediates wanting higher frequency with adequate recovery. Each muscle group is hit twice per week.',
        type: 'upper_lower',
        durationWeeks: 8,
        daysPerWeek: 4,
        difficulty: 'Intermediate',
        targetGoals: ['muscle_gain', 'strength'],
        requiredEquipment: ['Barbell', 'Dumbbells'],
        keyFeatures: [
          '4-day training split',
          'Upper/Lower division',
          'High frequency per muscle group',
          'Both strength and hypertrophy days',
          'Ideal recovery structure',
        ],
        fitnessLevel: 'Intermediate',
        createdAt: DateTime.now(),
        programDays: _generateUpperLowerDays(),
      );

  static ProgramModel get _beginnerProgram => ProgramModel(
        id: 'prog_beginner',
        name: 'IronForge Beginner',
        description:
            'A proven 3-day full body program for beginners. Based on the principle that novices make their fastest gains with 3x weekly frequency per muscle group. Linear progression on all main lifts.',
        type: 'full_body',
        durationWeeks: 12,
        daysPerWeek: 3,
        difficulty: 'Beginner',
        targetGoals: ['general', 'muscle_gain', 'strength'],
        requiredEquipment: ['Barbell', 'Dumbbells', 'Bench'],
        keyFeatures: [
          '3-day full body',
          'Linear progression each session',
          'Teaches fundamental movement patterns',
          'All major muscle groups every workout',
          'Perfect for first 6-12 months',
        ],
        fitnessLevel: 'Beginner',
        createdAt: DateTime.now(),
        programDays: _generateBeginnerDays(),
      );

  static ProgramModel get _arnoldSplit => ProgramModel(
        id: 'prog_arnold',
        name: 'Arnold Split',
        description:
            'The training split made famous by Arnold Schwarzenegger. A 6-day split pairing chest/back, shoulders/arms, and legs. High volume bodybuilding approach for serious muscle building.',
        type: 'arnold',
        durationWeeks: 12,
        daysPerWeek: 6,
        difficulty: 'Advanced',
        targetGoals: ['muscle_gain'],
        requiredEquipment: ['Barbell', 'Dumbbells', 'Cable Machine', 'Machines'],
        keyFeatures: [
          '6-day Arnold split',
          'Chest & Back paired together',
          'Shoulders & Arms paired',
          'Very high volume',
          'Bodybuilding legend\'s approach',
        ],
        fitnessLevel: 'Advanced',
        createdAt: DateTime.now(),
        programDays: _generateArnoldDays(),
      );

  static ProgramModel get _fullBody => ProgramModel(
        id: 'prog_full_body',
        name: 'Full Body 3x',
        description:
            'Training the entire body every session, 3 times per week. Optimal for muscle growth due to high weekly frequency. Each major movement pattern is hit every session.',
        type: 'full_body',
        durationWeeks: 8,
        daysPerWeek: 3,
        difficulty: 'Beginner',
        targetGoals: ['general', 'muscle_gain'],
        requiredEquipment: ['Barbell', 'Dumbbells'],
        keyFeatures: [
          'Full body every session',
          '3x per week frequency',
          'High muscle protein synthesis frequency',
          'Time efficient',
          'Great for natural lifters',
        ],
        fitnessLevel: 'Beginner',
        createdAt: DateTime.now(),
        programDays: _generateFullBodyDays(),
      );

  static ProgramModel get _powerlifting => ProgramModel(
        id: 'prog_powerlifting',
        name: 'Powerlifting Base',
        description:
            'A beginner-intermediate powerlifting program focused on the three competition lifts: squat, bench press, and deadlift. Builds serious strength through linear and undulating periodization.',
        type: 'powerlifting',
        durationWeeks: 16,
        daysPerWeek: 4,
        difficulty: 'Intermediate',
        targetGoals: ['strength'],
        requiredEquipment: ['Barbell', 'Bench', 'Rack', 'Plates'],
        keyFeatures: [
          'Squat, Bench, Deadlift focused',
          'Linear periodization',
          'Competition prep structure',
          'Accessory work included',
          'Deload weeks built in',
        ],
        fitnessLevel: 'Intermediate',
        createdAt: DateTime.now(),
        programDays: _generatePowerliftingDays(),
      );

  static ProgramModel get _hypertrophyProgram => ProgramModel(
        id: 'prog_hypertrophy',
        name: 'Pure Hypertrophy',
        description:
            'A science-based hypertrophy program using the most effective rep ranges and training techniques for muscle growth. 8-12 reps, progressive overload, optimal muscle damage and metabolic stress.',
        type: 'hypertrophy',
        durationWeeks: 10,
        daysPerWeek: 5,
        difficulty: 'Intermediate',
        targetGoals: ['muscle_gain'],
        requiredEquipment: ['Barbell', 'Dumbbells', 'Cable Machine'],
        keyFeatures: [
          'Science-based hypertrophy',
          '5-day push/pull/legs variation',
          '8-12 rep ranges',
          'Progressive overload protocol',
          'Volume progression built in',
        ],
        fitnessLevel: 'Intermediate',
        createdAt: DateTime.now(),
        programDays: _generateHypertrophyDays(),
      );

  static ProgramModel get _intermediateProgram => ProgramModel(
        id: 'prog_intermediate',
        name: 'IronForge Intermediate',
        description:
            'For lifters past the beginner stage who need more volume and variation. Uses undulating periodization to continue making progress when linear gains have stalled.',
        type: 'intermediate',
        durationWeeks: 12,
        daysPerWeek: 4,
        difficulty: 'Intermediate',
        targetGoals: ['muscle_gain', 'strength'],
        requiredEquipment: ['Barbell', 'Dumbbells', 'Cable Machine'],
        keyFeatures: [
          'Undulating periodization',
          '4-day training split',
          'Variation to break plateaus',
          'Continued strength and size gains',
          'Deload protocol included',
        ],
        fitnessLevel: 'Intermediate',
        createdAt: DateTime.now(),
        programDays: _generateIntermediateDays(),
      );

  static ProgramModel get _advancedProgram => ProgramModel(
        id: 'prog_advanced',
        name: 'IronForge Advanced',
        description:
            'High volume, high frequency program for advanced lifters. Uses block periodization with accumulation, intensification, and realization phases for continued progress.',
        type: 'advanced',
        durationWeeks: 16,
        daysPerWeek: 5,
        difficulty: 'Advanced',
        targetGoals: ['muscle_gain', 'strength'],
        requiredEquipment: ['Barbell', 'Dumbbells', 'Cable Machine', 'Machines'],
        keyFeatures: [
          'Block periodization',
          'High volume accumulation phase',
          'Intensification phase',
          'Peak and realization weeks',
          'For experienced lifters only',
        ],
        fitnessLevel: 'Advanced',
        createdAt: DateTime.now(),
        programDays: _generateAdvancedDays(),
      );

  static ProgramModel get _strengthProgram => ProgramModel(
        id: 'prog_strength',
        name: '5x5 Strength',
        description:
            'Classic 5x5 strength program. 5 sets of 5 reps on the main compound movements. Linear progression adding weight every session. Simple, proven, and devastatingly effective.',
        type: 'strength',
        durationWeeks: 12,
        daysPerWeek: 3,
        difficulty: 'Beginner',
        targetGoals: ['strength', 'muscle_gain'],
        requiredEquipment: ['Barbell', 'Rack', 'Bench', 'Plates'],
        keyFeatures: [
          '5 sets x 5 reps per main lift',
          'Linear progression every session',
          '3-day full body',
          'Alternating A/B workouts',
          'Proven strength foundation',
        ],
        fitnessLevel: 'Beginner',
        createdAt: DateTime.now(),
        programDays: _generateStrengthDays(),
      );

  static ProgramModel get _broSplit => ProgramModel(
        id: 'prog_bro_split',
        name: 'Classic Bro Split',
        description:
            'One muscle group per day, five days per week. The classic bodybuilder split. Each muscle gets focused attention once per week with maximum volume. Great for advanced lifters with adequate recovery.',
        type: 'bro_split',
        durationWeeks: 8,
        daysPerWeek: 5,
        difficulty: 'Intermediate',
        targetGoals: ['muscle_gain'],
        requiredEquipment: ['Barbell', 'Dumbbells', 'Cable Machine'],
        keyFeatures: [
          'One muscle per day',
          'Maximum volume per muscle',
          '5-day split',
          'Classic bodybuilding approach',
          'Focused isolation work',
        ],
        fitnessLevel: 'Intermediate',
        createdAt: DateTime.now(),
        programDays: _generateBroSplitDays(),
      );

  // Program day generation helpers
  static List<ProgramDayModel> _generatePPLDays() {
    return [
      ProgramDayModel(weekNumber: 1, dayNumber: 1, workoutId: 'wk_push_a', workoutName: 'Push A (Chest Focus)', muscleGroup: 'Chest/Shoulders/Triceps'),
      ProgramDayModel(weekNumber: 1, dayNumber: 2, workoutId: 'wk_pull_a', workoutName: 'Pull A (Back Focus)', muscleGroup: 'Back/Biceps'),
      ProgramDayModel(weekNumber: 1, dayNumber: 3, workoutId: 'wk_legs_a', workoutName: 'Legs A (Quad Focus)', muscleGroup: 'Legs/Glutes'),
      ProgramDayModel(weekNumber: 1, dayNumber: 4, workoutId: 'wk_push_b', workoutName: 'Push B (Shoulder Focus)', muscleGroup: 'Shoulders/Chest/Triceps'),
      ProgramDayModel(weekNumber: 1, dayNumber: 5, workoutId: 'wk_pull_b', workoutName: 'Pull B (Lat Focus)', muscleGroup: 'Back/Biceps'),
      ProgramDayModel(weekNumber: 1, dayNumber: 6, workoutId: 'wk_legs_b', workoutName: 'Legs B (Ham/Glute Focus)', muscleGroup: 'Legs/Glutes'),
    ];
  }

  static List<ProgramDayModel> _generateUpperLowerDays() {
    return [
      ProgramDayModel(weekNumber: 1, dayNumber: 1, workoutId: 'wk_upper_strength', workoutName: 'Upper Strength', muscleGroup: 'Upper Body'),
      ProgramDayModel(weekNumber: 1, dayNumber: 2, workoutId: 'wk_lower_strength', workoutName: 'Lower Strength', muscleGroup: 'Lower Body'),
      ProgramDayModel(weekNumber: 1, dayNumber: 4, workoutId: 'wk_upper_hypertrophy', workoutName: 'Upper Hypertrophy', muscleGroup: 'Upper Body'),
      ProgramDayModel(weekNumber: 1, dayNumber: 5, workoutId: 'wk_lower_hypertrophy', workoutName: 'Lower Hypertrophy', muscleGroup: 'Lower Body'),
    ];
  }

  static List<ProgramDayModel> _generateBeginnerDays() {
    return [
      ProgramDayModel(weekNumber: 1, dayNumber: 1, workoutId: 'wk_beginner_a', workoutName: 'Workout A (Squat/Press/Row)', muscleGroup: 'Full Body'),
      ProgramDayModel(weekNumber: 1, dayNumber: 3, workoutId: 'wk_beginner_b', workoutName: 'Workout B (Squat/OHP/Deadlift)', muscleGroup: 'Full Body'),
      ProgramDayModel(weekNumber: 1, dayNumber: 5, workoutId: 'wk_beginner_a', workoutName: 'Workout A (Squat/Press/Row)', muscleGroup: 'Full Body'),
    ];
  }

  static List<ProgramDayModel> _generateArnoldDays() {
    return [
      ProgramDayModel(weekNumber: 1, dayNumber: 1, workoutId: 'wk_chest_back', workoutName: 'Chest & Back', muscleGroup: 'Chest/Back'),
      ProgramDayModel(weekNumber: 1, dayNumber: 2, workoutId: 'wk_shoulders_arms', workoutName: 'Shoulders & Arms', muscleGroup: 'Shoulders/Biceps/Triceps'),
      ProgramDayModel(weekNumber: 1, dayNumber: 3, workoutId: 'wk_legs_arnold', workoutName: 'Legs', muscleGroup: 'Legs'),
      ProgramDayModel(weekNumber: 1, dayNumber: 4, workoutId: 'wk_chest_back', workoutName: 'Chest & Back', muscleGroup: 'Chest/Back'),
      ProgramDayModel(weekNumber: 1, dayNumber: 5, workoutId: 'wk_shoulders_arms', workoutName: 'Shoulders & Arms', muscleGroup: 'Shoulders/Biceps/Triceps'),
      ProgramDayModel(weekNumber: 1, dayNumber: 6, workoutId: 'wk_legs_arnold', workoutName: 'Legs', muscleGroup: 'Legs'),
    ];
  }

  static List<ProgramDayModel> _generateFullBodyDays() {
    return [
      ProgramDayModel(weekNumber: 1, dayNumber: 1, workoutId: 'wk_fullbody_a', workoutName: 'Full Body A', muscleGroup: 'Full Body'),
      ProgramDayModel(weekNumber: 1, dayNumber: 3, workoutId: 'wk_fullbody_b', workoutName: 'Full Body B', muscleGroup: 'Full Body'),
      ProgramDayModel(weekNumber: 1, dayNumber: 5, workoutId: 'wk_fullbody_c', workoutName: 'Full Body C', muscleGroup: 'Full Body'),
    ];
  }

  static List<ProgramDayModel> _generatePowerliftingDays() {
    return [
      ProgramDayModel(weekNumber: 1, dayNumber: 1, workoutId: 'wk_squat_primary', workoutName: 'Squat Primary', muscleGroup: 'Legs/Back'),
      ProgramDayModel(weekNumber: 1, dayNumber: 2, workoutId: 'wk_bench_primary', workoutName: 'Bench Primary', muscleGroup: 'Chest/Triceps'),
      ProgramDayModel(weekNumber: 1, dayNumber: 4, workoutId: 'wk_deadlift_primary', workoutName: 'Deadlift Primary', muscleGroup: 'Back/Legs'),
      ProgramDayModel(weekNumber: 1, dayNumber: 5, workoutId: 'wk_overhead_accessories', workoutName: 'Overhead & Accessories', muscleGroup: 'Shoulders/Upper Back'),
    ];
  }

  static List<ProgramDayModel> _generateHypertrophyDays() {
    return [
      ProgramDayModel(weekNumber: 1, dayNumber: 1, workoutId: 'wk_chest_shoulders', workoutName: 'Chest & Shoulders', muscleGroup: 'Chest/Shoulders'),
      ProgramDayModel(weekNumber: 1, dayNumber: 2, workoutId: 'wk_back_bis', workoutName: 'Back & Biceps', muscleGroup: 'Back/Biceps'),
      ProgramDayModel(weekNumber: 1, dayNumber: 3, workoutId: 'wk_legs_hyp', workoutName: 'Legs', muscleGroup: 'Legs/Glutes'),
      ProgramDayModel(weekNumber: 1, dayNumber: 4, workoutId: 'wk_chest_tris', workoutName: 'Chest & Triceps', muscleGroup: 'Chest/Triceps'),
      ProgramDayModel(weekNumber: 1, dayNumber: 5, workoutId: 'wk_back_shoulders', workoutName: 'Back & Shoulders', muscleGroup: 'Back/Shoulders'),
    ];
  }

  static List<ProgramDayModel> _generateIntermediateDays() {
    return [
      ProgramDayModel(weekNumber: 1, dayNumber: 1, workoutId: 'wk_upper_a', workoutName: 'Upper A (Heavy)', muscleGroup: 'Upper Body'),
      ProgramDayModel(weekNumber: 1, dayNumber: 2, workoutId: 'wk_lower_a', workoutName: 'Lower A (Heavy)', muscleGroup: 'Lower Body'),
      ProgramDayModel(weekNumber: 1, dayNumber: 4, workoutId: 'wk_upper_b', workoutName: 'Upper B (Volume)', muscleGroup: 'Upper Body'),
      ProgramDayModel(weekNumber: 1, dayNumber: 5, workoutId: 'wk_lower_b', workoutName: 'Lower B (Volume)', muscleGroup: 'Lower Body'),
    ];
  }

  static List<ProgramDayModel> _generateAdvancedDays() {
    return [
      ProgramDayModel(weekNumber: 1, dayNumber: 1, workoutId: 'wk_adv_chest', workoutName: 'Chest (High Volume)', muscleGroup: 'Chest'),
      ProgramDayModel(weekNumber: 1, dayNumber: 2, workoutId: 'wk_adv_back', workoutName: 'Back (High Volume)', muscleGroup: 'Back'),
      ProgramDayModel(weekNumber: 1, dayNumber: 3, workoutId: 'wk_adv_legs', workoutName: 'Legs (High Volume)', muscleGroup: 'Legs'),
      ProgramDayModel(weekNumber: 1, dayNumber: 4, workoutId: 'wk_adv_shoulders', workoutName: 'Shoulders & Arms', muscleGroup: 'Shoulders/Arms'),
      ProgramDayModel(weekNumber: 1, dayNumber: 5, workoutId: 'wk_adv_fullbody', workoutName: 'Full Body Power', muscleGroup: 'Full Body'),
    ];
  }

  static List<ProgramDayModel> _generateStrengthDays() {
    return [
      ProgramDayModel(weekNumber: 1, dayNumber: 1, workoutId: 'wk_strength_a', workoutName: 'Workout A (Squat/Bench/Row)', muscleGroup: 'Full Body'),
      ProgramDayModel(weekNumber: 1, dayNumber: 3, workoutId: 'wk_strength_b', workoutName: 'Workout B (Squat/OHP/Deadlift)', muscleGroup: 'Full Body'),
      ProgramDayModel(weekNumber: 1, dayNumber: 5, workoutId: 'wk_strength_a', workoutName: 'Workout A (Squat/Bench/Row)', muscleGroup: 'Full Body'),
    ];
  }

  static List<ProgramDayModel> _generateBroSplitDays() {
    return [
      ProgramDayModel(weekNumber: 1, dayNumber: 1, workoutId: 'wk_bro_chest', workoutName: 'Chest Day', muscleGroup: 'Chest'),
      ProgramDayModel(weekNumber: 1, dayNumber: 2, workoutId: 'wk_bro_back', workoutName: 'Back Day', muscleGroup: 'Back'),
      ProgramDayModel(weekNumber: 1, dayNumber: 3, workoutId: 'wk_bro_shoulders', workoutName: 'Shoulder Day', muscleGroup: 'Shoulders'),
      ProgramDayModel(weekNumber: 1, dayNumber: 4, workoutId: 'wk_bro_arms', workoutName: 'Arm Day', muscleGroup: 'Biceps/Triceps'),
      ProgramDayModel(weekNumber: 1, dayNumber: 5, workoutId: 'wk_bro_legs', workoutName: 'Leg Day', muscleGroup: 'Legs/Glutes'),
    ];
  }
}
