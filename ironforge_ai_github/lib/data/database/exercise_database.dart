// lib/data/database/exercise_database.dart

import '../models/exercise_model.dart';

class ExerciseDatabase {
  static List<ExerciseModel> get allExercises => [
        ..._chestExercises,
        ..._backExercises,
        ..._shoulderExercises,
        ..._bicepsExercises,
        ..._tricepsExercises,
        ..._forearmExercises,
        ..._absExercises,
        ..._legExercises,
        ..._calvesExercises,
        ..._glutesExercises,
        ..._fullBodyExercises,
      ];

  // ─── CHEST ───────────────────────────────────────────────
  static final List<ExerciseModel> _chestExercises = [
    ExerciseModel(
      id: 'chest_001',
      name: 'Barbell Bench Press',
      targetMuscle: 'Chest',
      secondaryMuscles: ['Front Deltoids', 'Triceps'],
      difficulty: 'Intermediate',
      equipment: ['Barbell', 'Bench', 'Rack'],
      instructions: [
        'Lie flat on the bench with your eyes directly under the barbell.',
        'Grip the bar slightly wider than shoulder-width with an overhand grip.',
        'Unrack the bar, holding it directly above your chest with arms fully extended.',
        'Lower the bar slowly to your mid-chest, keeping elbows at roughly 45-75° from your torso.',
        'Touch your chest lightly, then press the bar back up to the starting position.',
        'Keep your feet flat on the floor, glutes and upper back firmly on the bench.',
      ],
      commonMistakes: [
        'Bouncing the bar off the chest — reduces tension and risks injury.',
        'Flaring elbows out to 90° — increases shoulder impingement risk.',
        'Lifting the lower back off the bench — decreases stability.',
        'Not using a full range of motion — limits muscle development.',
        'Holding your breath throughout the entire set.',
      ],
      injuryPreventionTips: [
        'Always use a spotter when pushing near maximal weights.',
        'Warm up with lighter weights for 2-3 sets before working sets.',
        'Keep wrists straight and neutral, not bent backward.',
        'If shoulder pain occurs, try a closer grip or decline variation.',
        'Never press without safety bars or a spotter when training alone.',
      ],
      breathingInstructions:
          'Inhale as you lower the bar to your chest. Exhale forcefully as you press the bar up. Brace your core throughout.',
      trainingNotes:
          'The bench press is the king of chest exercises. For hypertrophy, use 3-5 sets of 6-12 reps. For strength, use 3-5 sets of 1-5 reps with heavier weight. Progressive overload is key — add weight gradually over weeks.',
      alternatives: [
        'Dumbbell Bench Press',
        'Push-Ups',
        'Machine Chest Press',
        'Smith Machine Bench Press',
        'Cable Chest Fly',
      ],
      youtubeVideoId: 'rT7DgCr-3pg',
      category: 'compound',
    ),
    ExerciseModel(
      id: 'chest_002',
      name: 'Dumbbell Bench Press',
      targetMuscle: 'Chest',
      secondaryMuscles: ['Front Deltoids', 'Triceps'],
      difficulty: 'Beginner',
      equipment: ['Dumbbells', 'Bench'],
      instructions: [
        'Sit on a flat bench holding a dumbbell in each hand resting on your thighs.',
        'Lean back and kick the dumbbells up, positioning them above your chest.',
        'Rotate palms forward so they face away from you.',
        'Lower both dumbbells to the sides of your chest, elbows at 45-75°.',
        'Press the dumbbells back up and slightly inward at the top.',
        'Squeeze your chest at the top of the movement.',
      ],
      commonMistakes: [
        'Letting the dumbbells drift too far out to the sides.',
        'Not controlling the weight on the way down.',
        'Touching the dumbbells together at the top too forcefully.',
        'Using too heavy a weight and losing form.',
      ],
      injuryPreventionTips: [
        'Start with lighter weights to master the movement pattern.',
        'Keep a slight arch in your lower back but avoid excessive arching.',
        'If one shoulder is weaker, use dumbbells to identify imbalances.',
      ],
      breathingInstructions:
          'Inhale at the bottom of the movement, exhale as you press up.',
      trainingNotes:
          'Dumbbells allow a greater range of motion than the barbell. They also improve muscle imbalances. Great choice for both beginners and advanced lifters.',
      alternatives: [
        'Barbell Bench Press',
        'Push-Ups',
        'Machine Chest Press',
        'Cable Chest Fly',
      ],
      youtubeVideoId: 'QsYre__-aro',
      category: 'compound',
    ),
    ExerciseModel(
      id: 'chest_003',
      name: 'Incline Dumbbell Press',
      targetMuscle: 'Chest',
      secondaryMuscles: ['Front Deltoids', 'Triceps'],
      difficulty: 'Intermediate',
      equipment: ['Dumbbells', 'Incline Bench'],
      instructions: [
        'Set a bench to a 30-45 degree incline.',
        'Sit back on the bench with dumbbells on your thighs.',
        'Kick the dumbbells up to shoulder level as you lie back.',
        'Press the dumbbells up and slightly together at the top.',
        'Lower the dumbbells to the upper chest with control.',
        'Focus on feeling the upper chest stretch at the bottom.',
      ],
      commonMistakes: [
        'Setting the incline too steep — becomes a shoulder exercise.',
        'Not bringing the dumbbells to upper chest level.',
        'Rushing the eccentric (lowering) phase.',
      ],
      injuryPreventionTips: [
        'Use 30-45° incline — steeper angles stress the shoulder.',
        'Warm up rotator cuff before heavy incline pressing.',
      ],
      breathingInstructions:
          'Inhale on the way down, exhale on the way up.',
      trainingNotes:
          'Targets the upper chest (clavicular head of pectoralis major). Essential for a complete chest development. Pair with flat and decline work.',
      alternatives: [
        'Incline Barbell Press',
        'Incline Cable Fly',
        'High-to-Low Cable Cross',
      ],
      youtubeVideoId: 'DbFgADa2PL8',
      category: 'compound',
    ),
    ExerciseModel(
      id: 'chest_004',
      name: 'Cable Chest Fly',
      targetMuscle: 'Chest',
      secondaryMuscles: ['Front Deltoids'],
      difficulty: 'Intermediate',
      equipment: ['Cable Machine'],
      instructions: [
        'Set both cable pulleys to chest height or slightly above.',
        'Stand in the center of the cable machine, one foot slightly forward.',
        'Hold both cable handles with palms facing each other.',
        'With a slight bend in the elbows, bring your arms forward in an arc.',
        'Squeeze your chest as both hands come together in front of you.',
        'Slowly return to the starting position, feeling the stretch across your chest.',
      ],
      commonMistakes: [
        'Bending elbows too much — makes it more of a press.',
        'Using momentum to swing the weight.',
        'Not getting a full stretch at the starting position.',
      ],
      injuryPreventionTips: [
        'Never lock out the elbows during the movement.',
        'Start with lighter weight to feel the chest contraction.',
      ],
      breathingInstructions:
          'Exhale as you bring the cables together. Inhale as you return.',
      trainingNotes:
          'Great for isolation and achieving a deep chest stretch. Ideal as a finishing exercise after compound movements. Cable maintains constant tension throughout the range of motion.',
      alternatives: [
        'Dumbbell Fly',
        'Pec Deck Machine',
        'Push-Up Plus',
      ],
      youtubeVideoId: 'Iwe6AmxVf7o',
      category: 'isolation',
    ),
    ExerciseModel(
      id: 'chest_005',
      name: 'Push-Ups',
      targetMuscle: 'Chest',
      secondaryMuscles: ['Triceps', 'Front Deltoids', 'Core'],
      difficulty: 'Beginner',
      equipment: ['Bodyweight'],
      instructions: [
        'Start in a high plank position with hands slightly wider than shoulders.',
        'Keep your body in a straight line from head to heels.',
        'Lower your chest to just above the floor.',
        'Keep your elbows at a 45° angle to your torso, not flared out.',
        'Press back up to the starting position.',
        'Squeeze your chest at the top.',
      ],
      commonMistakes: [
        'Letting hips sag or pike up.',
        'Flaring elbows out to 90° (strains shoulders).',
        'Not going through full range of motion.',
        'Looking up instead of keeping neutral neck.',
      ],
      injuryPreventionTips: [
        'Master push-ups before progressing to weighted variations.',
        'If wrist pain occurs, use push-up handles or do fist push-ups.',
      ],
      breathingInstructions:
          'Inhale going down, exhale coming up.',
      trainingNotes:
          'The foundation of upper body bodyweight training. Progress by elevating feet, adding weight vest, or working toward archer and one-arm variations. Can be done anywhere.',
      alternatives: [
        'Knee Push-Ups',
        'Dumbbell Bench Press',
        'Chest Press Machine',
        'Incline Push-Ups',
      ],
      youtubeVideoId: '0pkjOk0EiAk',
      category: 'compound',
    ),
  ];

  // ─── BACK ─────────────────────────────────────────────────
  static final List<ExerciseModel> _backExercises = [
    ExerciseModel(
      id: 'back_001',
      name: 'Barbell Deadlift',
      targetMuscle: 'Back',
      secondaryMuscles: ['Glutes', 'Hamstrings', 'Traps', 'Core', 'Forearms'],
      difficulty: 'Advanced',
      equipment: ['Barbell', 'Plates'],
      instructions: [
        'Stand with feet hip-width apart, barbell over mid-foot.',
        'Hinge at the hips and grip the bar just outside your legs.',
        'Take a big breath, brace your core, and pull your chest up.',
        'Push the floor away with your legs as you drive your hips forward.',
        'Keep the bar close to your body throughout the lift.',
        'Stand tall at the top with hips fully extended.',
        'Hinge back down with control to return the bar.',
      ],
      commonMistakes: [
        'Rounding the lower back — the most dangerous deadlift mistake.',
        'Bar drifting away from the body — increases spinal loading.',
        'Jerking the bar off the floor instead of creating tension.',
        'Hyperextending at the top — causes lumbar strain.',
        'Looking up excessively — causes cervical stress.',
      ],
      injuryPreventionTips: [
        'Never sacrifice form for heavier weight.',
        'Use a belt for working sets above 85% of your 1RM.',
        'Warm up with RDLs and lighter deadlifts before working sets.',
        'If you feel lower back fatigue (not muscle soreness), stop.',
        'Learn the hip hinge pattern before loading the movement.',
      ],
      breathingInstructions:
          'Take a deep breath into your belly before initiating the pull. Brace hard (Valsalva). Exhale at the top or during the descent.',
      trainingNotes:
          'The deadlift is the single most powerful strength and muscle-building exercise. Requires perfect technique. Train it 1-2x per week. For beginners, use sumo or trap bar deadlifts as alternatives.',
      alternatives: [
        'Romanian Deadlift',
        'Trap Bar Deadlift',
        'Sumo Deadlift',
        'Good Mornings',
        'Cable Pull-Through',
      ],
      youtubeVideoId: 'op9kVnSso6Q',
      category: 'compound',
    ),
    ExerciseModel(
      id: 'back_002',
      name: 'Pull-Ups',
      targetMuscle: 'Back',
      secondaryMuscles: ['Biceps', 'Rear Deltoids', 'Core'],
      difficulty: 'Intermediate',
      equipment: ['Pull-Up Bar'],
      instructions: [
        'Hang from the bar with hands slightly wider than shoulder-width, palms forward.',
        'Depress and retract your shoulder blades to initiate the movement.',
        'Pull your chest toward the bar, leading with your elbows.',
        'Continue pulling until your chin is above the bar.',
        'Lower yourself under control to full extension.',
        'Avoid kipping or swinging.',
      ],
      commonMistakes: [
        'Using momentum/kipping — reduces back muscle activation.',
        'Not achieving full extension at the bottom.',
        'Pulling with arms only instead of initiating with the back.',
        'Not retracting shoulder blades first.',
      ],
      injuryPreventionTips: [
        'Build to pull-ups with lat pulldowns and band-assisted pull-ups.',
        'Never drop from height to a dead hang — ease down.',
        'If shoulder pain occurs, check scapular depression technique.',
      ],
      breathingInstructions:
          'Exhale as you pull up. Inhale as you lower yourself.',
      trainingNotes:
          'Pull-ups are the ultimate back width exercise. Wider grip targets lats more. Closer grip biceps more. Use weighted belt once you can do 10+ reps.',
      alternatives: [
        'Lat Pulldown',
        'Band-Assisted Pull-Ups',
        'Chin-Ups',
        'Inverted Row',
      ],
      youtubeVideoId: 'eGo4IYlbE5g',
      category: 'compound',
    ),
    ExerciseModel(
      id: 'back_003',
      name: 'Barbell Row',
      targetMuscle: 'Back',
      secondaryMuscles: ['Biceps', 'Rear Deltoids', 'Core'],
      difficulty: 'Intermediate',
      equipment: ['Barbell'],
      instructions: [
        'Stand with feet shoulder-width apart, hinge at hips to about 45°.',
        'Grip the barbell slightly wider than shoulder-width, overhand grip.',
        'Keep your back flat and core braced.',
        'Pull the bar toward your lower chest/upper abdomen.',
        'Drive your elbows back and squeeze your shoulder blades at the top.',
        'Lower the bar with control back to the starting position.',
      ],
      commonMistakes: [
        'Rounding the lower back under load.',
        'Using too much hip drive/momentum (turning it into a cheat row).',
        'Pulling the bar to the upper chest instead of lower chest.',
        'Not squeezing at the top of each rep.',
      ],
      injuryPreventionTips: [
        'Prioritize form over weight — rows are a lower back injury risk.',
        'Brace your core like you\'re about to take a punch.',
      ],
      breathingInstructions:
          'Inhale at the bottom, exhale as you pull the bar to your torso.',
      trainingNotes:
          'Essential for back thickness. The angle of your torso determines which part of the back is targeted most. More upright = upper back, more horizontal = lower lat.',
      alternatives: [
        'Dumbbell Row',
        'Cable Row',
        'T-Bar Row',
        'Pendlay Row',
      ],
      youtubeVideoId: '9efgcAjQe7E',
      category: 'compound',
    ),
    ExerciseModel(
      id: 'back_004',
      name: 'Lat Pulldown',
      targetMuscle: 'Back',
      secondaryMuscles: ['Biceps', 'Rear Deltoids'],
      difficulty: 'Beginner',
      equipment: ['Cable Machine', 'Lat Bar'],
      instructions: [
        'Sit at the lat pulldown machine, secure your legs under the pads.',
        'Grip the bar wider than shoulder-width with an overhand grip.',
        'Lean back slightly (about 15-20°), keep chest up.',
        'Pull the bar down to your upper chest, driving elbows toward hips.',
        'Squeeze your lats at the bottom of the movement.',
        'Slowly let the bar rise back to starting position.',
      ],
      commonMistakes: [
        'Leaning back too far (turning it into a row).',
        'Pulling the bar behind the neck (dangerous for cervical spine).',
        'Using momentum and not controlling the weight.',
        'Not achieving full lat stretch at the top.',
      ],
      injuryPreventionTips: [
        'Never pull behind the neck — significant injury risk.',
        'Focus on driving elbows down rather than pulling with hands.',
      ],
      breathingInstructions:
          'Exhale as you pull down. Inhale as you return.',
      trainingNotes:
          'Great for beginners learning the pull-up pattern. Focus on mind-muscle connection with the lats. Progress to pull-ups once you can lat pulldown your bodyweight for reps.',
      alternatives: [
        'Pull-Ups',
        'Chin-Ups',
        'Straight Arm Pulldown',
      ],
      youtubeVideoId: 'CAwf7n6Luuc',
      category: 'compound',
    ),
    ExerciseModel(
      id: 'back_005',
      name: 'Dumbbell Row',
      targetMuscle: 'Back',
      secondaryMuscles: ['Biceps', 'Rear Deltoids'],
      difficulty: 'Beginner',
      equipment: ['Dumbbell', 'Bench'],
      instructions: [
        'Place one hand and same-side knee on a flat bench for support.',
        'Hold a dumbbell in the free hand, arm fully extended.',
        'Keep your back flat and parallel to the floor.',
        'Pull the dumbbell up toward your hip, driving elbow back.',
        'Squeeze your lat at the top of the movement.',
        'Lower the dumbbell with control to full arm extension.',
      ],
      commonMistakes: [
        'Rotating the torso to "cheat" the weight up.',
        'Not getting full range of motion at the bottom.',
        'Pulling toward shoulder instead of hip.',
      ],
      injuryPreventionTips: [
        'Maintain a flat, neutral back throughout.',
        'Use a weight that allows proper form for all reps.',
      ],
      breathingInstructions:
          'Exhale as you pull up, inhale as you lower.',
      trainingNotes:
          'One of the best unilateral back exercises. Allows you to identify and fix left-right imbalances. Train each side equally.',
      alternatives: [
        'Barbell Row',
        'Cable Row',
        'Pull-Ups',
        'Machine Row',
      ],
      youtubeVideoId: 'pYcpY20QaE8',
      category: 'compound',
    ),
  ];

  // ─── SHOULDERS ────────────────────────────────────────────
  static final List<ExerciseModel> _shoulderExercises = [
    ExerciseModel(
      id: 'shoulders_001',
      name: 'Overhead Press',
      targetMuscle: 'Shoulders',
      secondaryMuscles: ['Triceps', 'Upper Traps', 'Core'],
      difficulty: 'Intermediate',
      equipment: ['Barbell', 'Rack'],
      instructions: [
        'Set the barbell in a rack at upper chest height.',
        'Grip the bar just outside shoulder-width.',
        'Unrack and hold at the front of your upper chest.',
        'Press the bar vertically overhead, moving your head back slightly.',
        'Once the bar passes your forehead, push your head forward under the bar.',
        'Lock your arms out fully at the top.',
        'Lower the bar back to the front of your clavicle under control.',
      ],
      commonMistakes: [
        'Pressing the bar in front of the body instead of vertically.',
        'Excessive lower back arch — turns it into incline press.',
        'Flaring elbows out too wide.',
        'Not fully locking out at the top.',
      ],
      injuryPreventionTips: [
        'Always warm up the shoulders and rotator cuffs first.',
        'If shoulder impingement occurs, try dumbbell or neutral grip variation.',
        'Keep core braced to prevent lower back strain.',
      ],
      breathingInstructions:
          'Inhale before pressing. Exhale at the top.',
      trainingNotes:
          'The OHP is the best indicator of true shoulder strength. Difficult to progress — be patient. Standing OHP also trains the core and entire body as a stabilizer.',
      alternatives: [
        'Dumbbell Shoulder Press',
        'Arnold Press',
        'Seated Military Press',
        'Push Press',
      ],
      youtubeVideoId: '2yjwXTZQDDI',
      category: 'compound',
    ),
    ExerciseModel(
      id: 'shoulders_002',
      name: 'Lateral Raises',
      targetMuscle: 'Shoulders',
      secondaryMuscles: ['Upper Traps'],
      difficulty: 'Beginner',
      equipment: ['Dumbbells'],
      instructions: [
        'Stand with dumbbells at your sides, palms facing your body.',
        'Raise both arms out to the sides until they reach shoulder height.',
        'Lead with your elbows, not your wrists.',
        'Tilt the dumbbells slightly so the pinky side is higher (like pouring water).',
        'Slowly lower back down to starting position.',
        'Keep a slight bend in the elbows throughout.',
      ],
      commonMistakes: [
        'Swinging and using momentum.',
        'Raising arms too high — above shoulder level stresses AC joint.',
        'Letting shoulders shrug up toward ears.',
        'Using too heavy a weight.',
      ],
      injuryPreventionTips: [
        'Use lighter weights with strict form for this exercise.',
        'Do not raise arms above shoulder level.',
        'Drop sets work well for lateral raises.',
      ],
      breathingInstructions:
          'Exhale as you raise your arms, inhale as you lower.',
      trainingNotes:
          'The best exercise for lateral deltoid isolation and shoulder width. Use light to moderate weights with high reps (12-20) for best results. Quality over quantity.',
      alternatives: [
        'Cable Lateral Raise',
        'Machine Lateral Raise',
        'Resistance Band Lateral Raise',
      ],
      youtubeVideoId: 'FeJWKUCggqs',
      category: 'isolation',
    ),
    ExerciseModel(
      id: 'shoulders_003',
      name: 'Face Pulls',
      targetMuscle: 'Shoulders',
      secondaryMuscles: ['Rear Deltoids', 'Rhomboids', 'Rotator Cuff'],
      difficulty: 'Beginner',
      equipment: ['Cable Machine', 'Rope Attachment'],
      instructions: [
        'Set the cable pulley to face height with a rope attachment.',
        'Grab both ends of the rope with an overhand grip.',
        'Step back until arms are fully extended.',
        'Pull the rope toward your face, separating the rope ends.',
        'Bring the rope to ear level, squeezing shoulder blades together.',
        'Rotate shoulders externally at the end of the movement.',
        'Slowly return to the starting position.',
      ],
      commonMistakes: [
        'Pulling the rope to chest instead of face.',
        'Not separating the rope ends at the end of the movement.',
        'Using too heavy a weight and losing external rotation.',
      ],
      injuryPreventionTips: [
        'Face pulls are protective for shoulder health — never skip them.',
        'Train them frequently (2-3x per week) to counterbalance pressing.',
      ],
      breathingInstructions:
          'Exhale as you pull toward your face. Inhale as you return.',
      trainingNotes:
          'Arguably the most important shoulder exercise for long-term joint health. Strengthens the often neglected rear delts and external rotators. Must be in every training program.',
      alternatives: [
        'Band Pull-Aparts',
        'Reverse Flys',
        'Y-T-W exercises',
      ],
      youtubeVideoId: 'HSoHeSjvIdw',
      category: 'isolation',
    ),
  ];

  // ─── BICEPS ───────────────────────────────────────────────
  static final List<ExerciseModel> _bicepsExercises = [
    ExerciseModel(
      id: 'biceps_001',
      name: 'Barbell Curl',
      targetMuscle: 'Biceps',
      secondaryMuscles: ['Forearms', 'Brachialis'],
      difficulty: 'Beginner',
      equipment: ['Barbell'],
      instructions: [
        'Stand with feet shoulder-width apart, holding a barbell with an underhand grip.',
        'Keep your elbows pinned to your sides throughout the movement.',
        'Curl the bar up toward your shoulders, squeezing your biceps.',
        'Hold the contracted position for a moment at the top.',
        'Slowly lower the bar back to the starting position.',
        'Do not let your elbows drift forward.',
      ],
      commonMistakes: [
        'Swinging the body to cheat the weight up.',
        'Letting elbows drift forward at the top.',
        'Not fully extending arms at the bottom.',
        'Gripping too wide or too narrow.',
      ],
      injuryPreventionTips: [
        'Never use a straight bar if you have wrist discomfort — use an EZ bar.',
        'Keep reps controlled, especially on the way down.',
      ],
      breathingInstructions:
          'Exhale as you curl up. Inhale as you lower.',
      trainingNotes:
          'The classic biceps builder. EZ bar curls are easier on the wrists. For maximum peak, supinate the wrist (rotate pinky up) at the top.',
      alternatives: [
        'Dumbbell Curl',
        'EZ Bar Curl',
        'Hammer Curl',
        'Cable Curl',
        'Preacher Curl',
      ],
      youtubeVideoId: 'ykJmrZ5v0Oo',
      category: 'isolation',
    ),
    ExerciseModel(
      id: 'biceps_002',
      name: 'Dumbbell Hammer Curl',
      targetMuscle: 'Biceps',
      secondaryMuscles: ['Brachialis', 'Brachioradialis', 'Forearms'],
      difficulty: 'Beginner',
      equipment: ['Dumbbells'],
      instructions: [
        'Stand with dumbbells at your sides, palms facing each other (neutral grip).',
        'Keep elbows pinned to your sides.',
        'Curl both dumbbells up simultaneously, maintaining the neutral grip.',
        'Squeeze at the top without rotating the wrists.',
        'Lower slowly to starting position.',
      ],
      commonMistakes: [
        'Rotating wrists during the movement.',
        'Swinging the body for momentum.',
        'Not achieving full range of motion.',
      ],
      injuryPreventionTips: [
        'Hammer curls are generally easier on the wrists than supinated curls.',
        'Use for forearm and brachialis development.',
      ],
      breathingInstructions:
          'Exhale as you curl up. Inhale as you lower.',
      trainingNotes:
          'Develops the brachialis (under the bicep) which pushes the bicep up, giving the arm more size. Also builds forearm thickness. Neutral grip is wrist-friendly.',
      alternatives: [
        'Cross-Body Hammer Curl',
        'Rope Cable Curl',
        'Reverse Curl',
      ],
      youtubeVideoId: 'zC3nLlEvin4',
      category: 'isolation',
    ),
    ExerciseModel(
      id: 'biceps_003',
      name: 'Incline Dumbbell Curl',
      targetMuscle: 'Biceps',
      secondaryMuscles: ['Brachialis'],
      difficulty: 'Intermediate',
      equipment: ['Dumbbells', 'Incline Bench'],
      instructions: [
        'Set a bench to 45-60 degrees and sit back on it.',
        'Hold dumbbells with arms hanging straight down, palms forward.',
        'Curl both dumbbells up simultaneously.',
        'Do not bring elbows forward — let them hang naturally.',
        'Lower fully to starting position for maximum stretch.',
      ],
      commonMistakes: [
        'Bringing elbows forward — eliminates the long head stretch.',
        'Using too much weight and losing form.',
        'Not achieving the full stretch at the bottom.',
      ],
      injuryPreventionTips: [
        'Use light to moderate weight for this exercise.',
        'The stretch position can stress the biceps tendon — warm up first.',
      ],
      breathingInstructions:
          'Exhale curling up, inhale lowering down.',
      trainingNotes:
          'Excellent for targeting the long head of the biceps which creates bicep peak. The incline position stretches the biceps more than standing variations.',
      alternatives: [
        'Cable Curl (low pulley)',
        'Bayesian Cable Curl',
        'Scott Curl',
      ],
      youtubeVideoId: 'MzbjL9y9mmI',
      category: 'isolation',
    ),
  ];

  // ─── TRICEPS ──────────────────────────────────────────────
  static final List<ExerciseModel> _tricepsExercises = [
    ExerciseModel(
      id: 'triceps_001',
      name: 'Close Grip Bench Press',
      targetMuscle: 'Triceps',
      secondaryMuscles: ['Chest', 'Front Deltoids'],
      difficulty: 'Intermediate',
      equipment: ['Barbell', 'Bench', 'Rack'],
      instructions: [
        'Set up like a regular bench press but grip the bar at shoulder-width.',
        'Unrack the bar and position it above your lower chest.',
        'Lower the bar to your lower chest, keeping elbows close to your body.',
        'Press back up, focusing on squeezing your triceps.',
        'Lock out fully at the top.',
      ],
      commonMistakes: [
        'Gripping too close (hands touching) — strains wrists.',
        'Flaring elbows out wide — shifts work to chest.',
        'Not achieving full lockout.',
      ],
      injuryPreventionTips: [
        'Shoulder-width grip is optimal — closer causes wrist strain.',
        'Always use a spotter or safety bars for heavy work.',
      ],
      breathingInstructions:
          'Inhale on the way down, exhale pressing up.',
      trainingNotes:
          'One of the best mass builders for triceps. Allows heavy loading. Great for the long head of the triceps. Train as a compound movement.',
      alternatives: [
        'Skull Crushers',
        'Dips',
        'Triceps Pushdowns',
        'Diamond Push-Ups',
      ],
      youtubeVideoId: 'nEF0bv2FW94',
      category: 'compound',
    ),
    ExerciseModel(
      id: 'triceps_002',
      name: 'Triceps Pushdown',
      targetMuscle: 'Triceps',
      secondaryMuscles: [],
      difficulty: 'Beginner',
      equipment: ['Cable Machine'],
      instructions: [
        'Stand at a cable machine with a bar or rope attachment at upper height.',
        'Grip the bar with an overhand grip at shoulder-width.',
        'Keep upper arms pinned to your sides, perpendicular to the floor.',
        'Push the bar downward until your arms are fully extended.',
        'Squeeze your triceps hard at the bottom.',
        'Slowly return to starting position, letting your forearms rise to 90°.',
      ],
      commonMistakes: [
        'Letting elbows drift forward and back during the movement.',
        'Not locking out at the bottom.',
        'Leaning forward excessively.',
        'Bending forward to use body momentum.',
      ],
      injuryPreventionTips: [
        'Keep upper arms stationary — the movement is at the elbow only.',
        'If using rope, spread at the bottom for outer head isolation.',
      ],
      breathingInstructions:
          'Exhale as you push down. Inhale as you return.',
      trainingNotes:
          'Classic triceps isolation. Rope pushdowns allow a wider range and better squeeze. Bar pushdowns allow heavier weight. Use both variations.',
      alternatives: [
        'Overhead Cable Extension',
        'Kickbacks',
        'Band Pushdowns',
        'Close Grip Push-Ups',
      ],
      youtubeVideoId: '2-LAMcpzODU',
      category: 'isolation',
    ),
    ExerciseModel(
      id: 'triceps_003',
      name: 'Skull Crushers',
      targetMuscle: 'Triceps',
      secondaryMuscles: [],
      difficulty: 'Intermediate',
      equipment: ['Barbell', 'EZ Bar', 'Bench'],
      instructions: [
        'Lie on a flat bench, holding an EZ bar or barbell above your face.',
        'Start with arms extended, bar directly above your forehead.',
        'Keep upper arms vertical and perfectly still.',
        'Bend at the elbows, lowering the bar toward your forehead.',
        'Stop just before the bar reaches your head.',
        'Extend your arms back to the starting position.',
      ],
      commonMistakes: [
        'Moving the upper arms — changes the exercise.',
        'Going too heavy and losing control of the weight.',
        'Not going through full range of motion.',
        'Rushing through the reps.',
      ],
      injuryPreventionTips: [
        'The name says it all — control the weight carefully.',
        'Use a spotter for heavier sets.',
        'EZ bar is easier on the wrists than a straight bar.',
      ],
      breathingInstructions:
          'Inhale as you lower the bar. Exhale as you extend arms.',
      trainingNotes:
          'Excellent for the long head of the triceps which makes up most of the arm. Use controlled tempo — don\'t rush. Can also lower to forehead or behind head.',
      alternatives: [
        'Overhead Dumbbell Extension',
        'Close Grip Bench Press',
        'Cable Overhead Extension',
      ],
      youtubeVideoId: 'd_KZxkY_0cM',
      category: 'isolation',
    ),
  ];

  // ─── FOREARMS ─────────────────────────────────────────────
  static final List<ExerciseModel> _forearmExercises = [
    ExerciseModel(
      id: 'forearms_001',
      name: 'Wrist Curls',
      targetMuscle: 'Forearms',
      secondaryMuscles: [],
      difficulty: 'Beginner',
      equipment: ['Barbell', 'Dumbbells'],
      instructions: [
        'Sit on a bench, resting forearms on thighs with wrists extending past knees.',
        'Hold a barbell or dumbbells with an underhand grip.',
        'Let your wrists drop as far as comfortable.',
        'Curl your wrists upward as far as possible.',
        'Slowly lower back to starting position.',
      ],
      commonMistakes: [
        'Using too heavy a weight and losing range of motion.',
        'Moving the forearms up and down (should stay stationary).',
      ],
      injuryPreventionTips: [
        'Use light to moderate weight for forearm exercises.',
        'Stretch forearms after training to prevent tightness.',
      ],
      breathingInstructions: 'Breathe naturally during this exercise.',
      trainingNotes:
          'Train forearms 2-3 times per week for best results. They respond well to high volume. Also train reverse wrist curls for forearm balance.',
      alternatives: [
        'Reverse Wrist Curls',
        'Farmer Carries',
        'Dead Hangs',
        'Grip Trainers',
      ],
      youtubeVideoId: 'f0CREfxzIew',
      category: 'isolation',
    ),
  ];

  // ─── ABS ──────────────────────────────────────────────────
  static final List<ExerciseModel> _absExercises = [
    ExerciseModel(
      id: 'abs_001',
      name: 'Cable Crunch',
      targetMuscle: 'Abs',
      secondaryMuscles: ['Obliques'],
      difficulty: 'Beginner',
      equipment: ['Cable Machine', 'Rope Attachment'],
      instructions: [
        'Attach a rope to a high cable pulley.',
        'Kneel facing the cable machine, holding the rope behind your head.',
        'Keep hips stationary and curl your upper body down.',
        'Contract your abs hard at the bottom — round your back.',
        'Slowly return to starting position, keeping tension on abs.',
      ],
      commonMistakes: [
        'Pulling down with the arms instead of crunching with the abs.',
        'Sitting back and using hip flexors to pull down.',
        'Not achieving a full crunch at the bottom.',
      ],
      injuryPreventionTips: [
        'Focus on the mind-muscle connection with the abs.',
        'The movement is a crunch — not a hip flexor pull-down.',
      ],
      breathingInstructions:
          'Exhale hard as you crunch down. Inhale as you return.',
      trainingNotes:
          'One of the few weighted ab exercises. Essential for building thick abs that show even when not super lean. Progressive overload applies here too.',
      alternatives: [
        'Decline Crunch',
        'Ab Wheel Rollout',
        'Hanging Leg Raise',
        'Dragon Flag',
      ],
      youtubeVideoId: 'AV5PmtZwI_w',
      category: 'isolation',
    ),
    ExerciseModel(
      id: 'abs_002',
      name: 'Hanging Leg Raise',
      targetMuscle: 'Abs',
      secondaryMuscles: ['Hip Flexors', 'Obliques'],
      difficulty: 'Intermediate',
      equipment: ['Pull-Up Bar'],
      instructions: [
        'Hang from a pull-up bar with arms fully extended.',
        'Engage your core and tuck your pelvis.',
        'Raise your legs straight up to 90 degrees.',
        'For advanced: continue to bring legs toward the bar.',
        'Lower slowly with control, resisting the pull of gravity.',
        'Avoid swinging.',
      ],
      commonMistakes: [
        'Swinging the legs up with momentum.',
        'Not controlling the eccentric (lowering) phase.',
        'Bending the knees (easier but less effective).',
      ],
      injuryPreventionTips: [
        'Master bent knee raises before straight leg raises.',
        'If grip is limiting, use ab straps.',
      ],
      breathingInstructions:
          'Exhale as you raise your legs. Inhale as you lower.',
      trainingNotes:
          'Excellent for lower ab development and core stability. Progress from bent knee raises → straight leg → toes to bar.',
      alternatives: [
        'Cable Crunch',
        'Ab Wheel Rollout',
        'Decline Leg Raise',
        'Lying Leg Raise',
      ],
      youtubeVideoId: 'hdng3Nm1x_E',
      category: 'compound',
    ),
    ExerciseModel(
      id: 'abs_003',
      name: 'Plank',
      targetMuscle: 'Abs',
      secondaryMuscles: ['Core', 'Shoulders', 'Glutes'],
      difficulty: 'Beginner',
      equipment: ['Bodyweight'],
      instructions: [
        'Start in a forearm plank position with forearms on the floor.',
        'Elbows directly under your shoulders.',
        'Maintain a perfectly straight body from head to heels.',
        'Squeeze your glutes, abs, and quads.',
        'Do not let your hips sag or pike up.',
        'Hold the position for the prescribed duration.',
      ],
      commonMistakes: [
        'Letting hips sag — reduces core activation.',
        'Piking hips up — makes it easier but less effective.',
        'Holding the breath.',
        'Looking up or forward instead of down.',
      ],
      injuryPreventionTips: [
        'If wrists hurt, use forearm plank.',
        'Stop if you cannot maintain a straight line — form is everything.',
      ],
      breathingInstructions: 'Breathe steadily and deeply throughout the hold.',
      trainingNotes:
          'Foundation for core stability. Progress from 30 seconds → 60 seconds → 90 seconds → weighted plank → side plank variations.',
      alternatives: [
        'Side Plank',
        'RKC Plank',
        'Hollow Body Hold',
        'Ab Wheel Rollout',
      ],
      youtubeVideoId: 'pSHjTRCQxIw',
      category: 'isolation',
    ),
  ];

  // ─── LEGS ─────────────────────────────────────────────────
  static final List<ExerciseModel> _legExercises = [
    ExerciseModel(
      id: 'legs_001',
      name: 'Barbell Squat',
      targetMuscle: 'Legs',
      secondaryMuscles: ['Glutes', 'Core', 'Lower Back', 'Hamstrings'],
      difficulty: 'Intermediate',
      equipment: ['Barbell', 'Squat Rack'],
      instructions: [
        'Set the barbell on the rack at upper chest height.',
        'Step under the bar and position it on your upper traps (high bar) or rear delts (low bar).',
        'Grip the bar just outside shoulder-width for stability.',
        'Unrack the bar and step back with two steps.',
        'Stand with feet shoulder-width, toes pointed slightly out.',
        'Take a deep breath, brace your core, then squat down.',
        'Push your knees outward in the direction of your toes.',
        'Squat until hip crease is below knee level (parallel or below).',
        'Drive through your heels and hips to stand back up.',
      ],
      commonMistakes: [
        'Knees caving inward (valgus collapse).',
        'Heels rising off the floor.',
        'Rounding the lower back at the bottom.',
        'Not reaching parallel depth.',
        'Looking down — should look straight ahead or slightly up.',
      ],
      injuryPreventionTips: [
        'Never skip squatting below parallel if mobility allows — it\'s safer and more effective.',
        'Work on ankle and hip mobility if heels rise.',
        'Use squat shoes or heel elevation if needed.',
        'Always use a spotter or safety bars.',
      ],
      breathingInstructions:
          'Big breath into belly before you descend. Hold it through the descent and drive. Exhale at the top.',
      trainingNotes:
          'The king of all exercises. Trains the entire lower body and core. For powerlifting, use low bar. For bodybuilding, use high bar. Goblet squat is an excellent learning tool for beginners.',
      alternatives: [
        'Goblet Squat',
        'Front Squat',
        'Leg Press',
        'Bulgarian Split Squat',
        'Hack Squat',
      ],
      youtubeVideoId: 'ultWZbUMPL8',
      category: 'compound',
    ),
    ExerciseModel(
      id: 'legs_002',
      name: 'Bulgarian Split Squat',
      targetMuscle: 'Legs',
      secondaryMuscles: ['Glutes', 'Hip Flexors', 'Core'],
      difficulty: 'Intermediate',
      equipment: ['Dumbbells', 'Bench'],
      instructions: [
        'Stand about 2 feet in front of a bench.',
        'Elevate one foot behind you on the bench.',
        'Hold dumbbells at your sides or barbell on back.',
        'Lower your body until your rear knee nearly touches the floor.',
        'Keep your front shin relatively vertical.',
        'Drive through your front heel to return to starting position.',
        'Complete all reps on one side before switching.',
      ],
      commonMistakes: [
        'Front foot too close to the bench (knee goes too far forward).',
        'Torso leaning too far forward.',
        'Front knee caving inward.',
      ],
      injuryPreventionTips: [
        'Start without weight to learn the movement pattern.',
        'Go slow on the descent and maintain balance.',
      ],
      breathingInstructions:
          'Inhale on the way down, exhale driving back up.',
      trainingNotes:
          'One of the best unilateral leg exercises. Develops balance and fixes strength imbalances between legs. Higher quad activation than regular squats for most people.',
      alternatives: [
        'Barbell Squat',
        'Lunges',
        'Step-Ups',
        'Leg Press',
      ],
      youtubeVideoId: 'vUbFnO1sMm8',
      category: 'compound',
    ),
    ExerciseModel(
      id: 'legs_003',
      name: 'Romanian Deadlift',
      targetMuscle: 'Legs',
      secondaryMuscles: ['Glutes', 'Lower Back', 'Core'],
      difficulty: 'Intermediate',
      equipment: ['Barbell', 'Dumbbells'],
      instructions: [
        'Stand with barbell at hip height, feet hip-width apart.',
        'Grip the bar with hands just outside hip-width.',
        'Keep legs almost straight with a slight bend at the knee.',
        'Hinge at the hips, pushing them back as you lower the bar.',
        'Keep the bar close to your body throughout.',
        'Lower until you feel a deep stretch in your hamstrings (usually shin level).',
        'Drive hips forward to return to standing.',
      ],
      commonMistakes: [
        'Rounding the lower back.',
        'Bending knees too much (turning it into a conventional deadlift).',
        'Bar drifting away from the body.',
        'Not achieving a proper hamstring stretch.',
      ],
      injuryPreventionTips: [
        'Hinge at the hips — think about pushing your butt backward, not bending over.',
        'Maintain a neutral spine throughout.',
      ],
      breathingInstructions:
          'Inhale on the way down. Exhale as you drive hips forward.',
      trainingNotes:
          'The best hamstring builder. Teaches the hip hinge pattern. Train it as the main hamstring exercise 1-2x per week. Goes well after squats on leg day.',
      alternatives: [
        'Good Mornings',
        'Nordic Hamstring Curl',
        'Leg Curl',
        'Single Leg RDL',
      ],
      youtubeVideoId: 'JCXUYuzwNrM',
      category: 'compound',
    ),
    ExerciseModel(
      id: 'legs_004',
      name: 'Leg Press',
      targetMuscle: 'Legs',
      secondaryMuscles: ['Glutes'],
      difficulty: 'Beginner',
      equipment: ['Leg Press Machine'],
      instructions: [
        'Sit in the leg press machine with your back flat against the pad.',
        'Place feet shoulder-width apart, toes slightly flared.',
        'Unlock the safety handles and lower the platform toward your chest.',
        'Lower until knees reach 90 degrees or just below.',
        'Press back up through your heels, without locking out knees completely.',
        'Keep your lower back flat against the pad throughout.',
      ],
      commonMistakes: [
        'Allowing knees to cave inward.',
        'Letting lower back peel off the pad at the bottom.',
        'Locking out knees under heavy load.',
        'Placing feet too low (quad dominant) or too high (glute dominant) depending on goal.',
      ],
      injuryPreventionTips: [
        'Never lock out the knees under heavy load.',
        'Ensure feet position matches your goal.',
        'Full range of motion (90° or below) is safer and more effective.',
      ],
      breathingInstructions:
          'Exhale pressing out. Inhale on the way down.',
      trainingNotes:
          'Great for quad development and allows very heavy loading. Foot position changes the emphasis: low feet = quads, high and wide feet = glutes/hamstrings. Good as a secondary movement after squats.',
      alternatives: [
        'Barbell Squat',
        'Hack Squat',
        'Goblet Squat',
        'Front Squat',
      ],
      youtubeVideoId: 'IZxyjW7MPJQ',
      category: 'compound',
    ),
  ];

  // ─── CALVES ───────────────────────────────────────────────
  static final List<ExerciseModel> _calvesExercises = [
    ExerciseModel(
      id: 'calves_001',
      name: 'Standing Calf Raise',
      targetMuscle: 'Calves',
      secondaryMuscles: ['Soleus'],
      difficulty: 'Beginner',
      equipment: ['Calf Raise Machine', 'Smith Machine', 'Bodyweight'],
      instructions: [
        'Stand on a calf raise machine or with toes on an elevated surface.',
        'Start with heels below the level of your toes.',
        'Slowly rise onto your toes as high as possible.',
        'Hold the peak contraction for 1-2 seconds.',
        'Lower back down slowly to get a full stretch.',
        'Repeat for the prescribed reps.',
      ],
      commonMistakes: [
        'Bouncing at the bottom — eliminates the stretch.',
        'Not rising to full height.',
        'Rushing through reps — calves respond to time under tension.',
      ],
      injuryPreventionTips: [
        'Calves are tight — always stretch after training.',
        'Achilles tendon is vulnerable — never bounce at the bottom.',
      ],
      breathingInstructions: 'Breathe naturally throughout.',
      trainingNotes:
          'Calves are notoriously stubborn. High frequency (3-4x per week) and high volume (15-20+ reps) tends to work best. Full range of motion is critical — deep stretch, full rise.',
      alternatives: [
        'Seated Calf Raise',
        'Leg Press Calf Raise',
        'Donkey Calf Raise',
        'Single Leg Calf Raise',
      ],
      youtubeVideoId: 'gwLzBJYoWlI',
      category: 'isolation',
    ),
  ];

  // ─── GLUTES ───────────────────────────────────────────────
  static final List<ExerciseModel> _glutesExercises = [
    ExerciseModel(
      id: 'glutes_001',
      name: 'Hip Thrust',
      targetMuscle: 'Glutes',
      secondaryMuscles: ['Hamstrings', 'Core'],
      difficulty: 'Beginner',
      equipment: ['Barbell', 'Bench', 'Hip Thrust Pad'],
      instructions: [
        'Sit on the floor with your upper back against a bench.',
        'Roll a barbell over your hips (use a pad for comfort).',
        'Plant feet on the floor, about shoulder-width apart.',
        'Drive through your heels, thrusting your hips up.',
        'Squeeze your glutes hard at the top.',
        'Hold for a moment at full hip extension.',
        'Lower back down with control.',
      ],
      commonMistakes: [
        'Not achieving full hip extension at the top.',
        'Letting the chin tuck in — keep eyes forward.',
        'Driving with the lower back instead of glutes.',
        'Feet too far or too close from the bench.',
      ],
      injuryPreventionTips: [
        'Always use a barbell pad to protect hip bones.',
        'Ensure bench is stable and secured.',
      ],
      breathingInstructions:
          'Exhale as you thrust up. Inhale as you lower down.',
      trainingNotes:
          'The most effective glute isolation exercise. Higher hip extension = more glute activation than squats. Use heavy weight and progressive overload for glute growth.',
      alternatives: [
        'Glute Bridge',
        'Cable Kickback',
        'Step-Ups',
        'Sumo Deadlift',
      ],
      youtubeVideoId: 'SEdqd1n0cvg',
      category: 'isolation',
    ),
  ];

  // ─── FULL BODY ────────────────────────────────────────────
  static final List<ExerciseModel> _fullBodyExercises = [
    ExerciseModel(
      id: 'fullbody_001',
      name: 'Clean and Press',
      targetMuscle: 'Full Body',
      secondaryMuscles: ['Legs', 'Back', 'Shoulders', 'Core'],
      difficulty: 'Advanced',
      equipment: ['Barbell'],
      instructions: [
        'Stand with barbell over mid-foot, feet hip-width apart.',
        'Hinge at the hips and grip the bar just outside your legs.',
        'Pull the bar explosively, extending hips and knees.',
        'Shrug powerfully and pull the bar up.',
        'Drop under the bar and catch it at shoulder level in a front rack.',
        'Stand up from the receiving position.',
        'Press the bar overhead from the shoulder position.',
        'Lower the bar back to the starting position.',
      ],
      commonMistakes: [
        'Not generating enough hip power on the pull.',
        'Catching the bar with bent wrists.',
        'Pressing before fully stabilizing in the rack position.',
      ],
      injuryPreventionTips: [
        'Learn the clean and press components separately before combining.',
        'Practice with an empty bar until technique is solid.',
      ],
      breathingInstructions:
          'Exhale on the pull. Brace and hold during press.',
      trainingNotes:
          'Olympic lift hybrid. Develops explosive power, coordination, and full body strength. Requires coaching or dedicated practice to learn safely. Excellent for athletes.',
      alternatives: [
        'Dumbbell Clean and Press',
        'Kettlebell Clean and Press',
        'Power Clean',
        'Push Press',
      ],
      youtubeVideoId: 'I2yjplCjuxo',
      category: 'compound',
    ),
    ExerciseModel(
      id: 'fullbody_002',
      name: 'Kettlebell Swing',
      targetMuscle: 'Full Body',
      secondaryMuscles: ['Glutes', 'Hamstrings', 'Core', 'Shoulders'],
      difficulty: 'Intermediate',
      equipment: ['Kettlebell'],
      instructions: [
        'Stand with the kettlebell on the floor between your feet.',
        'Hinge at the hips and grip the kettlebell with both hands.',
        'Hike the kettlebell back between your legs.',
        'Explosively drive your hips forward, swinging the kettlebell up.',
        'Let the bell float to about chest height.',
        'As it descends, hinge at the hips and let it swing back through.',
        'Immediately hinge and repeat.',
      ],
      commonMistakes: [
        'Squatting instead of hinging at the hips.',
        'Using arms to pull the kettlebell up (should be hip drive).',
        'Letting the lower back round at the bottom.',
      ],
      injuryPreventionTips: [
        'Master the deadlift and hip hinge before swings.',
        'Keep the kettlebell close to the body throughout.',
      ],
      breathingInstructions:
          'Exhale sharply at the top as hips snap forward. Inhale on the way down.',
      trainingNotes:
          'Incredible cardio and posterior chain exercise. Trains hip hinge pattern under load. Can be used for conditioning or as part of a circuit. 10-20 rep sets work well.',
      alternatives: [
        'Dumbbell Swing',
        'Box Jump',
        'Medicine Ball Slam',
        'Battle Ropes',
      ],
      youtubeVideoId: '44SC0bDHCiU',
      category: 'compound',
    ),
    ExerciseModel(
      id: 'fullbody_003',
      name: 'Burpees',
      targetMuscle: 'Full Body',
      secondaryMuscles: ['Chest', 'Shoulders', 'Core', 'Legs'],
      difficulty: 'Intermediate',
      equipment: ['Bodyweight'],
      instructions: [
        'Start standing, then squat down and place hands on the floor.',
        'Jump or step both feet back to a push-up position.',
        'Perform one push-up.',
        'Jump or step feet forward to your hands.',
        'Explosively jump up with arms overhead.',
        'Land softly and immediately go into the next rep.',
      ],
      commonMistakes: [
        'Sagging hips in the plank position.',
        'Not achieving full extension in the jump.',
        'Sloppy push-up position.',
      ],
      injuryPreventionTips: [
        'Land with soft knees to absorb impact.',
        'Scale by removing the push-up or jump if needed.',
      ],
      breathingInstructions: 'Exhale during push-up. Breathe rhythmically.',
      trainingNotes:
          'One of the best conditioning exercises. Burns significant calories. Can be modified for any fitness level. Use in HIIT circuits or as a finisher.',
      alternatives: [
        'Mountain Climbers',
        'Box Jumps',
        'Jump Squats',
        'Bear Crawl',
      ],
      youtubeVideoId: 'dZgVxmf6jkA',
      category: 'compound',
    ),
  ];

  // Helper methods
  static List<ExerciseModel> getByMuscleGroup(String muscleGroup) {
    return allExercises
        .where((e) => e.targetMuscle.toLowerCase() == muscleGroup.toLowerCase())
        .toList();
  }

  static List<ExerciseModel> getByDifficulty(String difficulty) {
    return allExercises
        .where((e) => e.difficulty.toLowerCase() == difficulty.toLowerCase())
        .toList();
  }

  static List<ExerciseModel> getByEquipment(List<String> availableEquipment) {
    return allExercises.where((exercise) {
      if (availableEquipment.contains('Full Gym')) return true;
      if (availableEquipment.contains('Bodyweight Only')) {
        return exercise.equipment.contains('Bodyweight');
      }
      return exercise.equipment.any((eq) =>
          availableEquipment.any((avail) =>
              avail.toLowerCase().contains(eq.toLowerCase()) ||
              eq.toLowerCase().contains(avail.toLowerCase())));
    }).toList();
  }

  static List<ExerciseModel> search(String query) {
    final lowerQuery = query.toLowerCase();
    return allExercises
        .where((e) =>
            e.name.toLowerCase().contains(lowerQuery) ||
            e.targetMuscle.toLowerCase().contains(lowerQuery) ||
            e.secondaryMuscles
                .any((m) => m.toLowerCase().contains(lowerQuery)))
        .toList();
  }

  static ExerciseModel? getById(String id) {
    try {
      return allExercises.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<ExerciseModel> getAlternatives(ExerciseModel exercise) {
    return allExercises
        .where((e) =>
            e.id != exercise.id &&
            (e.targetMuscle == exercise.targetMuscle ||
                exercise.alternatives.contains(e.name)))
        .take(5)
        .toList();
  }
}
