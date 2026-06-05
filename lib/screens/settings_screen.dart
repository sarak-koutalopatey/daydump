import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_strings.dart';
import '../models/entry.dart';
import 'onboarding_screen.dart';
import '../services/notification_service.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/pressable.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';

class SettingsScreen extends StatelessWidget {
  final ValueChanged<NavTab> onTabChange;
  const SettingsScreen({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = context.s;
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
                    s.settingsTitle,
                    style: GoogleFonts.figtree(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: context.cText,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          value: '${state.streak}',
                          label: s.dayStreak,
                          accent: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          value: '${state.entries.length}',
                          label: s.entriesLabel,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: context.cSurface,
                      border: Border.all(color: context.cBorder),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        children: [
                          _NameRow(name: state.userName, s: s),
                          Divider(height: 1, color: context.cBorder2),
                          _LanguageRow(languageCode: state.languageCode, s: s),
                          Divider(height: 1, color: context.cBorder2),
                          _AppearanceRow(themeMode: state.themeMode, s: s),
                          Divider(height: 1, color: context.cBorder2),
                          _RemindersRow(
                            enabled: state.remindersEnabled,
                            hour: state.reminderHour,
                            minute: state.reminderMinute,
                            s: s,
                          ),
                          Divider(height: 1, color: context.cBorder2),
                          _ExportRow(entries: state.entries, s: s),
                          Divider(height: 1, color: context.cBorder2),
                          _ImportRow(s: s),
                          Divider(height: 1, color: context.cBorder2),
                          _HelpRow(s: s),
                          Divider(height: 1, color: context.cBorder2),
                          _AboutRow(s: s),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: context.cDangerTint,
                      border: Border.all(
                          color: context.cDanger.withValues(alpha: 0.35)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _DeleteAllRow(entryCount: state.entries.length, s: s),
                    ),
                  ),
                  const SizedBox(height: 32),
                  /*Center(
                    child: Text(
                      s.footer,
                      style: GoogleFonts.figtree(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: context.cText3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),*/
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared helpers ──────────────────────────────────────────────────────────

Widget _sheetHandle(BuildContext context) {
  return Column(
    children: [
      Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: context.cBorder,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
      const SizedBox(height: 20),
    ],
  );
}

class _RowShell extends StatelessWidget {
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;

  const _RowShell({
    required this.label,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap ?? () {},
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
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

Widget _trailingValue(BuildContext context, String label) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        label,
        style: GoogleFonts.figtree(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: context.cText2,
        ),
      ),
      const SizedBox(width: 4),
      Icon(Icons.chevron_right_rounded, color: context.cText3, size: 18),
    ],
  );
}

// ─── Stat card ───────────────────────────────────────────────────────────────

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

// ─── Your name ───────────────────────────────────────────────────────────────

class _NameRow extends StatelessWidget {
  final String name;
  final AppStrings s;
  const _NameRow({required this.name, required this.s});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () => _showEditDialog(context),
      useBackgroundShift: true,
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  s.yourName,
                  style: GoogleFonts.figtree(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: context.cText,
                  ),
                ),
              ),
              Text(
                name,
                style: GoogleFonts.figtree(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: context.cText2,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, color: context.cText3, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final appState = context.read<AppState>();
    showDialog<void>(
      context: context,
      builder: (_) => _NameDialog(initialName: name, appState: appState, s: s),
    );
  }
}

class _NameDialog extends StatefulWidget {
  final String initialName;
  final AppState appState;
  final AppStrings s;
  const _NameDialog({
    required this.initialName,
    required this.appState,
    required this.s,
  });

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    return AlertDialog(
      backgroundColor: context.cSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        s.yourName,
        style: GoogleFonts.figtree(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: context.cText,
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        style: GoogleFonts.figtree(fontSize: 16, color: context.cText),
        cursorColor: context.cAccent,
        decoration: InputDecoration(
          hintText: s.enterYourName,
          hintStyle: GoogleFonts.figtree(color: context.cText3),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: context.cBorder),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: context.cAccent),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            s.cancel,
            style: GoogleFonts.figtree(color: context.cText2),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.appState.setUserName(_controller.text);
            Navigator.of(context).pop();
          },
          child: Text(
            s.save,
            style: GoogleFonts.figtree(
              color: context.cAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Language ────────────────────────────────────────────────────────────────

class _LanguageRow extends StatelessWidget {
  final String? languageCode;
  final AppStrings s;
  const _LanguageRow({required this.languageCode, required this.s});

  @override
  Widget build(BuildContext context) {
    final label = switch (languageCode) {
      'en' => s.languageEnglish,
      'fr' => s.languageFrench,
      _ => s.languageSystem,
    };
    return _RowShell(
      label: s.language,
      trailing: _trailingValue(context, label),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        backgroundColor: context.cSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => _LanguageSheet(appState: context.read<AppState>()),
      ),
    );
  }
}

class _LanguageSheet extends StatelessWidget {
  final AppState appState;
  const _LanguageSheet({required this.appState});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final options = [
      (code: null as String?, label: s.languageSystem),
      (code: 'en' as String?, label: s.languageEnglish),
      (code: 'fr' as String?, label: s.languageFrench),
    ];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sheetHandle(context),
            Text(
              s.language,
              style: GoogleFonts.figtree(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.cText,
              ),
            ),
            const SizedBox(height: 8),
            ...options.map((opt) {
              final selected = appState.languageCode == opt.code;
              return Pressable(
                onTap: () {
                  appState.setLanguageCode(opt.code);
                  Navigator.of(context).pop();
                },
                useBackgroundShift: true,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          opt.label,
                          style: GoogleFonts.figtree(
                            fontSize: 16,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w400,
                            color: context.cText,
                          ),
                        ),
                      ),
                      if (selected)
                        Icon(Icons.check_rounded,
                            color: context.cAccent, size: 20),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─── Appearance ──────────────────────────────────────────────────────────────

class _AppearanceRow extends StatelessWidget {
  final ThemeMode themeMode;
  final AppStrings s;
  const _AppearanceRow({required this.themeMode, required this.s});

  @override
  Widget build(BuildContext context) {
    final label = switch (themeMode) {
      ThemeMode.system => s.appearanceSystem,
      ThemeMode.light => s.appearanceLight,
      ThemeMode.dark => s.appearanceDark,
    };
    return _RowShell(
      label: s.appearance,
      trailing: _trailingValue(context, label),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        backgroundColor: context.cSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => _AppearanceSheet(appState: context.read<AppState>()),
      ),
    );
  }
}

class _AppearanceSheet extends StatelessWidget {
  final AppState appState;
  const _AppearanceSheet({required this.appState});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sheetHandle(context),
            Text(
              s.appearance,
              style: GoogleFonts.figtree(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.cText,
              ),
            ),
            const SizedBox(height: 8),
            ...ThemeMode.values.map((mode) {
              final label = switch (mode) {
                ThemeMode.system => s.appearanceSystem,
                ThemeMode.light => s.appearanceLight,
                ThemeMode.dark => s.appearanceDark,
              };
              final selected = appState.themeMode == mode;
              return Pressable(
                onTap: () {
                  appState.setThemeMode(mode);
                  Navigator.of(context).pop();
                },
                useBackgroundShift: true,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: GoogleFonts.figtree(
                            fontSize: 16,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w400,
                            color: context.cText,
                          ),
                        ),
                      ),
                      if (selected)
                        Icon(Icons.check_rounded,
                            color: context.cAccent, size: 20),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─── Reminders ───────────────────────────────────────────────────────────────

class _RemindersRow extends StatelessWidget {
  final bool enabled;
  final int hour;
  final int minute;
  final AppStrings s;
  const _RemindersRow({
    required this.enabled,
    required this.hour,
    required this.minute,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    final label = enabled
        ? '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}'
        : s.remindersOff;
    return _RowShell(
      label: s.reminders,
      trailing: _trailingValue(context, label),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        backgroundColor: context.cSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => _RemindersSheet(
          appState: context.read<AppState>(),
          parentContext: context,
        ),
      ),
    );
  }
}

class _RemindersSheet extends StatefulWidget {
  final AppState appState;
  final BuildContext parentContext;
  const _RemindersSheet({
    required this.appState,
    required this.parentContext,
  });

  @override
  State<_RemindersSheet> createState() => _RemindersSheetState();
}

class _RemindersSheetState extends State<_RemindersSheet> {
  late bool _enabled;
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    _enabled = widget.appState.remindersEnabled;
    _hour = widget.appState.reminderHour;
    _minute = widget.appState.reminderMinute;
  }

  String get _lang =>
      Localizations.localeOf(widget.parentContext).languageCode;

  Future<void> _setEnabled(bool val) async {
    final s = widget.parentContext.s;
    if (val) {
      final proceed = await _showNotificationRationale();
      if (!proceed || !mounted) return;

      bool granted;
      try {
        granted = await NotificationService.requestPermission();
      } catch (e) {
        if (mounted) _showPermissionDeniedDialog(s);
        return;
      }

      if (!mounted) return;
      if (!granted) {
        _showPermissionDeniedDialog(s);
        return;
      }

      try {
        await widget.appState
            .setReminder(enabled: true, hour: _hour, minute: _minute);
        await NotificationService.scheduleDailyReminder(_hour, _minute,
            lang: _lang);
      } catch (e) {
        if (!mounted) return;
        await widget.appState.setReminder(enabled: false);
        _showDialog(
          title: s.couldNotSetReminder,
          message: s.errorOccurred(e.runtimeType.toString()),
        );
        return;
      }

      if (mounted) setState(() => _enabled = true);
    } else {
      try {
        await widget.appState.setReminder(enabled: false);
        await NotificationService.cancel();
      } catch (_) {}
      if (mounted) setState(() => _enabled = false);
    }
  }

  Future<bool> _showNotificationRationale() async {
    final result = await showModalBottomSheet<bool>(
      context: widget.parentContext,
      useRootNavigator: true,
      backgroundColor: widget.parentContext.cSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>
          _NotificationPermissionSheet(hour: _hour, minute: _minute),
    );
    return result == true;
  }

  void _showPermissionDeniedDialog(AppStrings s) {
    final ctx = widget.parentContext;
    showDialog<void>(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: ctx.cSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          s.notificationsBlocked,
          style: GoogleFonts.figtree(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ctx.cText,
          ),
        ),
        content: Text(
          s.notificationsBlockedMessage,
          style: GoogleFonts.figtree(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: ctx.cText2,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              s.notNow,
              style: GoogleFonts.figtree(color: ctx.cText2),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              AppSettings.openAppSettings(type: AppSettingsType.notification);
            },
            child: Text(
              s.openSettings,
              style: GoogleFonts.figtree(
                color: kAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog({required String title, required String message}) {
    final ctx = widget.parentContext;
    final s = ctx.s;
    showDialog<void>(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: ctx.cSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: GoogleFonts.figtree(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ctx.cText,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.figtree(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: ctx.cText2,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              s.ok,
              style: GoogleFonts.figtree(
                color: kAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime() async {
    final s = context.s;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hour, minute: _minute),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme:
              Theme.of(ctx).colorScheme.copyWith(primary: kAccent),
        ),
        child: child!,
      ),
    );
    if (picked == null || !mounted) return;
    try {
      await widget.appState.setReminder(
          enabled: true, hour: picked.hour, minute: picked.minute);
      await NotificationService.scheduleDailyReminder(
          picked.hour, picked.minute,
          lang: _lang);
    } catch (e) {
      if (mounted) {
        _showDialog(
          title: s.couldNotSetReminder,
          message: s.errorOccurred(e.runtimeType.toString()),
        );
      }
      return;
    }
    if (!mounted) return;
    setState(() {
      _hour = picked.hour;
      _minute = picked.minute;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sheetHandle(context),
            Text(
              s.reminders,
              style: GoogleFonts.figtree(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.cText,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    s.dailyReminder,
                    style: GoogleFonts.figtree(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: context.cText,
                    ),
                  ),
                ),
                Switch(
                  value: _enabled,
                  onChanged: _setEnabled,
                  activeColor: kAccent,
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: _enabled
                  ? Column(
                      children: [
                        Divider(height: 1, color: context.cBorder2),
                        Pressable(
                          onTap: _pickTime,
                          useBackgroundShift: true,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    s.time,
                                    style: GoogleFonts.figtree(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: context.cText,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}',
                                  style: GoogleFonts.figtree(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: context.cAccent,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.chevron_right_rounded,
                                    color: context.cText3, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Export all entries ──────────────────────────────────────────────────────

class _ExportRow extends StatelessWidget {
  final List<JournalEntry> entries;
  final AppStrings s;
  const _ExportRow({required this.entries, required this.s});

  @override
  Widget build(BuildContext context) {
    return _RowShell(
      label: s.exportAllEntries,
      trailing:
          Icon(Icons.ios_share_rounded, color: context.cText3, size: 18),
      onTap: () => _export(context),
    );
  }

  Future<void> _export(BuildContext context) async {
    if (entries.isEmpty) return;
    final s = context.s;
    final dir = await getTemporaryDirectory();
    final now = DateTime.now();
    final filename =
        'daydump_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}.json';
    final file = File('${dir.path}/$filename');
    await file.writeAsString(jsonEncode({
      'version': 1,
      'entries': entries.map((e) => e.toJson()).toList(),
    }));
    if (!context.mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    final origin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : Rect.fromLTWH(0, 0, 100, 100);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/json')],
      subject: s.exportJournalHeader,
      sharePositionOrigin: origin,
    );
  }
}

// ─── Import entries ──────────────────────────────────────────────────────────

class _ImportRow extends StatelessWidget {
  final AppStrings s;
  const _ImportRow({required this.s});

  @override
  Widget build(BuildContext context) {
    return _RowShell(
      label: s.importAllEntries,
      trailing: Icon(Icons.download_rounded, color: context.cText3, size: 18),
      onTap: () => _import(context),
    );
  }

  Future<void> _import(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null) return;

    try {
      final content = await File(path).readAsString();
      final decoded = jsonDecode(content) as Map<String, dynamic>;
      if (decoded['version'] != 1) throw const FormatException('unknown version');
      final rawList = decoded['entries'] as List<dynamic>;
      final entries = rawList
          .map((e) => JournalEntry.fromJson(e as Map<String, dynamic>))
          .toList();

      if (!context.mounted) return;
      final count = await context.read<AppState>().importEntries(entries);
      if (!context.mounted) return;
      _showDialog(context, context.s.importSuccess(count));
    } catch (_) {
      if (!context.mounted) return;
      _showDialog(context, context.s.importError);
    }
  }

  void _showDialog(BuildContext context, String message) {
    final s = context.s;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.cSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          s.importTitle,
          style: GoogleFonts.figtree(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: context.cText,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.figtree(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: context.cText2,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              s.ok,
              style: GoogleFonts.figtree(
                color: kAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Danger zone ─────────────────────────────────────────────────────────────

class _DeleteAllRow extends StatelessWidget {
  final int entryCount;
  final AppStrings s;
  const _DeleteAllRow({required this.entryCount, required this.s});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () => _confirm(context),
      useBackgroundShift: true,
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  s.deleteAllEntries,
                  style: GoogleFonts.figtree(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: context.cDanger,
                  ),
                ),
              ),
              Icon(Icons.delete_outline_rounded,
                  color: context.cDanger, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  void _confirm(BuildContext context) {
    final appState = context.read<AppState>();
    showDialog<void>(
      context: context,
      builder: (_) => _DeleteAllDialog(
        entryCount: entryCount,
        appState: appState,
      ),
    );
  }
}

class _DeleteAllDialog extends StatelessWidget {
  final int entryCount;
  final AppState appState;
  const _DeleteAllDialog(
      {required this.entryCount, required this.appState});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return AlertDialog(
      backgroundColor: context.cSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        s.deleteAllEntriesTitle,
        style: GoogleFonts.figtree(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: context.cText,
        ),
      ),
      content: Text(
        s.deleteAllEntriesMessage(entryCount),
        style: GoogleFonts.figtree(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: context.cText2,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            s.cancel,
            style: GoogleFonts.figtree(color: context.cText2),
          ),
        ),
        TextButton(
          onPressed: () {
            appState.clearAllData();
            Navigator.of(context).pop();
          },
          child: Text(
            s.deleteAll,
            style: GoogleFonts.figtree(
              color: context.cDanger,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Notification permission rationale ───────────────────────────────────────

class _NotificationPermissionSheet extends StatelessWidget {
  final int hour;
  final int minute;
  const _NotificationPermissionSheet({required this.hour, required this.minute});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final timeStr =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _sheetHandle(context),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: context.cAccentTint,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.notifications_rounded,
                  color: context.cAccent, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              s.allowDailyReminders,
              style: GoogleFonts.figtree(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: context.cText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              s.reminderDescription(timeStr),
              style: GoogleFonts.figtree(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: context.cText2,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: s.allowNotifications,
              onTap: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: s.notNow,
              onTap: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Help ────────────────────────────────────────────────────────────────────

class _HelpRow extends StatelessWidget {
  final AppStrings s;
  const _HelpRow({required this.s});

  @override
  Widget build(BuildContext context) {
    return _RowShell(
      label: s.help,
      trailing: Icon(Icons.help_outline_rounded, color: context.cText3, size: 18),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const OnboardingScreen(isReview: true),
          fullscreenDialog: true,
        ),
      ),
    );
  }
}

// ─── About ───────────────────────────────────────────────────────────────────

class _AboutRow extends StatelessWidget {
  final AppStrings s;
  const _AboutRow({required this.s});

  @override
  Widget build(BuildContext context) {
    return _RowShell(
      label: s.aboutDayDump,
      trailing:
          Icon(Icons.chevron_right_rounded, color: context.cText3, size: 18),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        backgroundColor: context.cSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => const _AboutSheet(),
      ),
    );
  }
}

class _AboutSheet extends StatelessWidget {
  const _AboutSheet();

  static const _roles = [
    'Design',
    'Développement',
    'Produit',
    'Copywriting',
  ];

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sheetHandle(context),
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: context.cAccentTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.wb_sunny_rounded,
                      color: context.cAccent, size: 28),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DayDump',
                      style: GoogleFonts.figtree(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: context.cText,
                      ),
                    ),
                    Text(
                      s.version,
                      style: GoogleFonts.figtree(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: context.cText2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            /*Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cSurface2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.cBorder),
              ),
              child: Text(
                s.aboutDescription,
                style: GoogleFonts.figtree(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: context.cText2,
                  height: 1.5,
                ),
              ),
            ),*/
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cSurface2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.cBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.credits,
                    style: GoogleFonts.figtree(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.cText2,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._roles.map((role) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                role,
                                style: GoogleFonts.figtree(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: context.cText2,
                                ),
                              ),
                            ),
                            Text(
                              'Sarah KOUTA-LOPATEY',
                              style: GoogleFonts.figtree(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: context.cText,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Pressable(
              onTap: () => launchUrl(
                Uri.parse('https://www.sarah-koutalopatey.fr/'),
                mode: LaunchMode.externalApplication,
              ),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'www.sarah-koutalopatey.fr',
                      style: GoogleFonts.figtree(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: context.cAccent,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.open_in_new_rounded,
                        size: 13, color: context.cAccent),
                  ],
                ),
              ),
            ),
            /*const SizedBox(height: 4),
            Text(
              s.madeWith,
              style: GoogleFonts.figtree(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: context.cText3,
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
