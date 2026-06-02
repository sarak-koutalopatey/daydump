import '../l10n/app_strings.dart';

class JournalEntry {
  final String id;
  final DateTime date;
  final String accomplished;
  final String blockers;
  final String tomorrow;

  const JournalEntry({
    required this.id,
    required this.date,
    required this.accomplished,
    required this.blockers,
    required this.tomorrow,
  });

  String get preview => accomplished;

  String dayLabelFor(AppStrings s) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDay = DateTime(date.year, date.month, date.day);
    final diff = today.difference(entryDay).inDays;
    if (diff == 0) return s.dateToday;
    if (diff == 1) return s.dateYesterday;
    return s.weekdays[date.weekday - 1];
  }

  String dateLabelFor(AppStrings s) {
    return '${s.months[date.month - 1]} ${date.day}';
  }

  // English fallback used only for backwards-compatible contexts
  String get dayLabel => dayLabelFor(AppStrings('en'));
  String get dateLabel => dateLabelFor(AppStrings('en'));

  String toExportText(AppStrings s) => '''${s.exportTitle(dayLabelFor(s), dateLabelFor(s))}

${s.exportQ1}
$accomplished

${s.exportQ2}
$blockers

${s.exportQ3}
$tomorrow
''';

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'accomplished': accomplished,
    'blockers': blockers,
    'tomorrow': tomorrow,
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    id: json['id'] as String,
    date: DateTime.parse(json['date'] as String),
    accomplished: json['accomplished'] as String,
    blockers: json['blockers'] as String,
    tomorrow: json['tomorrow'] as String,
  );

  JournalEntry copyWith({
    String? id,
    DateTime? date,
    String? accomplished,
    String? blockers,
    String? tomorrow,
  }) => JournalEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    accomplished: accomplished ?? this.accomplished,
    blockers: blockers ?? this.blockers,
    tomorrow: tomorrow ?? this.tomorrow,
  );
}
