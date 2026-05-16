import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/entry.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/pressable.dart';
import '../widgets/primary_button.dart';
import 'checkin_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<NavTab> onTabChange;

  const HomeScreen({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final now = DateTime.now();
    final dateLine = DateFormat('EEEE, MMMM d').format(now).toUpperCase();

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
                  // Greeting header
                  _GreetingHeader(
                    dateLine: dateLine,
                    userName: state.userName,
                    completedToday: state.completedToday,
                  ),
                  const SizedBox(height: 24),
                  // Streak card
                  _StreakCard(streak: state.streak),
                  const SizedBox(height: 24),
                  // Primary CTA
                  PrimaryButton(
                    label: state.completedToday ? 'Edit my DayDump' : 'Do my DayDump',
                    trailing: const Icon(Icons.arrow_forward_rounded),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CheckInScreen(),
                        fullscreenDialog: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Recent section
                  _RecentSection(
                    entries: state.entries,
                    onViewAll: () => onTabChange(NavTab.history),
                    onOpenEntry: (e) => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => DetailScreen(entry: e)),
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

class _GreetingHeader extends StatelessWidget {
  final String dateLine;
  final String userName;
  final bool completedToday;

  const _GreetingHeader({
    required this.dateLine,
    required this.userName,
    required this.completedToday,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateLine,
          style: GoogleFonts.figtree(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: context.cText3,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Hi, $userName.',
          style: GoogleFonts.figtree(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: context.cText,
            letterSpacing: -0.4,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          completedToday ? 'Today is logged. Nice work.' : 'How did today go?',
          style: GoogleFonts.figtree(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: context.cText2,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int streak;
  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cSurface2,
        border: Border.all(color: context.cBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.cAccentTint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.local_fire_department_rounded, color: context.cAccent, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$streak',
                      style: GoogleFonts.figtree(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: context.cAccent,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'days in a row',
                      style: GoogleFonts.figtree(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: context.cText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Best streak yet. Keep it going.',
                  style: GoogleFonts.figtree(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: context.cText2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentSection extends StatelessWidget {
  final List<JournalEntry> entries;
  final VoidCallback onViewAll;
  final ValueChanged<JournalEntry> onOpenEntry;

  const _RecentSection({
    required this.entries,
    required this.onViewAll,
    required this.onOpenEntry,
  });

  @override
  Widget build(BuildContext context) {
    final recent = entries.take(4).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'RECENT',
              style: GoogleFonts.figtree(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.cText2,
                letterSpacing: 0.6,
              ),
            ),
            const Spacer(),
            Pressable(
              onTap: onViewAll,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'View all',
                  style: GoogleFonts.figtree(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: context.cText2,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: context.cSurface,
            border: Border.all(color: context.cBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: recent.asMap().entries.map((mapEntry) {
                final i = mapEntry.key;
                final e = mapEntry.value;
                return Column(
                  children: [
                    if (i > 0) Divider(height: 1, color: context.cBorder2),
                    _EntryRow(entry: e, onTap: () => onOpenEntry(e)),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _EntryRow extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onTap;

  const _EntryRow({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      useBackgroundShift: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.cAccent, width: 1.5),
                color: context.cAccentTint,
              ),
              child: Icon(Icons.check_rounded, color: context.cAccent, size: 14),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        entry.dayLabel,
                        style: GoogleFonts.figtree(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: context.cText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '· ${entry.dateLabel}',
                        style: GoogleFonts.figtree(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: context.cText3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.figtree(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: context.cText2,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: context.cText3, size: 18),
          ],
        ),
      ),
    );
  }
}
