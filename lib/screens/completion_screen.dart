import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/sample_data.dart';
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
  final String _line =
      kMotivationalLines[Random().nextInt(kMotivationalLines.length)];

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
    return Scaffold(
      backgroundColor: context.cBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 24),
              // Centered celebration content
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
                    'All done.',
                    style: GoogleFonts.figtree(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: context.cText,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Streak badge
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
                          '${widget.streak} days in a row',
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
                      _line,
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
              // Back to home CTA
              PrimaryButton(
                label: 'Back to home',
                onTap: () {
                  // Pop all the way back to MainScaffold
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
