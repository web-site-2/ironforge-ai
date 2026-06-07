// lib/presentation/screens/main_shell.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _getIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/exercises')) return 1;
    if (location.startsWith('/programs')) return 2;
    if (location.startsWith('/tracking')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0: context.go('/home'); break;
      case 1: context.go('/exercises'); break;
      case 2: context.go('/programs'); break;
      case 3: context.go('/tracking'); break;
      case 4: context.go('/profile'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getIndex(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => _onTap(context, i),
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Exo2', fontSize: 10, fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Exo2', fontSize: 10,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center_outlined),
              activeIcon: Icon(Icons.fitness_center_rounded),
              label: 'Exercises',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today_rounded),
              label: 'Programs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart_rounded),
              label: 'Tracking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
