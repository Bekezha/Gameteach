import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class FireflyMathGame extends StatefulWidget {
  const FireflyMathGame({super.key});

  @override
  State<FireflyMathGame> createState() => _FireflyMathGameState();
}

class MathTask {
  final String equationPrefix;
  final String equationSuffix;
  final int targetAnswer;
  final List<int> options;

  MathTask({
    required this.equationPrefix,
    required this.equationSuffix,
    required this.targetAnswer,
    required this.options,
  });
}

class _FireflyMathGameState extends State<FireflyMathGame> with TickerProviderStateMixin {
  int? _selectedLevel;
  int _currentTaskIndex = 0;
  bool _isSolved = false;
  int _correctAnswers = 0;

  
  late AnimationController _fireflyController;
  late Animation<Offset> _fireflyAnimation;

  final Map<int, List<MathTask>> _levelTasks = {
    1: [
      MathTask(equationPrefix: "2 + ", equationSuffix: " = 5", targetAnswer: 3, options: [1, 2, 3, 4]),
      MathTask(equationPrefix: "1 + ", equationSuffix: " = 4", targetAnswer: 3, options: [2, 3, 4, 5]),
      MathTask(equationPrefix: "6 + ", equationSuffix: " = 9", targetAnswer: 3, options: [2, 3, 4, 5]),
      MathTask(equationPrefix: "4 + ", equationSuffix: " = 10", targetAnswer: 6, options: [4, 5, 6, 7]),
      MathTask(equationPrefix: "5 + ", equationSuffix: " = 8", targetAnswer: 3, options: [1, 2, 3, 4]),
      MathTask(equationPrefix: "3 + ", equationSuffix: " = 6", targetAnswer: 3, options: [2, 3, 4, 5]),
      MathTask(equationPrefix: "7 + ", equationSuffix: " = 10", targetAnswer: 3, options: [1, 2, 3, 4]),
      MathTask(equationPrefix: "2 + ", equationSuffix: " = 9", targetAnswer: 7, options: [6, 7, 8, 9]),
    ],
    2: [
      MathTask(equationPrefix: "10 - ", equationSuffix: " = 6", targetAnswer: 4, options: [3, 4, 5, 6]),
      MathTask(equationPrefix: "9 - ", equationSuffix: " = 2", targetAnswer: 7, options: [6, 7, 8, 9]),
      MathTask(equationPrefix: "8 - ", equationSuffix: " = 3", targetAnswer: 5, options: [4, 5, 6, 7]),
      MathTask(equationPrefix: "10 - ", equationSuffix: " = 1", targetAnswer: 9, options: [7, 8, 9, 10]),
      MathTask(equationPrefix: "7 - ", equationSuffix: " = 4", targetAnswer: 3, options: [1, 2, 3, 4]),
      MathTask(equationPrefix: "6 - ", equationSuffix: " = 2", targetAnswer: 4, options: [3, 4, 5, 6]),
      MathTask(equationPrefix: "5 - ", equationSuffix: " = 5", targetAnswer: 0, options: [0, 1, 2, 3]),
      MathTask(equationPrefix: "10 - ", equationSuffix: " = 2", targetAnswer: 8, options: [7, 8, 9, 10]),
    ],
    3: [
      MathTask(equationPrefix: "2 × ", equationSuffix: " = 10", targetAnswer: 5, options: [4, 5, 6, 7]),
      MathTask(equationPrefix: "3 × ", equationSuffix: " = 9", targetAnswer: 3, options: [2, 3, 4, 5]),
      MathTask(equationPrefix: "4 × ", equationSuffix: " = 8", targetAnswer: 2, options: [1, 2, 3, 4]),
      MathTask(equationPrefix: "5 × ", equationSuffix: " = 10", targetAnswer: 2, options: [1, 2, 3, 4]),
      MathTask(equationPrefix: "2 × ", equationSuffix: " = 8", targetAnswer: 4, options: [3, 4, 5, 6]),
      MathTask(equationPrefix: "1 × ", equationSuffix: " = 7", targetAnswer: 7, options: [6, 7, 8, 9]),
      MathTask(equationPrefix: "3 × ", equationSuffix: " = 6", targetAnswer: 2, options: [1, 2, 3, 4]),
      MathTask(equationPrefix: "4 × ", equationSuffix: " = 4", targetAnswer: 1, options: [1, 2, 3, 4]),
    ],
    4: [
      MathTask(equationPrefix: "10 ÷ ", equationSuffix: " = 2", targetAnswer: 5, options: [3, 4, 5, 6]),
      MathTask(equationPrefix: "8 ÷ ", equationSuffix: " = 4", targetAnswer: 2, options: [1, 2, 3, 4]),
      MathTask(equationPrefix: "9 ÷ ", equationSuffix: " = 3", targetAnswer: 3, options: [2, 3, 4, 5]),
      MathTask(equationPrefix: "6 ÷ ", equationSuffix: " = 2", targetAnswer: 3, options: [1, 2, 3, 4]),
      MathTask(equationPrefix: "10 ÷ ", equationSuffix: " = 5", targetAnswer: 2, options: [1, 2, 3, 4]),
      MathTask(equationPrefix: "4 ÷ ", equationSuffix: " = 2", targetAnswer: 2, options: [1, 2, 3, 4]),
      MathTask(equationPrefix: "2 ÷ ", equationSuffix: " = 1", targetAnswer: 2, options: [1, 2, 3, 4]),
      MathTask(equationPrefix: "10 ÷ ", equationSuffix: " = 10", targetAnswer: 1, options: [1, 2, 3, 4]),
    ],
    5: [
      MathTask(equationPrefix: "(2 + 3) × ", equationSuffix: " = 10", targetAnswer: 2, options: [1, 2, 3, 4]),
      MathTask(equationPrefix: "2 + 2 × ", equationSuffix: " = 10", targetAnswer: 4, options: [3, 4, 5, 6]),
      MathTask(equationPrefix: "10 - 2 × ", equationSuffix: " = 4", targetAnswer: 3, options: [2, 3, 4, 5]),
      MathTask(equationPrefix: "9 - 1 × ", equationSuffix: " = 6", targetAnswer: 3, options: [2, 3, 4, 5]),
      MathTask(equationPrefix: "8 ÷ (2 × ", equationSuffix: ") = 1", targetAnswer: 4, options: [3, 4, 5, 6]),
      MathTask(equationPrefix: "5 × 2 - ", equationSuffix: " = 7", targetAnswer: 3, options: [2, 3, 4, 5]),
      MathTask(equationPrefix: "(10 - 2) ÷ ", equationSuffix: " = 2", targetAnswer: 4, options: [3, 4, 5, 6]),
      MathTask(equationPrefix: "3 + 1 × ", equationSuffix: " = 7", targetAnswer: 4, options: [3, 4, 5, 6]),
    ],
  };

  @override
  void initState() {
    super.initState();
    _fireflyController = AnimationController(
       vsync: this,
       duration: const Duration(seconds: 2),
    );

    _fireflyAnimation = Tween<Offset>(
      begin: const Offset(0.1, 0.8),
      end: const Offset(0.8, 0.1),
    ).animate(CurvedAnimation(
      parent: _fireflyController,
      curve: Curves.easeInOutQuad,
    ));
  }

  @override
  void dispose() {
    _fireflyController.dispose();
    super.dispose();
  }

  void _onAcceptAnswer(int number) {
    final tasks = _levelTasks[_selectedLevel]!;
    final currentTask = tasks[_currentTaskIndex];

    if (number == currentTask.targetAnswer) {
      setState(() {
        _isSolved = true;
        _correctAnswers++;
      });
      _fireflyController.forward();
    }
  }

  void _nextTask() {
    final tasks = _levelTasks[_selectedLevel]!;
    setState(() {
      if (_currentTaskIndex < tasks.length - 1) {
        _currentTaskIndex++;
        _isSolved = false;
        _fireflyController.reset();
      } else {
        // Level complete!
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    context.read<UserProvider>().updateStats(answeredQuestions: _correctAnswers, gamesPlayed: 1);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Деңгей аяқталды!"),
        content: Text("Сіз $_selectedLevel деңгейіндегі барлық тапсырмаларды орындадыңыз!\nДұрыс жауаптар: $_correctAnswers"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              setState(() {
                _selectedLevel = null;
                _currentTaskIndex = 0;
                _correctAnswers = 0;
                _isSolved = false;
                _fireflyController.reset();
              });
            },
            child: const Text("Деңгей таңдау"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit game
            },
            child: const Text("Мәзірге"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Магический лес", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
         decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF1E3C2F), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _selectedLevel == null ? _buildLevelSelection() : _buildGameContent(),
      ),
    );
  }

  Widget _buildLevelSelection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Выберите уровень сложности", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          ...List.generate(5, (index) {
            int level = index + 1;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white24,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedLevel = level;
                      _currentTaskIndex = 0;
                    });
                  },
                  child: Text("Уровень $level", style: const TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGameContent() {
    final tasks = _levelTasks[_selectedLevel]!;
    final currentTask = tasks[_currentTaskIndex];

    return Stack(
      children: [
        // Flower (Target)
        Positioned(
          top: MediaQuery.of(context).size.height * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          child: const Icon(Icons.local_florist, color: Colors.pinkAccent, size: 80),
        ),
        
        // Firefly
        AnimatedBuilder(
          animation: _fireflyAnimation,
          builder: (context, child) {
            return Positioned(
              left: MediaQuery.of(context).size.width * _fireflyAnimation.value.dx,
              top: MediaQuery.of(context).size.height * _fireflyAnimation.value.dy,
               child: _buildFirefly(),
            );
          },
        ),

        // Equation Area at the bottom
        Positioned(
          bottom: 50,
          left: 20,
          right: 20,
          child: Column(
            children: [
              Text(
                "Задание ${_currentTaskIndex + 1} из ${tasks.length}",
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 10),
              _buildEquationSlot(currentTask),
              const SizedBox(height: 30),
              if (!_isSolved)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: currentTask.options.map((n) => _buildDraggableNumber(n)).toList(),
                ),
              if (_isSolved)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.amber,
                     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: _nextTask,
                  child: const Text("Следующая загадка", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildFirefly() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.yellowAccent,
        boxShadow: [
           BoxShadow(
             color: Colors.amberAccent.withValues(alpha: 0.8),
             blurRadius: 20,
             spreadRadius: 10,
           ),
        ],
      ),
      child: const Icon(Icons.bug_report, size: 20, color: Colors.orange),
    );
  }

  Widget _buildEquationSlot(MathTask task) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.lightGreenAccent, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(task.equationPrefix, style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
          DragTarget<int>(
            builder: (context, candidateData, rejectedData) {
              final isHovered = candidateData.isNotEmpty;
              return Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _isSolved 
                    ? Colors.greenAccent 
                    : (isHovered ? Colors.lightGreenAccent.withValues(alpha: 0.5) : Colors.white24),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: isHovered ? Colors.yellow : Colors.transparent, width: 2),
                ),
                child: Center(
                  child: Text(
                    _isSolved ? task.targetAnswer.toString() : "?",
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
            onWillAcceptWithDetails: (details) => true,
            onAcceptWithDetails: (details) {
               _onAcceptAnswer(details.data);
            },
          ),
          Text(task.equationSuffix, style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDraggableNumber(int number) {
    final block = Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orangeAccent, Colors.deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 5, offset: Offset(2, 2))],
      ),
      child: Center(
        child: Text(number.toString(), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
      ),
    );

    return Draggable<int>(
      data: number,
      feedback: Transform.scale(scale: 1.2, child: block),
      childWhenDragging: Opacity(opacity: 0.3, child: block),
      child: block,
    );
  }
}
