import 'dart:async';
import 'package:flutter/material.dart';

class VictorinaScreen extends StatefulWidget {
  const VictorinaScreen({super.key});

  @override
  State<VictorinaScreen> createState() => _VictorinaScreenState();
}

class _VictorinaScreenState extends State<VictorinaScreen> {
  // Сұрақтар тізімі
  final List<Map<String, dynamic>> questions = [
    {
      "question": "1. Ең үлкен планета қайсы?",
      "options": ["Жер", "Юпитер", "Сатурн", "Нептун"],
      "answer": "Юпитер",
    },
    {
      "question": "2. Flutter қай тілде жазылған?",
      "options": ["Java", "Python", "Dart", "Swift"],
      "answer": "Dart",
    },
    {
      "question": "3. Қазақстан тәуелсіздігін қашан алды?",
      "options": ["1991", "1989", "1993", "1990"],
      "answer": "1991",
    },
    {
      "question": "4. 7 * 8 нәтижесі неге тең?",
      "options": ["54", "56", "64", "58"],
      "answer": "56",
    },
    {
      "question": "5. Қай жануар ең жылдам?",
      "options": ["Гепард", "Жолбарыс", "Арыстан", "Қасқыр"],
      "answer": "Гепард",
    },
    {
      "question": "6. HTML нені білдіреді?",
      "options": [
        "HyperText Markup Language",
        "Hyper Transfer Machine Language",
        "HighText Machine Language",
        "Home Tool Markup Language",
      ],
      "answer": "HyperText Markup Language",
    },
    {
      "question": "7. Қазақстанның астанасы?",
      "options": ["Алматы", "Астана", "Шымкент", "Қарағанды"],
      "answer": "Астана",
    },
    {
      "question": "8. ДНҚ не сақтайды?",
      "options": [
        "Энергия",
        "Жасуша қабырғасы",
        "Генетикалық ақпарат",
        "Қан құрамы",
      ],
      "answer": "Генетикалық ақпарат",
    },
    {
      "question": "9. Бір жылда неше ай бар?",
      "options": ["10", "11", "12", "13"],
      "answer": "12",
    },
    {
      "question": "10. Теңдеуді шеш: 15 - 7 + 3 = ?",
      "options": ["9", "11", "13", "10"],
      "answer": "11",
    },
  ];

  int currentQuestion = 0;
  int score = 0;
  bool answered = false;
  String? selectedOption;

  // Таймер
  int timeLeft = 15;
  Timer? timer;

  void startTimer() {
    timer?.cancel();
    timeLeft = 15;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
      if (option == questions[currentQuestion]["answer"]) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      nextQuestion();
    });
  }

  void showResultDialog() {
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
              score < 4
                  ? "Көбірек дайындалу керек 😅"
                  : score < 8
                  ? "Жақсы нәтиже 👏"
                  : "Керемет, сен нағыз зияткерсің! 🧠",
              style: const TextStyle(fontWeight: FontWeight.bold),
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
              Navigator.pop(context);
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
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];
    final progress = ((currentQuestion + 1) / questions.length).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text("🧠 Victorina Game"),
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
              question["question"],
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
                itemCount: question["options"].length,
                itemBuilder: (context, index) {
                  final option = question["options"][index];
                  final isCorrect = option == question["answer"];
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
                      title: Text(option),
                      onTap: () => checkAnswer(option),
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
