import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entry.dart';
import '../data/sample_data.dart';

class AppState extends ChangeNotifier {
  List<JournalEntry> _entries = [];
  int _streak = 12;
  bool _completedToday = false;
  String _userName = 'Alex';
  ThemeMode _themeMode = ThemeMode.system;
  bool _remindersEnabled = false;
  int _reminderHour = 20;
  int _reminderMinute = 0;

  List<JournalEntry> get entries => _entries;
  int get streak => _streak;
  bool get completedToday => _completedToday;
  String get userName => _userName;
  ThemeMode get themeMode => _themeMode;
  bool get remindersEnabled => _remindersEnabled;
  int get reminderHour => _reminderHour;
  int get reminderMinute => _reminderMinute;

  String get motivationalLine =>
      kMotivationalLines[Random().nextInt(kMotivationalLines.length)];

  List<JournalEntry> get thisWeekEntries =>
      _entries.where((e) {
        final diff = DateTime.now().difference(e.date).inDays;
        return diff < 7;
      }).toList();

  List<JournalEntry> get lastWeekEntries =>
      _entries.where((e) {
        final diff = DateTime.now().difference(e.date).inDays;
        return diff >= 7 && diff < 14;
      }).toList();

  AppState() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('entries');
    if (raw != null && raw.isNotEmpty) {
      _entries = raw
          .map((s) => JournalEntry.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      _streak = prefs.getInt('streak') ?? 0;
      final savedName = prefs.getString('userName');
      if (savedName != null) _userName = savedName;
      final today = _normalizeDate(DateTime.now());
      _completedToday = _entries.isNotEmpty &&
          _normalizeDate(_entries.first.date) == today;
    } else {
      // Seed with sample data on first launch
      _entries = List.from(kSampleEntries);
      _streak = 12;
      _completedToday = true; // "Today" entry is pre-seeded
      await _persist();
    }
    final modeIndex = prefs.getInt('themeMode') ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[modeIndex.clamp(0, ThemeMode.values.length - 1)];
    _remindersEnabled = prefs.getBool('remindersEnabled') ?? false;
    _reminderHour = prefs.getInt('reminderHour') ?? 20;
    _reminderMinute = prefs.getInt('reminderMinute') ?? 0;
    notifyListeners();
  }

  Future<void> addEntry({
    required String accomplished,
    required String blockers,
    required String tomorrow,
  }) async {
    final entry = JournalEntry(
      id: 'entry-${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      accomplished: accomplished,
      blockers: blockers,
      tomorrow: tomorrow,
    );
    // Replace today's entry if one exists, otherwise prepend
    final today = _normalizeDate(DateTime.now());
    _entries.removeWhere((e) => _normalizeDate(e.date) == today);
    _entries.insert(0, entry);
    if (!_completedToday) _streak++;
    _completedToday = true;
    await _persist();
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    _userName = trimmed;
    await _persist();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _persist();
    notifyListeners();
  }

  Future<void> setReminder({
    required bool enabled,
    int? hour,
    int? minute,
  }) async {
    _remindersEnabled = enabled;
    if (hour != null) _reminderHour = hour;
    if (minute != null) _reminderMinute = minute;
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'entries',
      _entries.map((e) => jsonEncode(e.toJson())).toList(),
    );
    await prefs.setInt('streak', _streak);
    await prefs.setString('userName', _userName);
    await prefs.setInt('themeMode', _themeMode.index);
    await prefs.setBool('remindersEnabled', _remindersEnabled);
    await prefs.setInt('reminderHour', _reminderHour);
    await prefs.setInt('reminderMinute', _reminderMinute);
  }

  DateTime _normalizeDate(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);
}
