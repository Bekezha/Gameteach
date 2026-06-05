import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class WordCatcherGame extends StatefulWidget {
  const WordCatcherGame({super.key});

  @override
  State<WordCatcherGame> createState() => _WordCatcherGameState();
}

class WordTask {
  final String question;
  final String answer;
  final List<String> letters;

  WordTask({required this.question, required this.answer, required this.letters});
}

class _WordCatcherGameState extends State<WordCatcherGame> {
  final List<WordTask> _tasks = [
    WordTask(
      question: "Ең үлкен планета?",
      answer: "ЮПИТЕР",
      letters: ["Ю", "П", "И", "Т", "Е", "Р", "А", "Б", "С"],
    ),
    WordTask(
      question: "Судың химиялық формуласы?",
      answer: "АШЕКІО",
      letters: ["А", "Ш", "Е", "К", "І", "О", "В", "Г", "Д"],
    ),
    WordTask(
      question: "Қазақстанның астанасы?",
      answer: "АСТАНА",
      letters: ["А", "С", "Т", "А", "Н", "А", "Л", "М", "Ы"],
    ),
    WordTask(
      question: "Күн жүйесінің орталығы?",
      answer: "КҮН",
      letters: ["К", "Ү", "Н", "Ж", "Ұ", "Л", "Д", "Ы", "З"],
    ),
    WordTask(
      question: "Білім ордасы?",
      answer: "МЕКТЕП",
      letters: ["М", "Е", "К", "Т", "Е", "П", "К", "І", "Т"],
    ),
    WordTask(
       question: "Қазақ тілінде неше әріп бар?",
       answer: "ҚЫРЫҚЕКІ",
       letters: ["Қ", "Ы", "Р", "Ы", "Қ", "Е", "К", "І", "О"],
    ),
    WordTask(
       question: "Ең биік тау?",
       answer: "ЭВЕРЕСТ",
       letters: ["Э", "В", "Е", "Р", "Е", "С", "Т", "А", "У"],
    ),
    WordTask(
       question: "Жердің серігі?",
       answer: "АЙ",
       letters: ["А", "Й", "К", "Ү", "Н", "Ж", "Ұ", "Л", "Д"],
    ),
  ];

  int _currentTaskIndex = 0;
  List<int> _selectedIndices = [];
  bool _isSolved = false;

  void _onLetterSelect(int index) {
    if (_isSolved) return;

    setState(() {
      if (_selectedIndices.contains(index)) {
        if (_selectedIndices.last == index) {
          _selectedIndices.removeLast();
        }
      } else {
        _selectedIndices.add(index);
      }

      String currentWord = _selectedIndices
          .map((i) => _tasks[_currentTaskIndex].letters[i])
          .join();

      if (currentWord == _tasks[_currentTaskIndex].answer) {
        _isSolved = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          _showWowAnimation();
        });
      } else if (currentWord.length >= _tasks[_currentTaskIndex].answer.length) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!_isSolved) {
            setState(() {
              _selectedIndices = [];
            });
          }
        });
      }
    });
  }

  void _showWowAnimation() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "WOW!",
              style: TextStyle(
                color: Colors.yellowAccent,
                fontSize: 80,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "КЕРЕМЕТ!",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.pop(context);
                _nextTask();
              },
              child: const Text("Келесі сөз", style: TextStyle(color: Colors.black, fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }

  void _nextTask() {
    setState(() {
      if (_currentTaskIndex < _tasks.length - 1) {
        _currentTaskIndex++;
        _selectedIndices = [];
        _isSolved = false;
      } else {
        _showFinalResult();
      }
    });
  }

  void _showFinalResult() {
    context.read<UserProvider>().updateStats(answeredQuestions: _tasks.length, gamesPlayed: 1);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ойын аяқталды!"),
        content: const Text("Сіз барлық сөздерді таптыңыз!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Мәзірге"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_tasks.isEmpty) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    
    final task = _tasks[_currentTaskIndex % _tasks.length];
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text("Ловец слов", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              task.question,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          _buildLetterGrid(task),
          const Spacer(),
          _buildSelectedWord(task),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildLetterGrid(WordTask task) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: task.letters.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedIndices.contains(index);
          return GestureDetector(
            onTap: () => _onLetterSelect(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orangeAccent : Colors.white10,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.white24,
                  width: 2,
                ),
                boxShadow: isSelected ? [
                  const BoxShadow(color: Colors.orange, blurRadius: 10, spreadRadius: 2)
                ] : [],
              ),
              child: Center(
                child: Text(
                  task.letters[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedWord(WordTask task) {
    String currentWord = _selectedIndices.map((i) => task.letters[i]).join();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        currentWord.isEmpty ? "..." : currentWord,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 36,
          letterSpacing: 4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
