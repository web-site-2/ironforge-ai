// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/constants/app_constants.dart';
import 'data/models/exercise_model.dart';
import 'data/models/user_profile_model.dart';
import 'data/models/workout_model.dart';
import 'data/models/program_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure system UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0A0A0A),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(ExerciseModelAdapter());
  Hive.registerAdapter(UserProfileModelAdapter());
  Hive.registerAdapter(WorkoutSetModelAdapter());
  Hive.registerAdapter(WorkoutExerciseModelAdapter());
  Hive.registerAdapter(WorkoutModelAdapter());
  Hive.registerAdapter(WorkoutLogModelAdapter());
  Hive.registerAdapter(PersonalRecordModelAdapter());
  Hive.registerAdapter(BodyMeasurementModelAdapter());
  Hive.registerAdapter(ProgramModelAdapter());
  Hive.registerAdapter(ProgramDayModelAdapter());

  // Open boxes
  await Future.wait([
    Hive.openBox<UserProfileModel>(AppConstants.userProfileBox),
    Hive.openBox<WorkoutLogModel>(AppConstants.workoutLogsBox),
    Hive.openBox<PersonalRecordModel>(AppConstants.personalRecordsBox),
    Hive.openBox<BodyMeasurementModel>(AppConstants.bodyMeasurementsBox),
    Hive.openBox<ProgramModel>(AppConstants.workoutsBox),
    Hive.openBox(AppConstants.nutritionBox),
    Hive.openBox(AppConstants.favoritesBox),
    Hive.openBox(AppConstants.settingsBox),
  ]);

  runApp(const ProviderScope(child: IronForgeApp()));
}

class IronForgeApp extends ConsumerWidget {
  const IronForgeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
    );
  }
}
