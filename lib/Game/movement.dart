import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class QuestionGame extends StatefulWidget {
  const QuestionGame({super.key});

  @override
  State<QuestionGame> createState() => _QuestionGameState();
}

class _QuestionGameState extends State<QuestionGame> {
  int currentQuestion = 0;
  int score = 0;

  final List<Map<String, Object>> questions = [
    {
      'question': '1) Қазақстанның астанасы қай қала?',
      'answers': ['Алматы', 'Астана', 'Шымкент', 'Қарағанды'],
      'correct': 1,
    },
    {
      'question': '2) Flutter қай тілде жазылған?',
      'answers': ['Python', 'C++', 'Dart', 'Java'],
      'correct': 2,
    },
    {
      'question': '3) Arduino не үшін қолданылады?',
      'answers': [
        'Веб сайт жасау үшін',
        'Электронды құрылғыларды басқару үшін',
        'Видео ойын ойнау үшін',
        'Мәтін жазу үшін',
      ],
      'correct': 1,
    },
    {
      'question': '4) Қазақстан Тәуелсіздігін қашан алды?',
      'answers': ['1990', '1991', '1992', '1993'],
      'correct': 1,
    },
    {
      'question': '5) Компьютердің "миы" қалай аталады?',
      'answers': ['Жедел жад', 'Қатты диск', 'Процессор', 'Монитор'],
      'correct': 2,
    },
    {
      'question': '6) HTML не үшін қолданылады?',
      'answers': [
        'Мобильді қосымша жасау',
        'Веб парақ құрылымын жазу',
        'Деректер базасын басқару',
        'Кодты шифрлау',
      ],
      'correct': 1,
    },
    {
      'question': '7) Қазақстан Республикасының тұңғыш президенті кім?',
      'answers': [
        'Нұрсұлтан Назарбаев',
        'Қасым-Жомарт Тоқаев',
        'Дінмұхамед Қонаев',
        'Әлихан Бөкейхан',
      ],
      'correct': 0,
    },
    {
      'question': '8) Dart тілінде айнымалы қалай жарияланады?',
      'answers': ['var x = 5;', 'int x: 5;', 'let x = 5;', 'define x = 5;'],
      'correct': 0,
    },
    {
      'question': '9) Электр тогын өлшейтін құрал?',
      'answers': ['Амперметр', 'Вольтметр', 'Омметр', 'Мультиметр'],
      'correct': 0,
    },
    {
      'question': '10) Flutter қолданбасын іске қосу командасы?',
      'answers': [
        'flutter new',
        'flutter build',
        'flutter start',
        'flutter run',
      ],
      'correct': 3,
    },
    {
      'question': '11) Қазақстанда неше облыс бар?',
      'answers': ['14', '17', '19', '20'],
      'correct': 2,
    },
    {
      'question': '12) Жарық датчигі қалай аталады?',
      'answers': ['LDR', 'LED', 'LCD', 'IR'],
      'correct': 0,
    },
    {
      'question': '13) Кодтағы қателерді түзету процесі қалай аталады?',
      'answers': ['Debugging', 'Running', 'Compiling', 'Testing'],
      'correct': 0,
    },
    {
      'question': '14) Flutter қосымшасы қандай тілде жазылады?',
      'answers': ['C#', 'Kotlin', 'Dart', 'Swift'],
      'correct': 2,
    },
    {
      'question': '15) Қазақстанның ең ірі көлі?',
      'answers': ['Балқаш', 'Каспий', 'Арал', 'Зайсан'],
      'correct': 1,
    },
    {
      'question': '16) “if” шарты не үшін қолданылады?',
      'answers': [
        'Мәлімет енгізу үшін',
        'Шартты тексеру үшін',
        'Цикл жасау үшін',
        'Функция жазу үшін',
      ],
      'correct': 1,
    },
    {
      'question': '17) Электронды плата элементі қалай аталады?',
      'answers': ['Резистор', 'Проволка', 'Қағаз', 'Батарея'],
      'correct': 0,
    },
    {
      'question': '18) Интернет дегеніміз не?',
      'answers': [
        'Компьютердің жады',
        'Әлемдік желі',
        'Бағдарлама түрі',
        'Ойын платформасы',
      ],
      'correct': 1,
    },
    {
      'question': '19) Flutter-де экран ауыстыру үшін не қолданылады?',
      'answers': [
        'Navigator.push()',
        'Screen.change()',
        'App.move()',
        'Page.switch()',
      ],
      'correct': 0,
    },
    {
      'question': '20) Микроконтроллер дегеніміз не?',
      'answers': [
        'Бағдарлама редакторы',
        'Кішкентай компьютер чипі',
        'Монитор түрі',
        'Дыбыс құрылғысы',
      ],
      'correct': 1,
    },
  ];

  void answerQuestion(int selected) {
    final correctIndex = questions[currentQuestion]['correct'] as int;
    if (selected == correctIndex) {
      score++;
    }

    setState(() {
      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
      } else {
        context.read<UserProvider>().updateStats(answeredQuestions: score, gamesPlayed: 1);
        
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('🎉 Ойын аяқталды!'),
            content: Text('Сенің ұпайың: $score / ${questions.length}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    currentQuestion = 0;
                    score = 0;
                  });
                },
                child: const Text('Қайта бастау'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];
    final answers = question['answers'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Сұрақ-жауап ойыны'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question['question'] as String,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...List.generate(answers.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.deepPurple[200],
                  ),
                  onPressed: () => answerQuestion(index),
                  child: Text(answers[index]),
                ),
              );
            }),
            const SizedBox(height: 30),
            Text(
              'Сұрақ: ${currentQuestion + 1} / ${questions.length}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
