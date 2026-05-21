# E2: Flutter Memory Match Game

A visually polished, highly responsive Memory Matching Card Game built with Flutter. Match the emojis as fast as you can to set top records!

## Features

* **Engaging Animations**: Cards feature a customized 3D flippable effect with slight tilting and curved animation configurations, providing a highly satisfying and tactile feel when you tap and reveal tiles.
* **Dynamic Grid Layout Algorithm**: Automatically calculates the mathematically optimal number of columns and rows based on screen constraints and total card count. It strictly penalizes empty spaces, guaranteeing a perfectly filled grid with no incomplete rows or orphaned cards (e.g., exactly 2x3, 3x4, or 4x5 grids).
* **Multiple Categories**: Keep the game fresh by choosing from various built-in emoji themes including Expressions, Animals, Foods, Activities, Travel, Objects, and Symbols.
* **Adjustable Difficulties**: 
  * Easy (3 pairs / 6 cards)
  * Medium (6 pairs / 12 cards)
  * Hard (10 pairs / 20 cards)
* **Real-time Timer**: Tracks exactly how many seconds it takes for you to complete the puzzle.
* **Memory Preview & Reset**: Briefly reveals all card positions at the very start of a round for 2 seconds so you can memorize them. Features a built-in Reset button to instantly restart the current board.
* **Local High Score Leaderboard**: Persistently tracks your fastest completion times directly on the device using `SharedPreferences`. High scores are uniquely saved per specific Category & Difficulty combination (e.g., your separate records for "Animals - Hard" vs "Foods - Easy" won't overwrite each other).

## Architecture

This project was carefully refactored out of a monolith into a clean Separation of Concerns (SoC) architecture:
- `lib/models.dart`: Centralized data models, custom `DeckCategory` mapping, enumerations, and UI formatting tools.
- `lib/home_page.dart`: App entry UI, dropdown configurations, and game launcher validation.
- `lib/game_page.dart`: Core game mechanics, timer lifecycle, card validation matching, and dynamic layout scaling computation.
- `lib/result_page.dart`: Final evaluation screen that compares your completion time against historical local records, tracking if you set a "NEW RECORD!".
- `lib/flippableCard.dart`: Reusable custom widget handling the 3D matrix transform logic for the smooth card flipping animations.

## Getting Started

To run this project:
1. Ensure you have the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
2. Clone the repository and navigate to the project directory.
3. Run `flutter pub get` to fetch dependencies.
4. Run `flutter run` to launch the game on your connected device or emulator.
