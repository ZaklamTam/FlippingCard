import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game_page.dart';
import 'utils.dart';

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
  DifficultyLabel? selectedDifficulty;
  CardCategory? selectedCategory;

  List<String> _data = [];

  @override
  void initState() {
    super.initState();
  }

  void _generateData(CardCategory theme, int n) {
    _data = theme.emojis.take(n).toList();
    _data.addAll(_data.toList());
    _data.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    // rerun every time setState is called.
    // optimized, so just rebuild anything that needs updating rather than
    // having to individually change instances of widgets.
    return Scaffold(
      /**
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //backgroundColor: Colors.amber,  // individual color settings
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),  **/
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // hmmmm mybe a fun font to use
              Text(
                  'FLIP & MATCH',
                  style: GoogleFonts.rubikSprayPaint(
                    fontSize: 60,
                    color: Theme.of(context).colorScheme.inversePrimary
                  ),
                  textAlign: TextAlign.center
              ),
              const SizedBox(height: 48),
              (selectedCategory != null) ?
                Container(
                    width: 240,
                    height: 240,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(120), // half of width/height = perfect circle
                  ),
                  alignment: AlignmentGeometry.center,
                  child: Text(
                    selectedCategory!.emojis[0],
                    style: GoogleFonts.rubikSprayPaint(fontSize: 120),
                    textAlign: TextAlign.center,
                  )
                ) :
              Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(120), // half of width/height = perfect circle
                  ),
                  alignment: AlignmentGeometry.center,
                  child: Text(
                    "?",
                    style: GoogleFonts.unkempt(fontSize: 120),
                    textAlign: TextAlign.center,
                  )
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: DropdownButton<CardCategory>(
                  isExpanded: true,
                  value: selectedCategory ?? CardCategory.animals,
                  hint: const Text('Category'),
                  onChanged: (CardCategory? category) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  items: CardCategory.values.map<DropdownMenuItem<CardCategory>>((CardCategory category) {
                    return DropdownMenuItem<CardCategory>(
                      value: category,
                      child: Text(
                        category.label,
                        style: GoogleFonts.unkempt(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: DropdownButton<DifficultyLabel>(
                  isExpanded: true,
                  value: selectedDifficulty ?? DifficultyLabel.easy,
                  hint: const Text('Difficulty'),
                  onChanged: (DifficultyLabel? difficulty) {
                    setState(() {
                      selectedDifficulty = difficulty;
                    });
                  },
                  items: DifficultyLabel.values.map<DropdownMenuItem<DifficultyLabel>>((DifficultyLabel difficulty) {
                    return DropdownMenuItem<DifficultyLabel>(
                      value: difficulty,
                      child: Text(
                        difficulty.label,
                        style: GoogleFonts.unkempt(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                )
              ),
              const SizedBox(height: 36),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                onPressed: (selectedDifficulty != null && selectedCategory != null) ? () {
                  setState(() {
                    _generateData(selectedCategory!, selectedDifficulty!.cardNumber);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GamePage(
                        title: "",
                        data: _data, 
                        difficulty: selectedDifficulty!.label,
                        category: selectedCategory!.label,
                      ),
                    ),
                  );
                } : null,  // null for "dont take action"
                child: Text(
                    'START',
                    style: GoogleFonts.rubikSprayPaint(fontSize: 24),
                    textAlign: TextAlign.center,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}