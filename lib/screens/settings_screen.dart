import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/entry.dart';
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
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          value: '${state.streak}',
                          label: 'Day streak',
                          accent: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          value: '${state.entries.length}',
                          label: 'Entries',
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
                          _NameRow(name: state.userName),
                          Divider(height: 1, color: context.cBorder2),
                          _AppearanceRow(themeMode: state.themeMode),
                          Divider(height: 1, color: context.cBorder2),
                          _RemindersRow(
                            enabled: state.remindersEnabled,
                            hour: state.reminderHour,
                            minute: state.reminderMinute,
                          ),
                          Divider(height: 1, color: context.cBorder2),
                          _ExportRow(entries: state.entries),
                          Divider(height: 1, color: context.cBorder2),
                          const _AboutRow(),
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
                      child: _DeleteAllRow(entryCount: state.entries.length),
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
  const _NameRow({required this.name});

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
                  'Your name',
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
      builder: (_) => _NameDialog(initialName: name, appState: appState),
    );
  }
}

class _NameDialog extends StatefulWidget {
  final String initialName;
  final AppState appState;
  const _NameDialog({required this.initialName, required this.appState});

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
    return AlertDialog(
      backgroundColor: context.cSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Your name',
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
          hintText: 'Enter your name',
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
            'Cancel',
            style: GoogleFonts.figtree(color: context.cText2),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.appState.setUserName(_controller.text);
            Navigator.of(context).pop();
          },
          child: Text(
            'Save',
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

// ─── Appearance ──────────────────────────────────────────────────────────────

class _AppearanceRow extends StatelessWidget {
  final ThemeMode themeMode;
  const _AppearanceRow({required this.themeMode});

  String get _label => switch (themeMode) {
        ThemeMode.system => 'System',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
      };

  @override
  Widget build(BuildContext context) {
    return _RowShell(
      label: 'Appearance',
      trailing: _trailingValue(context, _label),
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sheetHandle(context),
            Text(
              'Appearance',
              style: GoogleFonts.figtree(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.cText,
              ),
            ),
            const SizedBox(height: 8),
            ...ThemeMode.values.map((mode) {
              final label = switch (mode) {
                ThemeMode.system => 'System',
                ThemeMode.light => 'Light',
                ThemeMode.dark => 'Dark',
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
  const _RemindersRow({
    required this.enabled,
    required this.hour,
    required this.minute,
  });

  String get _label {
    if (!enabled) return 'Off';
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return _RowShell(
      label: 'Reminders',
      trailing: _trailingValue(context, _label),
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

  Future<void> _setEnabled(bool val) async {
    if (val) {
      // Show rationale before triggering the native permission dialog
      final proceed = await _showNotificationRationale();
      if (!proceed || !mounted) return;

      bool granted;
      try {
        granted = await NotificationService.requestPermission();
      } catch (e) {
        if (mounted) _showPermissionDeniedDialog();
        return;
      }

      if (!mounted) return;
      if (!granted) {
        _showPermissionDeniedDialog();
        return;
      }

      try {
        await widget.appState
            .setReminder(enabled: true, hour: _hour, minute: _minute);
        await NotificationService.scheduleDailyReminder(_hour, _minute);
      } catch (e) {
        if (!mounted) return;
        await widget.appState.setReminder(enabled: false);
        _showDialog(
          title: 'Could not set reminder',
          message: 'An error occurred: ${e.runtimeType}. Please try again.',
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

  void _showPermissionDeniedDialog() {
    final ctx = widget.parentContext;
    showDialog<void>(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: ctx.cSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Notifications blocked',
          style: GoogleFonts.figtree(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ctx.cText,
          ),
        ),
        content: Text(
          'Allow notifications for DayDump in your device settings to receive daily reminders.',
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
              'Not now',
              style: GoogleFonts.figtree(color: ctx.cText2),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              AppSettings.openAppSettings(type: AppSettingsType.notification);
            },
            child: Text(
              'Open Settings',
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
              'OK',
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
          picked.hour, picked.minute);
    } catch (e) {
      if (mounted) {
        _showDialog(
          title: 'Could not set reminder',
          message: 'An error occurred: ${e.runtimeType}. Please try again.',
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sheetHandle(context),
            Text(
              'Reminders',
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
                    'Daily reminder',
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
                                    'Time',
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
  const _ExportRow({required this.entries});

  @override
  Widget build(BuildContext context) {
    return _RowShell(
      label: 'Export all entries',
      trailing:
          Icon(Icons.ios_share_rounded, color: context.cText3, size: 18),
      onTap: _export,
    );
  }

  void _export() {
    if (entries.isEmpty) return;
    final sorted = [...entries]..sort((a, b) => a.date.compareTo(b.date));
    final buffer = StringBuffer()
      ..writeln('DayDump — My Journal')
      ..writeln(
          '${sorted.length} ${sorted.length == 1 ? 'entry' : 'entries'}\n');
    for (final entry in sorted) {
      buffer
        ..writeln(entry.toExportText())
        ..writeln();
    }
    Share.share(buffer.toString(), subject: 'My DayDump Journal');
  }
}

// ─── Danger zone ─────────────────────────────────────────────────────────────

class _DeleteAllRow extends StatelessWidget {
  final int entryCount;
  const _DeleteAllRow({required this.entryCount});

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
                  'Delete all entries',
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
    return AlertDialog(
      backgroundColor: context.cSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Delete all entries?',
        style: GoogleFonts.figtree(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: context.cText,
        ),
      ),
      content: Text(
        'This will permanently delete $entryCount ${entryCount == 1 ? 'entry' : 'entries'}. This cannot be undone.',
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
            'Cancel',
            style: GoogleFonts.figtree(color: context.cText2),
          ),
        ),
        TextButton(
          onPressed: () {
            appState.clearAllData();
            Navigator.of(context).pop();
          },
          child: Text(
            'Delete all',
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
              'Allow daily reminders',
              style: GoogleFonts.figtree(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: context.cText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'DayDump will send you a reminder at $timeStr each day to complete your check-in.',
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
              label: 'Allow notifications',
              onTap: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: 'Not now',
              onTap: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── About ───────────────────────────────────────────────────────────────────

class _AboutRow extends StatelessWidget {
  const _AboutRow();

  @override
  Widget build(BuildContext context) {
    return _RowShell(
      label: 'About DayDump',
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
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
                      'Version 1.0.0',
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cSurface2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.cBorder),
              ),
              child: Text(
                'Frictionless end-of-day journaling.\n3 questions. 5 minutes. All data stays on your device.',
                style: GoogleFonts.figtree(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: context.cText2,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Made with Flutter · No cloud, no account',
              style: GoogleFonts.figtree(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: context.cText3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
