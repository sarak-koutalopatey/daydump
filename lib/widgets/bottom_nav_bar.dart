import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'pressable.dart';

enum NavTab { home, history, settings }

class AppBottomNavBar extends StatelessWidget {
  final NavTab active;
  final ValueChanged<NavTab> onTap;

  const AppBottomNavBar({
    super.key,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: context.cTabBg,
            border: Border(top: BorderSide(color: context.cBorder)),
          ),
          padding: EdgeInsets.only(top: 8, bottom: bottom + 4),
          child: Row(
            children: NavTab.values
                .map((tab) => Expanded(
                      child: _NavItem(
                        tab: tab,
                        isActive: tab == active,
                        onTap: () => onTap(tab),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final NavTab tab;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? context.cAccent : context.cText2;
    return Pressable(
      onTap: onTap,
      useBackgroundShift: true,
      child: SizedBox(
        height: 44,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NavIcon(tab: tab, isActive: isActive, color: color),
            const SizedBox(height: 2),
            Text(
              tab.label,
              style: GoogleFonts.figtree(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: color,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final NavTab tab;
  final bool isActive;
  final Color color;

  const _NavIcon({
    required this.tab,
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    switch (tab) {
      case NavTab.home:
        return Icon(
          isActive ? Icons.home_rounded : Icons.home_outlined,
          color: color,
          size: 24,
        );
      case NavTab.history:
        return Icon(
          isActive ? Icons.history_rounded : Icons.history_outlined,
          color: color,
          size: 24,
        );
      case NavTab.settings:
        return Icon(
          isActive ? Icons.settings_rounded : Icons.settings_outlined,
          color: color,
          size: 24,
        );
    }
  }
}

extension on NavTab {
  String get label {
    switch (this) {
      case NavTab.home:
        return 'Home';
      case NavTab.history:
        return 'History';
      case NavTab.settings:
        return 'Settings';
    }
  }
}
