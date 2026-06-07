// lib/presentation/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../providers/app_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    final profile = ref.read(userProfileProvider);
    if (profile == null || !profile.onboardingCompleted) {
      context.go('/onboarding');
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.fitness_center_rounded,
                color: Colors.black,
                size: 52,
              ),
            )
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut)
                .fadeIn(duration: 400.ms),

            const SizedBox(height: 24),

            // App name
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: const Text(
                'IRONFORGE',
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 6,
                ),
              ),
            )
                .animate(delay: 300.ms)
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.3, end: 0),

            const SizedBox(height: 4),

            Text(
              'AI FITNESS',
              style: TextStyle(
                fontFamily: 'Exo2',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
                letterSpacing: 8,
              ),
            )
                .animate(delay: 500.ms)
                .fadeIn(duration: 500.ms),

            const SizedBox(height: 60),

            // Loading indicator
            SizedBox(
              width: 120,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.border,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
                borderRadius: BorderRadius.circular(4),
              ),
            )
                .animate(delay: 700.ms)
                .fadeIn(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
