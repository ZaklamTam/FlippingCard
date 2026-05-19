import 'dart:math';

import 'package:e2/flippableCard.dart';
import 'package:flutter/material.dart';

// main entry point
void main() {
  runApp(const MyApp());
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
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
// flippable widget https://www.youtube.com/watch?v=OjqWQrqTfWY
// refinement https://medium.com/flutter-community/flutter-flip-card-animation-eb25c403f371
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final int _counter = 0;

  // TODO: change type of _data
  late final List<int> _data;
  final Set<int> _matched = {};
  final Set<int> _faceUp = {};  // found matches will stay face up
  int? _firstPick;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    // TODO: replace with actual data
    _data = List.generate(10, (i) => i+1);
    //_data += _data;
    //_data.addAll(_data); Concurrent modification during iteration: Instance(length:3) of '_GrowableList'.
    _data.addAll(_data.toList());
    _data.shuffle();
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
      });
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
    // rerun every time setState is called.
    // optimized, so just rebuild anything that needs updating rather than
    // having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
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
              const Text('This is an example of synthesis poisonous people:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              // Gridview
              FloatingActionButton(
                onPressed: () => {Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePage(title: "ManPo")
                  ),
                )},
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
  const GamePage({super.key, required this.title});
  final String title;
  @override
  State<GamePage> createState() => _GamePageState();
}

// flippable widget https://www.youtube.com/watch?v=OjqWQrqTfWY
// refinement https://medium.com/flutter-community/flutter-flip-card-animation-eb25c403f371
class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  final int _counter = 0;

  // TODO: change type of _data
  late final List<int> _data;
  final Set<int> _matched = {};
  final Set<int> _faceUp = {};  // found matches will stay face up
  int? _firstPick;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    // TODO: replace with actual data
    _data = List.generate(10, (i) => i+1);
    //_data += _data;
    //_data.addAll(_data); Concurrent modification during iteration: Instance(length:3) of '_GrowableList'.
    _data.addAll(_data.toList());
    _data.shuffle();
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
      });
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
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('This is an example of synthesis poisonous people:'),
              Text(
                '$_counter',
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

                    for (int cols = 1; cols <= n; cols++) {
                      final rows = (n / cols).ceil();
                      final cellW = (constraints.maxWidth - spacing * (cols - 1)) / cols;
                      final cellH = (constraints.maxHeight - spacing * (rows - 1)) / rows;
                      final score = (cellW - cellH).abs();
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
                                  enabled: !_busy && !isMatched && !isFaceUp,
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
