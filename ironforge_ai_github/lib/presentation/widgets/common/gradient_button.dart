// lib/presentation/widgets/common/gradient_button.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final double height;
  final double? width;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.height = 52,
    this.width,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed != null ? AppColors.primaryGradient : const LinearGradient(
            colors: [Color(0xFF444444), Color(0xFF333333)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: onPressed != null
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 4))]
              : [],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.zero,
          ),
          child: isLoading
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20, color: Colors.black),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: AppColors.card,
          border: Border.all(
            color: borderColor ?? AppColors.border,
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!, style: const TextStyle(
              fontFamily: 'Exo2', fontSize: 13, color: AppColors.primary,
            )),
          ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(label, style: const TextStyle(
                  fontFamily: 'Exo2', fontSize: 12, color: AppColors.textTertiary,
                )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              text: value,
              style: TextStyle(
                fontFamily: 'Rajdhani', fontSize: 26, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              children: unit != null ? [
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(fontSize: 13, color: AppColors.textTertiary),
                ),
              ] : [],
            ),
          ),
        ],
      ),
    );
  }
}

class MuscleGroupChip extends StatelessWidget {
  final String muscle;
  final bool selected;
  final VoidCallback onTap;

  const MuscleGroupChip({super.key, required this.muscle, required this.selected, required this.onTap});

  Color _getColor() {
    switch (muscle.toLowerCase()) {
      case 'chest': return AppColors.chest;
      case 'back': return AppColors.back;
      case 'shoulders': return AppColors.shoulders;
      case 'biceps': return AppColors.biceps;
      case 'triceps': return AppColors.triceps;
      case 'abs': return AppColors.abs;
      case 'legs': return AppColors.legs;
      case 'calves': return AppColors.calves;
      case 'glutes': return AppColors.glutes;
      case 'forearms': return AppColors.forearms;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected ? color.withOpacity(0.2) : AppColors.surfaceVariant,
          border: Border.all(
            color: selected ? color : AppColors.border,
            width: selected ? 1.5 : 0.5,
          ),
        ),
        child: Text(muscle, style: TextStyle(
          fontFamily: 'Exo2', fontSize: 13, fontWeight: FontWeight.w600,
          color: selected ? color : AppColors.textSecondary,
        )),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 24),
            GradientButton(onPressed: onAction, label: actionLabel!),
          ],
        ],
      ),
    );
  }
}
