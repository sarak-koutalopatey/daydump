import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../services/notification_service.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/pressable.dart';
import '../widgets/primary_button.dart';
import 'main_scaffold.dart';

class OnboardingScreen extends StatefulWidget {
  /// isReview = true when opened from Settings > Help (no completion tracking)
  final bool isReview;

  const OnboardingScreen({super.key, this.isReview = false});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  int get _pageCount => widget.isReview ? 4 : 5;
  bool get _isLast => _currentPage == _pageCount - 1;
  bool get _isNotifPage => !widget.isReview && _isLast;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  void _skip() {
    _pageController.animateToPage(
      _pageCount - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _complete() {
    if (widget.isReview) {
      Navigator.of(context).pop();
      return;
    }
    context.read<AppState>().setOnboardingCompleted();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainScaffold(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  Future<void> _allowAndComplete() async {
    bool granted = false;
    try {
      granted = await NotificationService.requestPermission();
    } catch (_) {}

    if (granted && mounted) {
      final appState = context.read<AppState>();
      final lang = Localizations.localeOf(context).languageCode;
      await appState.setReminder(enabled: true, hour: 20, minute: 0);
      await NotificationService.scheduleDailyReminder(20, 0, lang: lang);
    }

    if (mounted) _complete();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final pages = _buildPages(s);

    return Scaffold(
      backgroundColor: context.cBg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            SizedBox(
              height: 52,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    if (widget.isReview)
                      Pressable(
                        onTap: () => Navigator.of(context).pop(),
                        useBackgroundShift: true,
                        borderRadius: BorderRadius.circular(999),
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Center(
                            child: Icon(Icons.close_rounded, size: 22),
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 44),
                    const Spacer(),
                    if (!_isLast && !widget.isReview)
                      Pressable(
                        onTap: _skip,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Text(
                            s.skip,
                            style: GoogleFonts.figtree(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: context.cText2,
                            ),
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 44),
                  ],
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pageCount,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _OnboardingPage(data: pages[i]),
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                children: [
                  // Dot indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pageCount, (i) {
                      final active = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 6,
                        width: active ? 24 : 6,
                        decoration: BoxDecoration(
                          color: active ? context.cAccent : context.cBorder,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  if (_isNotifPage) ...[
                    PrimaryButton(
                      label: s.allowNotifications,
                      onTap: _allowAndComplete,
                    ),
                    const SizedBox(height: 14),
                    Pressable(
                      onTap: _complete,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          s.notNow,
                          style: GoogleFonts.figtree(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: context.cText2,
                          ),
                        ),
                      ),
                    ),
                  ] else
                    PrimaryButton(
                      label: _isLast
                          ? (widget.isReview ? s.close : s.getStarted)
                          : s.next,
                      trailing: _isLast
                          ? null
                          : const Icon(Icons.arrow_forward_rounded),
                      onTap: _goNext,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_PageData> _buildPages(AppStrings s) {
    final pages = [
      _PageData(
        icon: Icons.wb_sunny_rounded,
        bgColor: context.cAccentTint,
        iconColor: context.cAccent,
        title: s.onboarding1Title,
        subtitle: s.onboarding1Subtitle,
      ),
      _PageData(
        icon: Icons.edit_note_rounded,
        bgColor: context.cSurface2,
        iconColor: context.cText2,
        title: s.onboarding2Title,
        subtitle: s.onboarding2Subtitle,
      ),
      _PageData(
        icon: Icons.local_fire_department_rounded,
        bgColor: context.cAccentTint,
        iconColor: context.cAccent,
        title: s.onboarding3Title,
        subtitle: s.onboarding3Subtitle,
      ),
      _PageData(
        icon: Icons.lock_outline_rounded,
        bgColor: context.cSurface2,
        iconColor: context.cText2,
        title: s.onboarding4Title,
        subtitle: s.onboarding4Subtitle,
      ),
    ];

    if (!widget.isReview) {
      pages.add(_PageData(
        icon: Icons.notifications_rounded,
        bgColor: context.cAccentTint,
        iconColor: context.cAccent,
        title: s.onboarding5Title,
        subtitle: s.onboarding5Subtitle,
      ));
    }

    return pages;
  }
}

// ─── Page data ────────────────────────────────────────────────────────────────

class _PageData {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _PageData({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });
}

// ─── Single page ──────────────────────────────────────────────────────────────

class _OnboardingPage extends StatelessWidget {
  final _PageData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TODO: replace with final illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: data.bgColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(data.icon, size: 80, color: data.iconColor),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.figtree(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: context.cText,
              letterSpacing: -0.3,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.figtree(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: context.cText2,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
