# DayDump

> Journal de fin de journée sans friction pour ceux qui détestent tenir un journal. 3 questions, 5 minutes, tout reste sur ton téléphone.

<!-- Screenshots — remplacer ces chemins par de vraies captures une fois l'app installée sur un appareil physique -->
<!--
| Accueil | Check-in | Historique | Paramètres |
|:---:|:---:|:---:|:---:|
| ![Accueil](docs/screenshots/home.png) | ![Check-in](docs/screenshots/checkin.png) | ![Historique](docs/screenshots/history.png) | ![Paramètres](docs/screenshots/settings.png) |
-->

---

## À propos

DayDump est une application mobile pensée pour les personnes qui veulent prendre l'habitude de réfléchir à leur journée, sans la lourdeur d'un vrai journal. Chaque soir, l'application pose trois questions simples :

1. **Qu'as-tu accompli aujourd'hui ?**
2. **Qu'est-ce qui t'a bloqué ?**
3. **Sur quoi vas-tu avancer demain ?**

Pas de compte, pas de synchronisation cloud, pas d'onboarding interminable. Les données restent sur l'appareil et peuvent être exportées en texte brut à tout moment.

---

## Fonctionnalités

| Écran | Description |
|---|---|
| **Accueil** | Salutation personnalisée, compteur de série (streak), bouton CTA principal et liste des entrées récentes |
| **Check-in** | Formulaire conversationnel en 3 étapes avec indicateur de progression |
| **Complétion** | Écran de célébration avec animation et mise à jour du streak |
| **Historique** | Journal scrollable groupé par semaine (cette semaine / semaine dernière) |
| **Détail** | Lecture seule des 3 réponses d'une entrée, avec export en texte brut |
| **Paramètres** | Statistiques (streak, nombre d'entrées) et menu de configuration |

### Principes UX
- Zéro état de chargement visible
- Données 100 % locales — aucune donnée ne quitte l'appareil
- Support complet du mode clair et sombre (suit le thème système)
- Toutes les zones tactiles ≥ 44 × 44 pt
- Animations respectueuses du paramètre "Réduire les animations"

---

## Stack technique

- **Framework** : [Flutter](https://flutter.dev/) (Dart) — iOS & Android
- **Architecture** : `ChangeNotifier` + `provider` — état partagé entre les écrans via un `AppState` central
- **Navigation** : `IndexedStack` pour les onglets principaux, `Navigator.push` pour les flux secondaires (check-in, détail)
- **Persistance** : `shared_preferences` — les entrées sont sérialisées en JSON et stockées localement
- **Police** : [Figtree](https://fonts.google.com/specimen/Figtree) via `google_fonts`

---

## Dépendances

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Police Figtree depuis Google Fonts
  google_fonts: ^6.2.1

  # Persistance locale (JSON sérialisé)
  shared_preferences: ^2.3.3

  # Export / partage d'une entrée en texte brut
  share_plus: ^10.0.3

  # Formatage des dates
  intl: ^0.19.0

  # Gestion d'état (ChangeNotifier)
  provider: ^6.1.2

  # Rappels quotidiens (notifications locales planifiées)
  flutter_local_notifications: ^17.2.3
  timezone: ^0.9.4
  flutter_timezone: ^1.0.6

  # Ouvrir les réglages de notification système si permission refusée
  app_settings: ^5.1.1
```

---

## Structure du projet

```
lib/
├── main.dart                   # Point d'entrée async, configuration des thèmes clair/sombre
├── models/
│   └── entry.dart              # Modèle JournalEntry (immuable, copyWith)
├── data/
│   └── sample_data.dart        # Données d'exemple, questions, citations motivantes
├── state/
│   └── app_state.dart          # ChangeNotifier central (entrées, streak, persistance)
├── theme/
│   └── app_colors.dart         # Tokens de couleur via extension sur BuildContext
├── services/
│   └── notification_service.dart  # Rappels locaux — init, permission, scheduleDailyReminder
├── widgets/
│   ├── pressable.dart          # Primitive d'interaction (opacité/fond, 120 ms)
│   ├── primary_button.dart     # Bouton CTA pleine largeur (amber, 56 pt)
│   ├── secondary_button.dart   # Bouton secondaire outlined
│   └── bottom_nav_bar.dart     # Barre de navigation avec effet verre dépoli
└── screens/
    ├── main_scaffold.dart      # Scaffold principal avec IndexedStack
    ├── home_screen.dart        # Accueil
    ├── checkin_screen.dart     # Flow check-in 3 étapes
    ├── completion_screen.dart  # Écran de célébration
    ├── history_screen.dart     # Historique groupé
    ├── detail_screen.dart      # Détail d'une entrée + export
    └── settings_screen.dart    # Paramètres (thème, rappels, export, danger zone)
```

---

## Design system

| Token | Clair | Sombre |
|---|---|---|
| Fond | `#FFFFFF` | `#111111` |
| Texte principal | `#111111` | `#F5F5F5` |
| Texte secondaire | `#6B6B6B` | `#A6A6A6` |
| Bordure | `#E5E5E5` | `#2A2A2A` |
| Accent (amber) | `#F59E0B` | `#F59E0B` |

- **Police** : Figtree — graisses 400 / 500 / 600
- **Rayon de bordure** : 12 dp partout
- **Espacement** : rythme de 8 dp, marges écran 16 px
- L'amber est utilisé **uniquement** pour le CTA principal et le compteur de série

---

## Lancer le projet

### Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.7
- Dart ≥ 3.7
- Un simulateur iOS ou un émulateur Android (ou un appareil physique)

### Installation

```bash
# Cloner le dépôt
git clone https://github.com/sarak-koutalopatey/daydump.git
cd daydump

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

### Tests

```bash
flutter test
```

### Build iOS (TestFlight / App Store)

```bash
# Build IPA (nécessite Xcode + un compte Apple Developer)
flutter build ipa --release

# L'archive générée se trouve dans :
# build/ios/archive/Runner.xcarchive
# Distribuer via Xcode Organizer → Distribute App → TestFlight
```

> **Note iOS** : après un `flutter clean`, relancer `flutter run` une première fois (ou `cd ios && pod install`) pour régénérer les symlinks des plugins natifs.

### Build Android (Play Store / APK direct)

```bash
# App Bundle (recommandé pour le Play Store)
flutter build appbundle --release

# APK standalone (installation directe)
flutter build apk --release

# Fichiers générés :
# build/app/outputs/bundle/release/app-release.aab
# build/app/outputs/flutter-apk/app-release.apk
```

---

## Icône de l'application

Soleil blanc sur fond amber `#F59E0B` — source : `assets/icon/icon.png` (1024 × 1024 px).

Pour regénérer les icônes après modification de la source :

```bash
dart run flutter_launcher_icons
```

