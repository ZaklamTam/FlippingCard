# Flip & Match

A visually polished, highly responsive Memory Matching Card Game built with Flutter. Match the emojis as fast as you can to set top records!

## Architecture

This project was carefully refactored out of a monolith into a clean Separation of Concerns (SoC) architecture:
- `lib/home_page.dart`: App entry UI, home page configurations (thumbnail, dropdown menus and buttons), and game launcher validation.
- `lib/game_page.dart`: Core game mechanics, timer lifecycle, card validation matching, and dynamic, scalable grid layout.
- `lib/result_page.dart`: Final screen shows the game result, compares the completion time against historical local records, and tracks for a "NEW RECORD!".
- `lib/flippableCard.dart`: Reusable custom widget handling the 3D transform logic for smooth card flipping animations.
- `lib/utils.dart`: Some utilities, including custom emoji category mapping, drop-down menu enumerations, and UI formatting tools.


## Features

* **Engaging Animations**: Cards feature a customized 3D flippable effect with slight tilting and curved animation configurations, providing a satisfying and tactile feel when tapped and revealing tiles..
* **Dynamic Grid Layout Algorithm**: Automatically calculates the mathematically optimal number of columns and rows based on screen constraints and custom total card count, strictly penalizes empty spaces, and guarantees a perfectly filled grid with no incomplete rows or orphaned cards (e.g., exactly 2x3, 3x4, or 4x5 grids).
* **Multiple Categories**: Keep the game fresh by choosing from various built-in emoji themes, including Expressions, Animals, Foods, Activities, Travel, Objects, and Symbols.
* **Adjustable Difficulties**: 
  * Easy (3 pairs / 6 cards)
  * Medium (6 pairs / 12 cards)
  * Hard (10 pairs / 20 cards)
* **Real-time Timer**: Tracks exactly how many seconds it takes to solve the puzzle.
* **Memory Preview**: Briefly reveals all card positions at the very start of a round for 2 seconds to memorize.
* **Reset**: Features a built-in Reset button to restart the current board instantly.
* **Local High Score Leaderboard**: Persistently tracks your fastest completion times directly on the device using `SharedPreferences`. High scores are saved separately for each Category & Difficulty combination (e.g., stores separate records for "Animals - Hard" vs "Foods - Easy").
* **Playful Typography**: Integrates stylized Google Fonts with intentionally enlarged ("louder") point sizes, creating an upbeat, immersive gaming vibe.
* **Web App Support**: Additional support for modern web browsers.

## Tech Stack

* **Framework:** Flutter, Cross-platform UI toolkit
* **Language:** Dart
* **State Management:** Native Flutter `StatefulWidgets` with localized state handling
* **Local Storage:** `shared_preferences` for cross-session leaderboard persistence
* **Animations:** Native `AnimationController` and `Transform` widgets natively render manipulations

## Configuration

* **Dependencies:** Cleaned environment relies solely on standard Flutter foundation libraries and `SharedPreferences`. No sluggish third-party network image loads and unused emoji-picker plugins from the main thread.
* **Platforms:** Runs out-of-the-box natively on Android and Web browsers.
* **Assets:** Native system emoji renderings, so no heavy external image asset downloads are required, completely preserving fast startup times. Memory persistence logic automatically scopes to the native sandbox across the supported platforms.

## Getting Started

Ensure the Flutter SDK is installed. Clone the repository and navigate to the project directory.
### IDEs
Run from the IDE interface (with an Android emulator/web browser selected)
### Command line
1. Run `flutter pub get` to fetch dependencies.
2. Run `flutter run` to launch the game on your connected device or emulator.
