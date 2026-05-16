import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entry.dart';
import '../data/sample_data.dart';

class AppState extends ChangeNotifier {
  List<JournalEntry> _entries = [];
  int _streak = 12;
  bool _completedToday = false;
  String _userName = 'Alex';

  List<JournalEntry> get entries => _entries;
  int get streak => _streak;
  bool get completedToday => _completedToday;
  String get userName => _userName;

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

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'entries',
      _entries.map((e) => jsonEncode(e.toJson())).toList(),
    );
    await prefs.setInt('streak', _streak);
    await prefs.setString('userName', _userName);
  }

  DateTime _normalizeDate(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);
}
