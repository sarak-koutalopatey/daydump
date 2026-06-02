import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import '../widgets/primary_button.dart';

class CompletionScreen extends StatefulWidget {
  final int streak;

  const CompletionScreen({super.key, required this.streak});

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  final int _lineIndex = Random().nextInt(4);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: const Cubic(0.2, 0.7, 0.2, 1.0),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final line = s.motivationalLines[_lineIndex];

    return Scaffold(
      backgroundColor: context.cBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 24),
              Column(
                children: [
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.cAccentTint,
                      ),
                      child: Icon(
                        Icons.check_circle_outline_rounded,
                        color: context.cAccent,
                        size: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    s.allDone,
                    style: GoogleFonts.figtree(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: context.cText,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: context.cAccentTint,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          color: context.cAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          s.daysInARowBadge(widget.streak),
                          style: GoogleFonts.figtree(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.cAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      line,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.figtree(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: context.cText2,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              PrimaryButton(
                label: s.backToHome,
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
