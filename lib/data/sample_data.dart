import '../models/entry.dart';

final kSampleEntries = List<JournalEntry>.unmodifiable([
  JournalEntry(
    id: 'entry-1',
    date: DateTime.now(),
    accomplished: 'Shipped the dashboard refactor and finally cleared inbox down to zero.',
    blockers: 'Spent too long debugging a flaky test — turned out to be a timezone thing.',
    tomorrow: 'Pair with Sam on the auth migration and draft the Q2 retro.',
  ),
  JournalEntry(
    id: 'entry-2',
    date: DateTime.now().subtract(const Duration(days: 1)),
    accomplished: 'Reviewed three PRs, deep work on the search index.',
    blockers: 'Got pulled into two unexpected calls that broke my flow.',
    tomorrow: 'Finish the search index work and review the design spec.',
  ),
  JournalEntry(
    id: 'entry-3',
    date: DateTime.now().subtract(const Duration(days: 2)),
    accomplished: 'Mostly meetings. Did get the onboarding copy approved.',
    blockers: 'Back-to-back meetings left no room for focused work.',
    tomorrow: 'Block off deep work time in the morning.',
  ),
  JournalEntry(
    id: 'entry-4',
    date: DateTime.now().subtract(const Duration(days: 3)),
    accomplished: 'Wrote the spec for entry export. Felt slow today.',
    blockers: 'Low energy — didn\'t sleep well. Hard to focus.',
    tomorrow: 'Start implementing the export spec.',
  ),
  JournalEntry(
    id: 'entry-5',
    date: DateTime.now().subtract(const Duration(days: 4)),
    accomplished: 'Kickoff for the design system. Walked at lunch.',
    blockers: 'Alignment on naming conventions took longer than expected.',
    tomorrow: 'Document the token decisions and share with the team.',
  ),
  JournalEntry(
    id: 'entry-6',
    date: DateTime.now().subtract(const Duration(days: 5)),
    accomplished: 'Light day. Caught up on reading, prepped for the week.',
    blockers: 'Nothing major — just weekend mode.',
    tomorrow: 'Start the week with the design system kickoff.',
  ),
  JournalEntry(
    id: 'entry-7',
    date: DateTime.now().subtract(const Duration(days: 6)),
    accomplished: 'Off. Long run, groceries, finished the novel.',
    blockers: 'Nothing — this was intentional rest.',
    tomorrow: 'Light prep for the week ahead.',
  ),
  JournalEntry(
    id: 'entry-8',
    date: DateTime.now().subtract(const Duration(days: 7)),
    accomplished: 'Closed out the billing bug. Demo went smoothly.',
    blockers: 'One customer question during the demo threw me briefly.',
    tomorrow: 'Document the billing fix and close the ticket.',
  ),
]);

const kQuestions = [
  (
    label: 'Question 1 of 3',
    title: 'What did you accomplish today?',
    hint: 'Big or small. One sentence is enough.',
  ),
  (
    label: 'Question 2 of 3',
    title: 'What got in your way?',
    hint: 'A blocker, a distraction, a feeling.',
  ),
  (
    label: 'Question 3 of 3',
    title: 'What will you tackle tomorrow?',
    hint: 'One thing you want to move forward.',
  ),
];

const kMotivationalLines = [
  'Small daily reps. That\'s the whole thing.',
  'Showing up beats getting it right.',
  'Tomorrow\'s easier because of today.',
  'A line a day adds up.',
];
