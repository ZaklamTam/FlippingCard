import 'dart:collection';
import 'package:flutter/material.dart';

// enums for the drop down menu


typedef ThemeSelection = DropdownMenuEntry<CardCategory>;
enum CardCategory {
  expressions("Expressions", ['💩','😂','🥰','😎','🥵','😅','😭','😡','🤯','😱']),
  animals("Animals", ['🐶','🐱','🐭','🐹','🐰','🦊','🐻','🐼','🐨','🐯']),
  foods("Foods", ['🍎','🍔','🍕','🌮','🍩','🥐','🍣','🍧','🍦','🍰']),
  activities("Activities", ['⚽','🏀','🏈','⚾','🎾','🏐','🏉','🎱','🏓','🏸']),
  travel("Travel", ['🚗','🚕','🚙','🚌','🚎','🏎️','🚓','🚑','🚒','🚐']),
  objects("Objects", ['⌚','📱','💻','⌨️','🖥️','🖨️','🖱️','🖲️','🕹️','🗜️']),
  symbols("Symbols", ['❤️','🧡','💛','💚','💙','💜','🖤','🤍','🤎','💔']);

  const CardCategory(this.label, this.emojis);
  final String label;
  final List<String> emojis;

  static final List<ThemeSelection> entries = UnmodifiableListView<ThemeSelection>(
    values.map<ThemeSelection>(
          (CardCategory category) => ThemeSelection(
        value: category,
        label: category.label,
      ),
    ),
  );
}

typedef DifficultyEntry = DropdownMenuEntry<DifficultyLabel>;

enum DifficultyLabel {
  easy('Easy', 3),  // 2x3 = 6
  medium('Medium', 6),  // 3x4 = 12
  hard('Hard', 10);  // 4x5 = 20

  const DifficultyLabel(this.label, this.cardNumber);
  final String label;
  final int cardNumber;

  static final List<DifficultyEntry> entries = UnmodifiableListView<DifficultyEntry>(
    values.map<DifficultyEntry>(
          (DifficultyLabel difficulty) => DifficultyEntry(
        value: difficulty,
        label: difficulty.label,
      ),
    ),
  );
}

String formatTime(int seconds) {
  int minutes = seconds ~/ 60;
  int secs = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
}