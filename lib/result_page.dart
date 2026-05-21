import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'utils.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.timeElapsed, required this.difficulty, required this.category});

  final int timeElapsed;
  final String difficulty;
  final String category;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late final int _timeElapsed;
  late final String _difficulty;
  late final String _category;
  String displayMessage = "Checking...";
  String bestTime = "--:--";

  @override
  void initState() {
    super.initState();
    _timeElapsed = widget.timeElapsed;
    _difficulty = widget.difficulty;
    _category = widget.category;
    _checkBestPerformance();
  }

  void _checkBestPerformance() async {
    String prefKey = "${_category}_$_difficulty";
    final double fastest = await _readTime(prefKey);
    if (fastest > _timeElapsed) {
      if (mounted) {
        setState(() {
          displayMessage = "NEW RECORD!";
          bestTime = formatTime(_timeElapsed);
        });
      }
      _saveTime(_timeElapsed, prefKey);
    } else {
      if (mounted) {
        setState(() {
          displayMessage = "KEEP IT UP!";
          bestTime = formatTime(fastest.toInt());
        });
      }
    }
  }

  Future<void> _saveTime(int timeInSeconds, String setup) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(setup, timeInSeconds.toDouble());
  }

  Future<double> _readTime(String setup) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double? timeInSeconds = prefs.getDouble(setup);
    return timeInSeconds ?? double.infinity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'GAME OVER',
                style: GoogleFonts.rubikSprayPaint(
                    fontSize: 72,
                    color: Theme.of(context).colorScheme.inversePrimary
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text('Time Elapsed:', style: GoogleFonts.unkempt(fontSize: 24),),
              Text(
                formatTime(_timeElapsed),
                style: GoogleFonts.rubikSprayPaint(fontSize: 36),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                displayMessage,
                style: GoogleFonts.rubikSprayPaint(
                  fontSize: 36,
                  color: Theme.of(context).colorScheme.error
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Best: $bestTime",
                style: GoogleFonts.unkempt(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.error
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(title: "Example"),
                    ),
                  );
                },
                child: Text(
                  'HOME',
                  style: GoogleFonts.rubikSprayPaint(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}