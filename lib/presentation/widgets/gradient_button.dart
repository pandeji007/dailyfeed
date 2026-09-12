import 'package:dailyfeed/core/app_theme.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient = AppTheme.primaryGradient,
    this.height = 50,
    this.borderRadius,
    this.elevation = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Gradient gradient;
  final double height;
  final BorderRadius? borderRadius;
  final bool elevation;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(12);
    final isEnabled = onPressed != null;

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: isEnabled ? gradient : null,
        color: isEnabled
            ? null
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
        borderRadius: radius,
        boxShadow: isEnabled && elevation
            ? [
                BoxShadow(
                  color: AppTheme.primaryStart.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              child: IconTheme(
                data: const IconThemeData(color: Colors.white),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
