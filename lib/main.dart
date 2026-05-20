import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:e2/flippableCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';  //sharedpreference

// main entry point
void main() {
  runApp(const MyApp());
}

typedef DifficultyEntry = DropdownMenuEntry<DifficultyLabel>;

// DropdownMenuEntry labels and values for the first dropdown menu.
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

// appli root class (canvas, stateless)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // set theme color
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const MyHomePage(title: 'Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // home page widget. stateful w/ State object of appearance.
  // this is configuration for the state. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  // see state below
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// everything that happens on homepage
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final int _counter = 0;
  final TextEditingController selectionController = TextEditingController();
  DifficultyLabel? selectedDifficulty;

  // TODO: change type of _data
  List<int> _data = [];

  @override
  void initState() {
    super.initState();
  }

  void _generateData(int n) {
    _data = List.generate(n, (i) => i+1);
    //_data += _data;
    //_data.addAll(_data); Concurrent modification during iteration: Instance(length:3) of '_GrowableList'.
    _data.addAll(_data.toList());
    _data.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    // rerun every time setState is called.
    // optimized, so just rebuild anything that needs updating rather than
    // having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //backgroundColor: Colors.amber,  // individual color settings
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            // it sizes itself to fit its children horizontally
            // and tries to be as tall as its parent.
            //
            // mainAxisAlignment: center the children vertically;
            //
            // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
            // action in the IDE, or press "p" in the console), to see the
            // wireframe for each widget.??????
            children: [
              // TODO: this supposed to work but not actually on web idk why
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage('https://picsum.photos/536/354'),
                    fit: BoxFit.cover, // Ensures the image fills the container
                  ),
                ),
              ),
              const Text('This is an example of synthesis poisonous people:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              DropdownButton<DifficultyLabel>(
                value: selectedDifficulty?? DifficultyLabel.easy,
                hint: const Text('Difficulty'),
                onChanged: (DifficultyLabel? difficulty) {
                  setState(() {
                    selectedDifficulty = difficulty;
                  });
                },
                items: DifficultyLabel.values.map<DropdownMenuItem<DifficultyLabel>>((DifficultyLabel difficulty) {
                  return DropdownMenuItem<DifficultyLabel>(
                    value: difficulty,
                    child: Text(difficulty.label),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: (selectedDifficulty != null) ? () {
                  setState(() {
                    _generateData(selectedDifficulty!.cardNumber);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GamePage(title: "ManPo", data: _data, difficulty: selectedDifficulty!.label)
                    ),
                  );
                } : null,  // null for "dont take action"
                child: const Text('Start Game')
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// game page
class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.title, required this.data, required this.difficulty});
  final String title;
  final List<int> data;
  final String difficulty;
  @override
  State<GamePage> createState() => _GamePageState();
}

// flippable widget https://www.youtube.com/watch?v=OjqWQrqTfWY
// refinement https://medium.com/flutter-community/flutter-flip-card-animation-eb25c403f371
class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  final int _counter = 0;

  // TODO: change type of _data
  late final List<int> _data;
  late final String _difficulty;
  final Set<int> _matched = {};
  final Set<int> _faceUp = {};  // found matches will stay face up
  int? _firstPick;
  bool _busy = false;
  //late Timer _timer;
  Timer? _timer;  // avoid exiting in the preview stage and causes error
  int _elapsedSeconds = 0;
  bool _gameOver = false;
  bool _previewing = true;

  @override
  void initState() {
    super.initState();
    // Use the passed data from widget
    _data = widget.data;
    _difficulty = widget.difficulty;
    // Show all cards face-up for a short preview, then flip back and start timer
    _previewing = true;
    _faceUp.addAll(List.generate(_data.length, (i) => i));
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _faceUp.clear();
        _previewing = false;
        // Start the timer after preview ends
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (!_gameOver) {
            setState(() {
              _elapsedSeconds++;
            });
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();  // tolerates with non existance of timer
    super.dispose();
  }

  void _onCardTapped(int index) {
    if (_busy) return;
    if (_matched.contains(index)) return;
    if (_faceUp.contains(index)) return;

    final firstPick = _firstPick;

    setState(() {
      _faceUp.add(index);
      if (firstPick == null) {
        _firstPick = index;
      } else {
        _firstPick = null;
        _busy = true;
      }
    });

    if (firstPick == null) return;
    final secondPick = index;

    if (_data[firstPick] == _data[secondPick]) {
      setState(() {
        _matched.add(firstPick);
        _matched.add(secondPick);
        _busy = false;
        // Check if game is over
        if (_matched.length == _data.length) {
          _gameOver = true;
        }
      });
      if (_gameOver) {
        final time = formatTime(_elapsedSeconds);
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          // replace the screen, no turning back
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ResultPage(timeElapsed: _elapsedSeconds, difficulty: _difficulty)),
          );
        });
      }
    } else {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          _faceUp.remove(firstPick);
          _faceUp.remove(secondPick);
          _busy = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("${widget.title}-${widget.difficulty}"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('This is an example of synthesis poisonous people:'),
              Text(
                formatTime(_elapsedSeconds),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              // Gridview
              const SizedBox(height: 12),
              Expanded(               // ← bounds the height for LayoutBuilder
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // find a good column count
                    final n = _data.length;
                    const spacing = 6.0;

                    int bestCols = 1;
                    double bestScore = double.infinity;

                    // starting from 1 col up to n, tries to find the best layout
                    for (int cols = 1; cols <= n; cols++) {
                      final rows = (n / cols).ceil();
                      final cellW = (constraints.maxWidth - spacing * (cols - 1)) / cols;
                      final cellH = (constraints.maxHeight - spacing * (rows - 1)) / rows;
                      
                      // Heavily penalize layouts that leave empty slots
                      final emptySlots = (rows * cols) - n;
                      final score = (cellW - cellH).abs() + (emptySlots * 10000);
                      
                      if (score < bestScore) {
                        bestScore = score;
                        bestCols = cols;
                      }
                    }

                    final bestRows = (n / bestCols).ceil();
                    final cellW = (constraints.maxWidth - spacing * (bestCols - 1)) / bestCols;
                    final cellH = (constraints.maxHeight - spacing * (bestRows - 1)) / bestRows;
                    final cellSquareSize = min(cellH, cellW);

                    return FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        // paddings
                        width: constraints.maxWidth-50,
                        height: constraints.maxHeight-50,
                        child: GridView.count(
                          shrinkWrap: true,
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: bestCols,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: cellW / cellH,
                          // make list of FlippableCard's
                          children: List.generate(_data.length, (index) {
                            final value = _data[index];
                            final isMatched = _matched.contains(index);
                            final isFaceUp = isMatched || _faceUp.contains(index);
                            return Center(
                              child: SizedBox(
                                width: cellSquareSize,
                                height: cellSquareSize,
                                child: FlippableCard(
                                  key: ValueKey('card_$index'),
                                  display: value,
                                  faceUp: isFaceUp,
                                  enabled: !_previewing && !_busy && !isMatched && !isFaceUp,
                                  onTap: () => _onCardTapped(index),
                                )
                              )
                            );
                          }),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.timeElapsed, required this.difficulty});

  // home page widget. stateful w/ State object of appearance.
  // this is configuration for the state. Fields in a Widget subclass are
  // always marked "final".

  final int timeElapsed;
  final String difficulty;

  // see state below
  @override
  State<ResultPage> createState() => _ResultPageState();
}

// everything that happens on homepage
class _ResultPageState extends State<ResultPage> {

  late final int _timeElapsed;
  late final String _difficulty;
  String displayMessage = "Checking...";
  String bestTime = "--:--";

  @override
  void initState() {
    super.initState();
    // TODO: replace with actual data
    _timeElapsed = widget.timeElapsed;
    _checkBestPerformance();
  }

  void _checkBestPerformance() async {
    final double fastest = await readTime(_difficulty);
    if (fastest > _timeElapsed) {
      setState(() {
        displayMessage = "NEW RECORD!";
        bestTime = formatTime(_timeElapsed);
      });
      saveTime(_timeElapsed, _difficulty);
    } else {
      setState(() {
        displayMessage = "KEEP IT UP!";
        bestTime = formatTime(fastest.toInt());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // rerun every time setState is called.
    // optimized, so just rebuild anything that needs updating rather than
    // having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("GAME OVER!"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('Time Elapsed:'),
              Text(
                formatTime(_timeElapsed),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(displayMessage),
              FilledButton(
                  onPressed:  () => {Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(title: "Example")
                    ),
                  )},
                  child: const Text('Finish')
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> saveTime(int timeInSeconds, String difficulty) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble(difficulty, timeInSeconds.toDouble());
}

Future<double> readTime(String difficulty) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  double? timeInSeconds = prefs.getDouble(difficulty);
  return timeInSeconds?? double.infinity;
}

String formatTime(int seconds) {
  int minutes = seconds ~/ 60;
  int secs = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
}