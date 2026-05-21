import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:e2/flippableCard.dart';
import 'package:google_fonts/google_fonts.dart';

import 'utils.dart';
import 'result_page.dart';

// game page
class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
    required this.title,
    required this.data,
    required this.difficulty,
    required this.category,
  });

  final String title;
  final List<String> data;
  final String difficulty;
  final String category;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  late final List<String> _data;
  late final String _difficulty;
  late final String _category;
  final Set<int> _matched = {};
  final Set<int> _faceUp = {};  // all tiles/cards that are face up
  int? _firstPick;
  bool _busy = false;
  //late Timer _timer;
  Timer? _timer;  // avoid exiting in the preview stage and causes error
  int _elapsedSeconds = 0;
  bool _gameOver = false;
  bool _previewing = true;

  Key _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    _data = List.from(widget.data);
    _difficulty = widget.difficulty;
    _category = widget.category;
    _gameSetup();
  }

  void _gameSetup() {
    _timer?.cancel();
    _matched.clear();
    _faceUp.clear();
    _firstPick = null;
    _busy = false;
    _elapsedSeconds = 0;
    _gameOver = false;

    _data.shuffle();  // shuffle cards

    // show all cards face-up for a short preview, then back and start timer
    _previewing = true;
    _faceUp.addAll(List.generate(_data.length, (i) => i));

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _faceUp.clear();
        _previewing = false;
        // after preview ends, start timer.
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
    _timer?.cancel();  // tolerates with absence of timer
    super.dispose();
  }

  void _reset() {
    setState(() {
      _gameSetup();
      _key = UniqueKey();
    });
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
        // game is over when all cards are flipped
        if (_matched.length == _data.length) {
          _gameOver = true;
        }
      });
      if (_gameOver) {
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          // replace the screen, no turing back!
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(
                timeElapsed: _elapsedSeconds,
                difficulty: _difficulty,
                category: _category,
              ),
            ),
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
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        //title: Text("${widget.category} - ${widget.difficulty}"),
        title: Text(
          "${widget.category} - ${widget.difficulty}",
          style: GoogleFonts.unkempt(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: (!_previewing && !_gameOver) ? _reset : null,
            child: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            key: _key,
            children: [
              Text(
                formatTime(_elapsedSeconds),
                style: GoogleFonts.rubikSprayPaint(fontSize: 36),
                textAlign: TextAlign.center,
              ),
              // Gridview
              const SizedBox(height: 12),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // fina a good column number
                    final n = _data.length;
                    const spacing = 6.0;

                    int bestCols = 1;
                    double bestScore = double.infinity;
                    // starting from 1 col to n, check & finds the best layout.
                    for (int cols = 1; cols <= n; cols++) {
                      final rows = (n / cols).ceil();
                      final cellW = (constraints.maxWidth - spacing * (cols - 1)) / cols;
                      final cellH = (constraints.maxHeight - spacing * (rows - 1)) / rows;
                      // heavily penalize layouts that leave empty slots.
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
                        width: constraints.maxWidth - 50,
                        height: constraints.maxHeight - 50,
                        child: GridView.count(
                          shrinkWrap: true,
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: bestCols,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: cellW / cellH,
                          // make list of FlippableCard'ss
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
                                ),
                              ),
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