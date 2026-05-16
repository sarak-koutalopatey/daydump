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

  String get dayLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDay = DateTime(date.year, date.month, date.day);
    final diff = today.difference(entryDay).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }

  String get dateLabel {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  String toExportText() => '''DayDump — $dayLabel, $dateLabel

What did you accomplish today?
$accomplished

What got in your way?
$blockers

What will you tackle tomorrow?
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
