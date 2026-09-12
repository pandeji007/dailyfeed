import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color primaryStart = Color(0xFF4A38D9);
  static const Color primaryMiddle = Color(0xFFD71D89);
  static const Color primaryEnd = Color(0xFFFFA209);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    transform: GradientRotation(50 * 3.141592653589793 / 180),
    colors: [primaryStart, primaryMiddle, primaryEnd],
  );

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme = isDark
        ? const ColorScheme.dark(
            primary: primaryStart,
            onPrimary: Colors.white,
            surface: Color(0xFF121214),
            onSurface: Color(0xFFF4F4F6),
            surfaceContainerHighest: Color(0xFF1E1E22),
            surfaceContainer: Color(0xFF18181B),
            outline: Color(0xFF2E2E33),
            outlineVariant: Color(0xFF2E2E33),
            onSurfaceVariant: Color(0xFFA1A1AA),
            tertiaryContainer: Color(0xFF242428),
            onTertiaryContainer: Color(0xFFF4F4F6),
            error: Color(0xFFEF4444),
            onError: Colors.white,
            errorContainer: Color(0xFF3B1818),
            onErrorContainer: Color(0xFFFCA5A5),
          )
        : const ColorScheme.light(
            primary: primaryStart,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF141416),
            surfaceContainerHighest: Color(0xFFF4F4F6),
            surfaceContainer: Color(0xFFFAFAFC),
            outline: Color(0xFFE5E5EA),
            outlineVariant: Color(0xFFE5E5EA),
            onSurfaceVariant: Color(0xFF71717A),
            tertiaryContainer: Color(0xFFF0F0F4),
            onTertiaryContainer: Color(0xFF141416),
            error: Color(0xFFDC2626),
            onError: Colors.white,
            errorContainer: Color(0xFFFEE2E2),
            onErrorContainer: Color(0xFF991B1B),
          );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? const Color(0xFF000000) : Colors.white,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: isDark ? const Color(0xFF000000) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? const Color(0xFF141416) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF121214) : Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor:
            isDark ? const Color(0xFF242428) : const Color(0xFFF0F0F4),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? scheme.onSurface
                : scheme.onSurfaceVariant,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryStart, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          backgroundColor: primaryStart,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryStart,
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? primaryStart : null,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
