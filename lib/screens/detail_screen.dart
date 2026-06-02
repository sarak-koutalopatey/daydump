import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_strings.dart';
import '../models/entry.dart';
import '../theme/app_colors.dart';
import '../widgets/pressable.dart';
import '../widgets/secondary_button.dart';

class DetailScreen extends StatefulWidget {
  final JournalEntry entry;

  const DetailScreen({super.key, required this.entry});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _exported = false;

  Future<void> _export() async {
    final exportText = widget.entry.toExportText(context.s);
    await Clipboard.setData(ClipboardData(text: exportText));
    if (!mounted) return;
    setState(() => _exported = true);
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _exported = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final blocks = [
      (label: s.labelAccomplished, q: s.exportQ1, answer: widget.entry.accomplished),
      (label: s.labelGotInTheWay, q: s.exportQ2, answer: widget.entry.blockers),
      (label: s.labelTomorrow, q: s.exportQ3, answer: widget.entry.tomorrow),
    ];

    return Scaffold(
      backgroundColor: context.cBg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 8, 16, 0),
                    child: Row(
                      children: [
                        Pressable(
                          onTap: () => Navigator.of(context).pop(),
                          useBackgroundShift: true,
                          borderRadius: BorderRadius.circular(999),
                          child: SizedBox(
                            width: 44,
                            height: 44,
                            child: Center(
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: context.cText,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.entry.dayLabelFor(s),
                          style: GoogleFonts.figtree(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: context.cText,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.entry.dateLabelFor(s),
                          style: GoogleFonts.figtree(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: context.cText3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      blocks.asMap().entries.map((mapEntry) {
                        final i = mapEntry.key;
                        final b = mapEntry.value;
                        return Padding(
                          padding: EdgeInsets.only(top: i == 0 ? 0 : 24),
                          child: _AnswerBlock(
                            label: b.label,
                            question: b.q,
                            answer: b.answer,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _ExportBar(exported: _exported, s: s, onExport: _export),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerBlock extends StatelessWidget {
  final String label;
  final String question;
  final String answer;

  const _AnswerBlock({
    required this.label,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: context.cText3,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          question,
          style: GoogleFonts.figtree(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: context.cText2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          answer.isNotEmpty ? answer : '—',
          style: GoogleFonts.figtree(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: context.cText,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ExportBar extends StatelessWidget {
  final bool exported;
  final AppStrings s;
  final VoidCallback onExport;

  const _ExportBar({
    required this.exported,
    required this.s,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            context.cBg,
            context.cBg,
            context.cBg.withValues(alpha: 0),
          ],
          stops: const [0, 0.65, 1],
        ),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottom + 12),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: exported
            ? SecondaryButton(
                key: const ValueKey('copied'),
                label: s.copiedToClipboard,
                leading: Icon(Icons.check_rounded, color: context.cAccent, size: 18),
                onTap: null,
              )
            : SecondaryButton(
                key: const ValueKey('export'),
                label: s.exportAsText,
                leading: const Icon(Icons.download_outlined, size: 18),
                onTap: onExport,
              ),
      ),
    );
  }
}
