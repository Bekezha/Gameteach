import 'package:flutter/material.dart';

class WordCatcherGame extends StatefulWidget {
  const WordCatcherGame({Key? key}) : super(key: key);

  @override
  State<WordCatcherGame> createState() => _WordCatcherGameState();
}

class _WordCatcherGameState extends State<WordCatcherGame> with TickerProviderStateMixin {
  final List<String> _letters = ["Т", "М", "К", "Р", "О", "С", "Л", "В", "А"];
  final List<int> _targetSequence = [2, 4, 0]; // К, О, Т
  
  List<int> _selectedIndexes = [];
  bool _isWordComplete = false;

  void _onLetterTap(int index) {
    if (_isWordComplete) return;

    setState(() {
      // If we clicked the correct next letter in sequence
      if (_selectedIndexes.length < _targetSequence.length &&
          _targetSequence[_selectedIndexes.length] == index) {
        _selectedIndexes.add(index);

        if (_selectedIndexes.length == _targetSequence.length) {
          _isWordComplete = true; // "КОТ" is formed
        }
      } else {
        // Wrong letter, reset
        _selectedIndexes.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Ловец слов", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2b5876), Color(0xFF4e4376)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Собери слово: КОТ (нажимай по порядку)",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 50),
              
              // Morphing Area
              SizedBox(
                height: 150,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child));
                    },
                    child: _isWordComplete
                        ? _buildFinalMorphIcon()
                        : _buildCurrentWord(),
                  ),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Grid of Letters
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: _letters.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedIndexes.contains(index);
                    return GestureDetector(
                      onTap: () => _onLetterTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.pinkAccent : Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isSelected
                              ? [const BoxShadow(color: Colors.pink, blurRadius: 15, spreadRadius: 5)]
                              : [],
                          border: Border.all(color: Colors.white54, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            _letters[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 40),
              
              if (_isWordComplete)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndexes.clear();
                      _isWordComplete = false;
                    });
                  },
                  child: const Text("Искать дальше", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentWord() {
    String currentWord = "";
    for (int i in _selectedIndexes) {
      currentWord += _letters[i];
    }
    
    return Text(
      currentWord.isEmpty ? "..." : currentWord,
      key: const ValueKey("text"),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 48,
        fontWeight: FontWeight.bold,
        letterSpacing: 8,
      ),
    );
  }

  Widget _buildFinalMorphIcon() {
    return Container(
      key: const ValueKey("icon"),
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.pinkAccent.withOpacity(0.3),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: Colors.pinkAccent, blurRadius: 40, spreadRadius: 10)
        ]
      ),
      child: const Center(
        child: Icon(Icons.pets, size: 80, color: Colors.white),
      ),
    );
  }
}
