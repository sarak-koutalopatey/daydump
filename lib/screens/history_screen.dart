import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../models/entry.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/pressable.dart';
import 'detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  final ValueChanged<NavTab> onTabChange;

  const HistoryScreen({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = context.s;
    final thisWeek = state.thisWeekEntries;
    final lastWeek = state.lastWeekEntries;

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        s.historyTitle,
                        style: GoogleFonts.figtree(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: context.cText,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        s.entriesCount(state.entries.length),
                        style: GoogleFonts.figtree(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: context.cText2,
                        ),
                      ),
                    ],
                  ),
                  if (thisWeek.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _HistoryGroup(
                      label: s.thisWeek,
                      entries: thisWeek,
                      s: s,
                      onOpenEntry: (e) => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => DetailScreen(entry: e)),
                      ),
                    ),
                  ],
                  if (lastWeek.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _HistoryGroup(
                      label: s.lastWeek,
                      entries: lastWeek,
                      s: s,
                      onOpenEntry: (e) => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => DetailScreen(entry: e)),
                      ),
                    ),
                  ],
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

class _HistoryGroup extends StatelessWidget {
  final String label;
  final List<JournalEntry> entries;
  final AppStrings s;
  final ValueChanged<JournalEntry> onOpenEntry;

  const _HistoryGroup({
    required this.label,
    required this.entries,
    required this.s,
    required this.onOpenEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.figtree(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.cText3,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        ...entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _EntryCard(entry: e, s: s, onTap: () => onOpenEntry(e)),
            )),
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  final JournalEntry entry;
  final AppStrings s;
  final VoidCallback onTap;

  const _EntryCard({required this.entry, required this.s, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      useBackgroundShift: true,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.cSurface,
          border: Border.all(color: context.cBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  entry.dayLabelFor(s),
                  style: GoogleFonts.figtree(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: context.cText,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  entry.dateLabelFor(s),
                  style: GoogleFonts.figtree(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: context.cText3,
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right_rounded, color: context.cText3, size: 16),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              entry.preview,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.figtree(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: context.cText2,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: context.cSurface2,
                border: Border.all(color: context.cBorder2),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_rounded, color: context.cAccent, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    s.threeQuestions,
                    style: GoogleFonts.figtree(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: context.cText2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
