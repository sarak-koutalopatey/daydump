import 'package:flutter/material.dart';

abstract class AppStrings {
  const AppStrings._();

  factory AppStrings(String lang) =>
      lang == 'fr' ? const _Fr() : const _En();

  // Navigation
  String get navHome;
  String get navHistory;
  String get navSettings;

  // Home
  String get doMyDayDump;
  String get editMyDayDump;
  String get todayLogged;
  String get howDidTodayGo;
  String hiName(String name);
  String get daysInARow;
  String get bestStreak;
  String get recent;
  String get viewAll;

  // Check-in
  String get next;
  String get finish;
  String get typeYourAnswer;
  String charCount(int n);
  String stepOf(int step, int total);
  String get q1Label;
  String get q1Title;
  String get q1Hint;
  String get q2Label;
  String get q2Title;
  String get q2Hint;
  String get q3Label;
  String get q3Title;
  String get q3Hint;

  // Completion
  String get allDone;
  String get backToHome;
  String daysInARowBadge(int n);
  List<String> get motivationalLines;

  // Detail
  String get labelAccomplished;
  String get labelGotInTheWay;
  String get labelTomorrow;
  String get copiedToClipboard;
  String get exportAsText;

  // History
  String get historyTitle;
  String entriesCount(int n);
  String get thisWeek;
  String get lastWeek;
  String get threeQuestions;

  // Settings
  String get settingsTitle;
  String get dayStreak;
  String get entriesLabel;
  String get yourName;
  String get enterYourName;
  String get cancel;
  String get save;
  String get language;
  String get languageSystem;
  String get languageEnglish;
  String get languageFrench;
  String get appearance;
  String get appearanceSystem;
  String get appearanceLight;
  String get appearanceDark;
  String get reminders;
  String get remindersOff;
  String get dailyReminder;
  String get time;
  String get exportAllEntries;
  String get importAllEntries;
  String get importTitle;
  String importSuccess(int n);
  String get importError;
  String get deleteAllEntries;
  String get deleteAllEntriesTitle;
  String deleteAllEntriesMessage(int n);
  String get deleteAll;
  String get allowDailyReminders;
  String reminderDescription(String time);
  String get allowNotifications;
  String get notNow;
  String get footer;
  String get aboutDayDump;
  String get version;
  String get aboutDescription;
  String get madeWith;
  String get notificationsBlocked;
  String get notificationsBlockedMessage;
  String get openSettings;
  String get couldNotSetReminder;
  String errorOccurred(String type);
  String get ok;

  // Entry date labels
  String get dateToday;
  String get dateYesterday;
  List<String> get weekdays;
  List<String> get months;

  // Export
  String get exportJournalHeader;
  String exportCountLine(int n);
  String exportTitle(String day, String date);
  String get exportQ1;
  String get exportQ2;
  String get exportQ3;

  // Onboarding
  String get skip;
  String get getStarted;
  String get close;
  String get help;
  String get onboarding1Title;
  String get onboarding1Subtitle;
  String get onboarding2Title;
  String get onboarding2Subtitle;
  String get onboarding3Title;
  String get onboarding3Subtitle;
  String get onboarding4Title;
  String get onboarding4Subtitle;
  String get onboarding5Title;
  String get onboarding5Subtitle;
  String get onboardingNameTitle;
  String get onboardingNameSubtitle;
  String get onboardingNameHint;

  // Notification
  String get notifTitle;
  String get notifBody;
  String get notifChannelName;
  String get notifChannelDescription;
}

// ─── English ─────────────────────────────────────────────────────────────────

class _En extends AppStrings {
  const _En() : super._();

  @override String get navHome => 'Home';
  @override String get navHistory => 'History';
  @override String get navSettings => 'Settings';

  @override String get doMyDayDump => 'Do my DayDump';
  @override String get editMyDayDump => 'Edit my DayDump';
  @override String get todayLogged => 'Today is logged. Nice work.';
  @override String get howDidTodayGo => 'How did today go?';
  @override String hiName(String name) => 'Hi, $name.';
  @override String get daysInARow => 'days in a row';
  @override String get bestStreak => 'Best streak yet. Keep it going.';
  @override String get recent => 'RECENT';
  @override String get viewAll => 'View all';

  @override String get next => 'Next';
  @override String get finish => 'Finish';
  @override String get typeYourAnswer => 'Type your answer…';
  @override String charCount(int n) => '$n chars';
  @override String stepOf(int step, int total) => 'Step $step of $total';
  @override String get q1Label => 'Question 1 of 3';
  @override String get q1Title => 'What did you accomplish today?';
  @override String get q1Hint => 'Big or small. One sentence is enough.';
  @override String get q2Label => 'Question 2 of 3';
  @override String get q2Title => 'What got in your way?';
  @override String get q2Hint => 'A blocker, a distraction, a feeling.';
  @override String get q3Label => 'Question 3 of 3';
  @override String get q3Title => 'What will you tackle tomorrow?';
  @override String get q3Hint => 'One thing you want to move forward.';

  @override String get allDone => 'All done.';
  @override String get backToHome => 'Back to home';
  @override String daysInARowBadge(int n) => '$n days in a row';
  @override List<String> get motivationalLines => const [
    'Small daily reps. That\'s the whole thing.',
    'Showing up beats getting it right.',
    'Tomorrow\'s easier because of today.',
    'A line a day adds up.',
  ];

  @override String get labelAccomplished => 'ACCOMPLISHED';
  @override String get labelGotInTheWay => 'GOT IN THE WAY';
  @override String get labelTomorrow => 'TOMORROW';
  @override String get copiedToClipboard => 'Copied to clipboard';
  @override String get exportAsText => 'Export as text';

  @override String get historyTitle => 'History';
  @override String entriesCount(int n) =>
      '$n ${n == 1 ? 'entry' : 'entries'} · all local';
  @override String get thisWeek => 'This week';
  @override String get lastWeek => 'Last week';
  @override String get threeQuestions => '3 questions';

  @override String get settingsTitle => 'Settings';
  @override String get dayStreak => 'Day streak';
  @override String get entriesLabel => 'Entries';
  @override String get yourName => 'Your name';
  @override String get enterYourName => 'Enter your name';
  @override String get cancel => 'Cancel';
  @override String get save => 'Save';
  @override String get language => 'Language';
  @override String get languageSystem => 'System';
  @override String get languageEnglish => 'English';
  @override String get languageFrench => 'French';
  @override String get appearance => 'Appearance';
  @override String get appearanceSystem => 'System';
  @override String get appearanceLight => 'Light';
  @override String get appearanceDark => 'Dark';
  @override String get reminders => 'Reminders';
  @override String get remindersOff => 'Off';
  @override String get dailyReminder => 'Daily reminder';
  @override String get time => 'Time';
  @override String get exportAllEntries => 'Export all entries';
  @override String get importAllEntries => 'Import entries';
  @override String get importTitle => 'Import entries';
  @override String importSuccess(int n) =>
      '$n ${n == 1 ? 'entry' : 'entries'} imported successfully.';
  @override String get importError =>
      'Could not read this file. Make sure it\'s a DayDump backup.';
  @override String get deleteAllEntries => 'Delete all entries';
  @override String get deleteAllEntriesTitle => 'Delete all entries?';
  @override String deleteAllEntriesMessage(int n) =>
      'This will permanently delete $n ${n == 1 ? 'entry' : 'entries'}. This cannot be undone.';
  @override String get deleteAll => 'Delete all';
  @override String get allowDailyReminders => 'Allow daily reminders';
  @override String reminderDescription(String time) =>
      'DayDump will send you a reminder at $time each day to complete your check-in.';
  @override String get allowNotifications => 'Allow notifications';
  @override String get notNow => 'Not now';
  @override String get footer => 'DayDump · All data stays on your device';
  @override String get aboutDayDump => 'About DayDump';
  @override String get version => 'Version 1.0.0';
  @override String get aboutDescription =>
      'Frictionless end-of-day journaling.\n3 questions. 5 minutes. All data stays on your device.';
  @override String get madeWith => 'Made with Flutter · No cloud, no account';
  @override String get notificationsBlocked => 'Notifications blocked';
  @override String get notificationsBlockedMessage =>
      'Allow notifications for DayDump in your device settings to receive daily reminders.';
  @override String get openSettings => 'Open Settings';
  @override String get couldNotSetReminder => 'Could not set reminder';
  @override String errorOccurred(String type) =>
      'An error occurred: $type. Please try again.';
  @override String get ok => 'OK';

  @override String get dateToday => 'Today';
  @override String get dateYesterday => 'Yesterday';
  @override List<String> get weekdays => const [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];
  @override List<String> get months => const [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override String get exportJournalHeader => 'DayDump — My Journal';
  @override String exportCountLine(int n) =>
      '$n ${n == 1 ? 'entry' : 'entries'}';
  @override String exportTitle(String day, String date) => 'DayDump — $day, $date';
  @override String get exportQ1 => 'What did you accomplish today?';
  @override String get exportQ2 => 'What got in your way?';
  @override String get exportQ3 => 'What will you tackle tomorrow?';

  @override String get skip => 'Skip';
  @override String get getStarted => 'Get started';
  @override String get close => 'Close';
  @override String get help => 'Help';
  @override String get onboarding1Title => 'Welcome to DayDump';
  @override String get onboarding1Subtitle =>
      'A 5-minute reflection at the end of each day.\n3 questions. All on your device.';
  @override String get onboarding2Title => 'Three honest questions';
  @override String get onboarding2Subtitle =>
      'What did you accomplish? What got in your way? What\'s next?\nAnswer honestly, in just a few words.';
  @override String get onboarding3Title => 'Build a streak';
  @override String get onboarding3Subtitle =>
      'Show up every day.\nSmall daily reps add up to something real.';
  @override String get onboarding4Title => 'Your journal, your device';
  @override String get onboarding4Subtitle =>
      'No account. No cloud.\nYour data never leaves your phone.';
  @override String get onboarding5Title => 'Never miss a day';
  @override String get onboarding5Subtitle =>
      'Get a gentle reminder each evening to complete your check-in.\nYou can change the time anytime in Settings.';
  @override String get onboardingNameTitle => 'What\'s your name?';
  @override String get onboardingNameSubtitle =>
      'We\'ll use it to say hi.\nYou can change it anytime in Settings.';
  @override String get onboardingNameHint => 'Your first name';

  @override String get notifTitle => 'Time for your DayDump';
  @override String get notifBody => 'How did today go?';
  @override String get notifChannelName => 'Daily reminder';
  @override String get notifChannelDescription => 'End-of-day check-in reminder';
}

// ─── Français ────────────────────────────────────────────────────────────────

class _Fr extends AppStrings {
  const _Fr() : super._();

  @override String get navHome => 'Accueil';
  @override String get navHistory => 'Historique';
  @override String get navSettings => 'Paramètres';

  @override String get doMyDayDump => 'Faire mon DayDump';
  @override String get editMyDayDump => 'Modifier mon DayDump';
  @override String get todayLogged => 'Journée enregistrée. Bravo.';
  @override String get howDidTodayGo => 'Comment s\'est passée ta journée ?';
  @override String hiName(String name) => 'Bonjour, $name.';
  @override String get daysInARow => 'jours d\'affilée';
  @override String get bestStreak => 'Ton record. Continue comme ça.';
  @override String get recent => 'RÉCENT';
  @override String get viewAll => 'Voir tout';

  @override String get next => 'Suivant';
  @override String get finish => 'Terminer';
  @override String get typeYourAnswer => 'Écris ta réponse…';
  @override String charCount(int n) => '$n caractères';
  @override String stepOf(int step, int total) => 'Étape $step sur $total';
  @override String get q1Label => 'Question 1 sur 3';
  @override String get q1Title => 'Qu\'as-tu accompli aujourd\'hui ?';
  @override String get q1Hint => 'Grand ou petit. Une phrase suffit.';
  @override String get q2Label => 'Question 2 sur 3';
  @override String get q2Title => 'Qu\'est-ce qui t\'a bloqué ?';
  @override String get q2Hint => 'Un obstacle, une distraction, une émotion.';
  @override String get q3Label => 'Question 3 sur 3';
  @override String get q3Title => 'Sur quoi vas-tu avancer demain ?';
  @override String get q3Hint => 'Une chose que tu veux faire avancer.';

  @override String get allDone => 'C\'est fait.';
  @override String get backToHome => 'Retour à l\'accueil';
  @override String daysInARowBadge(int n) => '$n jours d\'affilée';
  @override List<String> get motivationalLines => const [
    'Petites actions quotidiennes. C\'est tout.',
    'Être là vaut mieux qu\'être parfait.',
    'Demain sera plus facile grâce à aujourd\'hui.',
    'Une ligne par jour, ça finit par compter.',
  ];

  @override String get labelAccomplished => 'ACCOMPLI';
  @override String get labelGotInTheWay => 'OBSTACLES';
  @override String get labelTomorrow => 'DEMAIN';
  @override String get copiedToClipboard => 'Copié dans le presse-papier';
  @override String get exportAsText => 'Exporter en texte';

  @override String get historyTitle => 'Historique';
  @override String entriesCount(int n) =>
      '$n ${n == 1 ? 'entrée' : 'entrées'} · tout en local';
  @override String get thisWeek => 'Cette semaine';
  @override String get lastWeek => 'La semaine dernière';
  @override String get threeQuestions => '3 questions';

  @override String get settingsTitle => 'Paramètres';
  @override String get dayStreak => 'Série';
  @override String get entriesLabel => 'Entrées';
  @override String get yourName => 'Ton prénom';
  @override String get enterYourName => 'Entre ton prénom';
  @override String get cancel => 'Annuler';
  @override String get save => 'Enregistrer';
  @override String get language => 'Langue';
  @override String get languageSystem => 'Système';
  @override String get languageEnglish => 'Anglais';
  @override String get languageFrench => 'Français';
  @override String get appearance => 'Apparence';
  @override String get appearanceSystem => 'Système';
  @override String get appearanceLight => 'Clair';
  @override String get appearanceDark => 'Sombre';
  @override String get reminders => 'Rappels';
  @override String get remindersOff => 'Désactivé';
  @override String get dailyReminder => 'Rappel quotidien';
  @override String get time => 'Heure';
  @override String get exportAllEntries => 'Exporter toutes les entrées';
  @override String get importAllEntries => 'Importer des entrées';
  @override String get importTitle => 'Importer des entrées';
  @override String importSuccess(int n) =>
      '$n ${n == 1 ? 'entrée importée' : 'entrées importées'} avec succès.';
  @override String get importError =>
      'Impossible de lire ce fichier. Assure-toi que c\'est une sauvegarde DayDump.';
  @override String get deleteAllEntries => 'Supprimer toutes les entrées';
  @override String get deleteAllEntriesTitle => 'Supprimer toutes les entrées ?';
  @override String deleteAllEntriesMessage(int n) =>
      'Cela supprimera définitivement $n ${n == 1 ? 'entrée' : 'entrées'}. Cette action est irréversible.';
  @override String get deleteAll => 'Tout supprimer';
  @override String get allowDailyReminders => 'Autoriser les rappels quotidiens';
  @override String reminderDescription(String time) =>
      'DayDump t\'enverra un rappel chaque jour à $time pour compléter ton journal.';
  @override String get allowNotifications => 'Autoriser les notifications';
  @override String get notNow => 'Pas maintenant';
  @override String get footer =>
      'DayDump · Toutes les données restent sur ton appareil';
  @override String get aboutDayDump => 'À propos de DayDump';
  @override String get version => 'Version 1.0.0';
  @override String get aboutDescription =>
      'Journal de fin de journée sans friction.\n3 questions. 5 minutes. Tout reste sur ton appareil.';
  @override String get madeWith => 'Fait avec Flutter · Pas de nuage, pas de compte';
  @override String get notificationsBlocked => 'Notifications bloquées';
  @override String get notificationsBlockedMessage =>
      'Autorise les notifications pour DayDump dans les réglages de ton appareil afin de recevoir des rappels quotidiens.';
  @override String get openSettings => 'Ouvrir les réglages';
  @override String get couldNotSetReminder => 'Impossible de configurer le rappel';
  @override String errorOccurred(String type) =>
      'Une erreur s\'est produite : $type. Réessaie.';
  @override String get ok => 'OK';

  @override String get dateToday => 'Aujourd\'hui';
  @override String get dateYesterday => 'Hier';
  @override List<String> get weekdays => const [
    'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche',
  ];
  @override List<String> get months => const [
    'jan.', 'fév.', 'mars', 'avr.', 'mai', 'juin',
    'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.',
  ];

  @override String get exportJournalHeader => 'DayDump — Mon journal';
  @override String exportCountLine(int n) =>
      '$n ${n == 1 ? 'entrée' : 'entrées'}';
  @override String exportTitle(String day, String date) => 'DayDump — $day, $date';
  @override String get exportQ1 => 'Qu\'as-tu accompli aujourd\'hui ?';
  @override String get exportQ2 => 'Qu\'est-ce qui t\'a bloqué ?';
  @override String get exportQ3 => 'Sur quoi as-tu avancé ?';

  @override String get skip => 'Ignorer';
  @override String get getStarted => 'Commencer';
  @override String get close => 'Fermer';
  @override String get help => 'Aide';
  @override String get onboarding1Title => 'Bienvenue sur DayDump';
  @override String get onboarding1Subtitle =>
      '5 minutes de réflexion en fin de journée.\n3 questions. Tout sur ton appareil.';
  @override String get onboarding2Title => 'Trois questions honnêtes';
  @override String get onboarding2Subtitle =>
      'Qu\'as-tu accompli ? Qu\'est-ce qui t\'a bloqué ? C\'est quoi la suite ?\nQuelques mots suffisent.';
  @override String get onboarding3Title => 'Construis une série';
  @override String get onboarding3Subtitle =>
      'Reviens chaque jour.\nLes petits efforts finissent par compter.';
  @override String get onboarding4Title => 'Ton journal, ton appareil';
  @override String get onboarding4Subtitle =>
      'Pas de compte. Pas de nuage.\nTes données ne quittent jamais ton téléphone.';
  @override String get onboarding5Title => 'Ne rate aucun jour';
  @override String get onboarding5Subtitle =>
      'Reçois un rappel chaque soir pour compléter ton journal.\nTu peux modifier l\'heure à tout moment dans les réglages.';
  @override String get onboardingNameTitle => 'Comment tu t\'appelles ?';
  @override String get onboardingNameSubtitle =>
      'On l\'utilisera pour te dire bonjour.\nTu peux le modifier à tout moment dans les réglages.';
  @override String get onboardingNameHint => 'Ton prénom';

  @override String get notifTitle => 'C\'est l\'heure de ton DayDump';
  @override String get notifBody => 'Comment s\'est passée ta journée ?';
  @override String get notifChannelName => 'Rappel quotidien';
  @override String get notifChannelDescription =>
      'Rappel pour le journal de fin de journée';
}

// ─── Extension ───────────────────────────────────────────────────────────────

extension AppStringsX on BuildContext {
  AppStrings get s =>
      AppStrings(Localizations.localeOf(this).languageCode);
}
