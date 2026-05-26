import 'package:flutter/material.dart';

const kAccent = Color(0xFFF59E0B);
const kAccentInk = Color(0xFF1A1206);

extension AppColorsX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get cBg => isDark ? const Color(0xFF111111) : const Color(0xFFFFFFFF);
  Color get cSurface => isDark ? const Color(0xFF111111) : const Color(0xFFFFFFFF);
  Color get cSurface2 => isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFAFAFA);
  Color get cText => isDark ? const Color(0xFFF5F5F5) : const Color(0xFF111111);
  Color get cText2 => isDark ? const Color(0xFFA6A6A6) : const Color(0xFF6B6B6B);
  Color get cText3 => isDark ? const Color(0xFF6E6E6E) : const Color(0xFF9A9A9A);
  Color get cBorder => isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5);
  Color get cBorder2 => isDark ? const Color(0xFF222222) : const Color(0xFFEFEFEF);
  Color get cAccent => kAccent;
  Color get cAccentInk => kAccentInk;
  Color get cAccentTint =>
      isDark ? kAccent.withValues(alpha: 0.14) : kAccent.withValues(alpha: 0.10);
  Color get cPress =>
      isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04);
  Color get cTabBg =>
      isDark ? const Color(0xFF111111).withValues(alpha: 0.92) : const Color(0xFFFFFFFF).withValues(alpha: 0.92);
  Color get cDanger =>
      isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444);
  Color get cDangerTint =>
      isDark ? const Color(0xFFF87171).withValues(alpha: 0.10) : const Color(0xFFEF4444).withValues(alpha: 0.07);
}
