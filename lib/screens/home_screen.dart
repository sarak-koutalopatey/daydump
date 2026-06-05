import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
//import 'package:intl/intl.dart';
import '../l10n/app_strings.dart';
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
    final s = context.s;
    //final locale = Localizations.localeOf(context).toString();
    //final now = DateTime.now();
    //final dateLine = DateFormat('EEEE, MMMM d', locale).format(now).toUpperCase();

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
                  _GreetingHeader(
                    //dateLine: dateLine,
                    userName: state.userName,
                    completedToday: state.completedToday,
                    s: s,
                  ),
                  const SizedBox(height: 24),
                  _StreakCard(streak: state.streak, s: s),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: state.completedToday ? s.editMyDayDump : s.doMyDayDump,
                    trailing: const Icon(Icons.arrow_forward_rounded),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CheckInScreen(),
                        fullscreenDialog: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _RecentSection(
                    entries: state.entries,
                    s: s,
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
  //final String dateLine;
  final String userName;
  final bool completedToday;
  final AppStrings s;

  const _GreetingHeader({
    //required this.dateLine,
    required this.userName,
    required this.completedToday,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*Text(
          dateLine,
          style: GoogleFonts.figtree(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: context.cText3,
            letterSpacing: 0.4,
          ),
        ),*/
        const SizedBox(height: 6),
        Text(
          s.hiName(userName, DateTime.now().hour),
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
          completedToday ? s.todayLogged : s.howDidTodayGo,
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
  final AppStrings s;
  const _StreakCard({required this.streak, required this.s});

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
                      s.daysInARow,
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
                  s.bestStreak,
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
  final AppStrings s;
  final VoidCallback onViewAll;
  final ValueChanged<JournalEntry> onOpenEntry;

  const _RecentSection({
    required this.entries,
    required this.s,
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
              s.recent,
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
                  s.viewAll,
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
                    _EntryRow(entry: e, s: s, onTap: () => onOpenEntry(e)),
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
  final AppStrings s;
  final VoidCallback onTap;

  const _EntryRow({required this.entry, required this.s, required this.onTap});

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
                        entry.dayLabelFor(s),
                        style: GoogleFonts.figtree(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: context.cText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '· ${entry.dateLabelFor(s)}',
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
