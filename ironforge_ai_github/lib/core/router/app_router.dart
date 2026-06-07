// lib/core/router/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/app_providers.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/exercises/exercises_screen.dart';
import '../../presentation/screens/exercises/exercise_detail_screen.dart';
import '../../presentation/screens/workout/workout_screen.dart';
import '../../presentation/screens/workout/active_workout_screen.dart';
import '../../presentation/screens/programs/programs_screen.dart';
import '../../presentation/screens/programs/program_detail_screen.dart';
import '../../presentation/screens/nutrition/nutrition_screen.dart';
import '../../presentation/screens/tracking/tracking_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final userProfile = ref.watch(userProfileProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isOnboarding = state.matchedLocation == '/onboarding';
      final isSplash = state.matchedLocation == '/';
      if (isSplash) return null;
      if (userProfile != null && !userProfile.onboardingCompleted && !isOnboarding) {
        return '/onboarding';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/exercises',
            builder: (context, state) => const ExercisesScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => ExerciseDetailScreen(
                  exerciseId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/workout',
            builder: (context, state) => const WorkoutScreen(),
            routes: [
              GoRoute(
                path: 'active',
                builder: (context, state) => const ActiveWorkoutScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/programs',
            builder: (context, state) => const ProgramsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => ProgramDetailScreen(
                  programId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/nutrition',
            builder: (context, state) => const NutritionScreen(),
          ),
          GoRoute(
            path: '/tracking',
            builder: (context, state) => const TrackingScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
