import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/pressable.dart';

class SettingsScreen extends StatelessWidget {
  final ValueChanged<NavTab> onTabChange;

  const SettingsScreen({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final menuItems = ['Reminders', 'Appearance', 'Export all entries', 'About DayDump'];

    return Scaffold(
      backgroundColor: context.cBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),
                  Text(
                    'Settings',
                    style: GoogleFonts.figtree(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: context.cText,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Stats row
                  Row(
                    children: [
                      Expanded(child: _StatCard(value: '${state.streak}', label: 'Day streak', accent: true)),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(value: '${state.entries.length}', label: 'Entries')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Settings list
                  Container(
                    decoration: BoxDecoration(
                      color: context.cSurface,
                      border: Border.all(color: context.cBorder),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        children: menuItems.asMap().entries.map((mapEntry) {
                          final i = mapEntry.key;
                          final label = mapEntry.value;
                          return Column(
                            children: [
                              if (i > 0)
                                Divider(height: 1, color: context.cBorder2),
                              _SettingsRow(label: label),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      'DayDump · All data stays on your device',
                      style: GoogleFonts.figtree(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: context.cText3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final bool accent;

  const _StatCard({
    required this.value,
    required this.label,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cSurface2,
        border: Border.all(color: context.cBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.figtree(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: accent ? context.cAccent : context.cText,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.figtree(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: context.cText2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String label;

  const _SettingsRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () {},
      useBackgroundShift: true,
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.figtree(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: context.cText,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: context.cText3, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
