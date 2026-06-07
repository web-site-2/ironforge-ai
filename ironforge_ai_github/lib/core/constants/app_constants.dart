// lib/core/constants/app_constants.dart

class AppConstants {
  // App Info
  static const String appName = 'IronForge AI';
  static const String appVersion = '1.0.0';

  // Colors (as hex strings for reference)
  static const String primaryHex = '#00E5A8';
  static const String secondaryHex = '#00BFFF';
  static const String backgroundHex = '#0A0A0A';
  static const String surfaceHex = '#121212';

  // Hive Box Names
  static const String userProfileBox = 'user_profile';
  static const String workoutsBox = 'workouts';
  static const String workoutLogsBox = 'workout_logs';
  static const String exerciseLogsBox = 'exercise_logs';
  static const String settingsBox = 'settings';
  static const String nutritionBox = 'nutrition';
  static const String bodyMeasurementsBox = 'body_measurements';
  static const String personalRecordsBox = 'personal_records';
  static const String achievementsBox = 'achievements';
  static const String favoritesBox = 'favorites';

  // Default Values
  static const int defaultRestSeconds = 90;
  static const int defaultSets = 3;
  static const int defaultReps = 10;

  // Notification IDs
  static const int restTimerNotificationId = 1001;
  static const int workoutReminderNotificationId = 1002;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Chart Colors
  static const List<String> chartColorHexes = [
    '#00E5A8',
    '#00BFFF',
    '#FF6B6B',
    '#FFD93D',
    '#6BCB77',
    '#C77DFF',
  ];
}

class RouteConstants {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String exercises = '/exercises';
  static const String exerciseDetail = '/exercises/:id';
  static const String workout = '/workout';
  static const String activeWorkout = '/workout/active';
  static const String programs = '/programs';
  static const String programDetail = '/programs/:id';
  static const String nutrition = '/nutrition';
  static const String tracking = '/tracking';
  static const String profile = '/profile';
  static const String settings = '/settings';
}
