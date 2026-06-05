import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class PlayCustomGameScreen extends StatefulWidget {
  final Map<String, dynamic> game;

  const PlayCustomGameScreen({super.key, required this.game});

  @override
  State<PlayCustomGameScreen> createState() => _PlayCustomGameScreenState();
}

class _PlayCustomGameScreenState extends State<PlayCustomGameScreen> {
  late List<dynamic> questions;
  int currentQuestion = 0;
  int score = 0;
  bool answered = false;
  String? selectedOption;

  // Таймер
  int timeLeft = 15;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    questions = widget.game['questions'] ?? [];
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = 15;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        nextQuestion();
      }
    });
  }

  void nextQuestion() {
    if (questions.isEmpty) return;
    
    setState(() {
      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
        answered = false;
        selectedOption = null;
        startTimer();
      } else {
        timer?.cancel();
        showResultDialog();
      }
    });
  }

  void checkAnswer(String option) {
    if (answered) return;

    setState(() {
      answered = true;
      selectedOption = option;
      if (option == questions[currentQuestion]["correctAnswer"]) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) nextQuestion();
    });
  }

  void showResultDialog() {
    // Начисляем очки
    context.read<UserProvider>().updateStats(answeredQuestions: score, gamesPlayed: 1);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Ойын аяқталды 🎉"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Сен ${questions.length} сұрақтың $score-не дұрыс жауап бердің!",
            ),
            const SizedBox(height: 12),
            Text(
              score == questions.length
                  ? "Керемет, сен нағыз зияткерсің! 🧠"
                  : "Жақсы нәтиже 👏 Попробуй еще раз!",
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text("Қайта ойнау"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Возврат на список игр
            },
            child: const Text("Шығу"),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      score = 0;
      currentQuestion = 0;
      answered = false;
      selectedOption = null;
      startTimer();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.game['title'] ?? 'Ойын')),
        body: const Center(child: Text("Сұрақтар жоқ")),
      );
    }

    final question = questions[currentQuestion];
    final progress = ((currentQuestion + 1) / questions.length).clamp(0.0, 1.0);
    List<dynamic> options = question["options"] ?? [];

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Text(widget.game['title'] ?? 'Ойын'),
        backgroundColor: const Color.fromARGB(255, 191, 88, 209),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              color: Colors.deepPurple,
              backgroundColor: Colors.deepPurple.shade100,
            ),
            const SizedBox(height: 20),
            Text(
              question["question"] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "Қалған уақыт: $timeLeft сек",
              style: const TextStyle(fontSize: 16, color: Colors.redAccent),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isCorrect = option == question["correctAnswer"];
                  final isSelected = option == selectedOption;

                  Color optionColor() {
                    if (!answered) return Colors.white;
                    if (isSelected && isCorrect) return Colors.green.shade200;
                    if (isSelected && !isCorrect) return Colors.red.shade200;
                    if (isCorrect) return Colors.green.shade100;
                    return Colors.white;
                  }

                  return Card(
                    color: optionColor(),
                    child: ListTile(
                      title: Text(option.toString()),
                      onTap: () => checkAnswer(option.toString()),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Ұпай: $score / ${questions.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
