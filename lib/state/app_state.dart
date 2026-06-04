import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entry.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class AppState extends ChangeNotifier {
  List<JournalEntry> _entries = [];
  int _streak = 0;
  bool _completedToday = false;
  String _userName = 'Alex';
  ThemeMode _themeMode = ThemeMode.system;
  bool _remindersEnabled = false;
  int _reminderHour = 20;
  int _reminderMinute = 0;
  String? _languageCode;
  bool _loaded = false;
  bool _onboardingCompleted = false;

  List<JournalEntry> get entries => _entries;
  int get streak => _streak;
  bool get completedToday => _completedToday;
  String get userName => _userName;
  ThemeMode get themeMode => _themeMode;
  bool get remindersEnabled => _remindersEnabled;
  int get reminderHour => _reminderHour;
  int get reminderMinute => _reminderMinute;
  String? get languageCode => _languageCode;
  bool get loaded => _loaded;
  bool get onboardingCompleted => _onboardingCompleted;

  List<JournalEntry> get thisWeekEntries => _entries.where((e) {
        final diff = DateTime.now().difference(e.date).inDays;
        return diff < 7;
      }).toList();

  List<JournalEntry> get lastWeekEntries => _entries.where((e) {
        final diff = DateTime.now().difference(e.date).inDays;
        return diff >= 7 && diff < 14;
      }).toList();

  AppState() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (kDebugMode) await prefs.clear();

    // Load preferences first (needed to disambiguate first launch vs cleared data)
    final savedName = prefs.getString('userName');
    if (savedName != null) _userName = savedName;
    final modeIndex = prefs.getInt('themeMode') ?? ThemeMode.system.index;
    _themeMode =
        ThemeMode.values[modeIndex.clamp(0, ThemeMode.values.length - 1)];
    _remindersEnabled = prefs.getBool('remindersEnabled') ?? false;
    _reminderHour = prefs.getInt('reminderHour') ?? 20;
    _reminderMinute = prefs.getInt('reminderMinute') ?? 0;
    _languageCode = prefs.getString('languageCode');
    _onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

    // Load entries from SQLite
    final dbEntries = await DatabaseService.getAllEntries();

    if (dbEntries.isNotEmpty) {
      _entries = dbEntries;
      _streak = prefs.getInt('streak') ?? 0;
      final today = _normalizeDate(DateTime.now());
      _completedToday =
          _normalizeDate(_entries.first.date) == today;
    } else {
      // Check for SharedPreferences → SQLite migration (upgrading users)
      final raw = prefs.getStringList('entries');
      if (raw != null && raw.isNotEmpty) {
        _entries = raw
            .map((s) =>
                JournalEntry.fromJson(jsonDecode(s) as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        for (final entry in _entries) {
          await DatabaseService.insertEntry(entry);
        }
        await prefs.remove('entries');
        _streak = prefs.getInt('streak') ?? 0;
        final today = _normalizeDate(DateTime.now());
        _completedToday =
            _entries.isNotEmpty && _normalizeDate(_entries.first.date) == today;
      }
      // onboardingCompleted + empty DB = user cleared data intentionally
    }

    _loaded = true;
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

    // Delete any existing entry for today before inserting the new one
    final today = _normalizeDate(DateTime.now());
    final todayEntries =
        _entries.where((e) => _normalizeDate(e.date) == today).toList();
    for (final old in todayEntries) {
      await DatabaseService.deleteEntry(old.id);
    }
    await DatabaseService.insertEntry(entry);

    _entries.removeWhere((e) => _normalizeDate(e.date) == today);
    _entries.insert(0, entry);

    if (!_completedToday) {
      _streak++;
      if (_remindersEnabled) await NotificationService.cancel();
    }
    _completedToday = true;
    await _persistSettings();
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    _userName = trimmed;
    await _persistSettings();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _persistSettings();
    notifyListeners();
  }

  Future<void> setLanguageCode(String? code) async {
    _languageCode = code;
    await _persistSettings();
    notifyListeners();
  }

  Future<void> setOnboardingCompleted() async {
    _onboardingCompleted = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
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
    await _persistSettings();
    notifyListeners();
  }

  Future<int> importEntries(List<JournalEntry> imported) async {
    for (final entry in imported) {
      await DatabaseService.insertEntry(entry);
    }
    _entries = await DatabaseService.getAllEntries();
    final today = _normalizeDate(DateTime.now());
    _completedToday =
        _entries.isNotEmpty && _normalizeDate(_entries.first.date) == today;
    _streak = _computeStreak(_entries);
    await _persistSettings();
    notifyListeners();
    return imported.length;
  }

  int _computeStreak(List<JournalEntry> entries) {
    if (entries.isEmpty) return 0;
    final sorted = [...entries]..sort((a, b) => b.date.compareTo(a.date));
    var streak = 0;
    var expected = _normalizeDate(DateTime.now());
    for (final e in sorted) {
      final day = _normalizeDate(e.date);
      if (day == expected) {
        streak++;
        expected = expected.subtract(const Duration(days: 1));
      } else if (day.isBefore(expected)) {
        break;
      }
    }
    return streak;
  }

  Future<void> clearAllData() async {
    await DatabaseService.deleteAll();
    _entries = [];
    _streak = 0;
    _completedToday = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streak', 0);
    notifyListeners();
  }

  Future<void> _persistSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streak', _streak);
    await prefs.setString('userName', _userName);
    await prefs.setInt('themeMode', _themeMode.index);
    await prefs.setBool('remindersEnabled', _remindersEnabled);
    await prefs.setInt('reminderHour', _reminderHour);
    await prefs.setInt('reminderMinute', _reminderMinute);
    if (_languageCode != null) {
      await prefs.setString('languageCode', _languageCode!);
    } else {
      await prefs.remove('languageCode');
    }
  }

  DateTime _normalizeDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}
