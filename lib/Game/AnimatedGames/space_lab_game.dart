import 'dart:math'; // Added for max()
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class SpaceLabGame extends StatefulWidget {
  const SpaceLabGame({super.key});

  @override
  State<SpaceLabGame> createState() => _SpaceLabGameState();
}

class ChemistryTask {
  final String formula;
  final String name;
  final String targetElement;
  final int targetCount;
  final Color elementColor;

  ChemistryTask({
    required this.formula,
    required this.name,
    required this.targetElement,
    required this.targetCount,
    required this.elementColor,
  });
}

class _SpaceLabGameState extends State<SpaceLabGame>
    with TickerProviderStateMixin {
  int? _selectedLevel;
  int _currentTaskIndex = 0;
  int _currentElementCount = 0;
  bool _isSolved = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _particlesController;
  late AnimationController _shakeController;
  bool _isError = false;

  final Map<int, List<ChemistryTask>> _levelTasks = {
    1: [
      ChemistryTask(
        formula: "H₂O",
        name: "Су",
        targetElement: "H",
        targetCount: 2,
        elementColor: Colors.lightBlueAccent,
      ),
      ChemistryTask(
        formula: "CO₂",
        name: "Көмірқышқыл газы",
        targetElement: "O",
        targetCount: 2,
        elementColor: Colors.redAccent,
      ),
      ChemistryTask(
        formula: "O₂",
        name: "Оттегі",
        targetElement: "O",
        targetCount: 2,
        elementColor: Colors.redAccent,
      ),
      ChemistryTask(
        formula: "N₂",
        name: "Азот",
        targetElement: "N",
        targetCount: 2,
        elementColor: Colors.purpleAccent,
      ),
      ChemistryTask(
        formula: "H₂",
        name: "Сутегі",
        targetElement: "H",
        targetCount: 2,
        elementColor: Colors.lightBlueAccent,
      ),
      ChemistryTask(
        formula: "CO",
        name: "Иіс газы",
        targetElement: "O",
        targetCount: 1,
        elementColor: Colors.redAccent,
      ),
    ],
    2: [
      ChemistryTask(
        formula: "NH₃",
        name: "Аммиак",
        targetElement: "H",
        targetCount: 3,
        elementColor: Colors.lightBlueAccent,
      ),
      ChemistryTask(
        formula: "CH₄",
        name: "Метан",
        targetElement: "H",
        targetCount: 4,
        elementColor: Colors.lightBlueAccent,
      ),
      ChemistryTask(
        formula: "SO₂",
        name: "Күкірт диоксиді",
        targetElement: "O",
        targetCount: 2,
        elementColor: Colors.redAccent,
      ),
      ChemistryTask(
        formula: "Li₂O",
        name: "Литий оксиді",
        targetElement: "Li",
        targetCount: 2,
        elementColor: Colors.orangeAccent,
      ),
      ChemistryTask(
        formula: "MgO",
        name: "Магний оксиді",
        targetElement: "Mg",
        targetCount: 1,
        elementColor: Colors.grey,
      ),
      ChemistryTask(
        formula: "NaCl",
        name: "Тұз",
        targetElement: "Cl",
        targetCount: 1,
        elementColor: Colors.greenAccent,
      ),
    ],
    3: [
      ChemistryTask(
        formula: "H₂SO₄",
        name: "Серная кислота",
        targetElement: "O",
        targetCount: 4,
        elementColor: Colors.redAccent,
      ),
      ChemistryTask(
        formula: "HNO₃",
        name: "Азотная кислота",
        targetElement: "O",
        targetCount: 3,
        elementColor: Colors.redAccent,
      ),
      ChemistryTask(
        formula: "CaCO₃",
        name: "Мел",
        targetElement: "O",
        targetCount: 3,
        elementColor: Colors.redAccent,
      ),
      ChemistryTask(
        formula: "KMnO₄",
        name: "Марганцовка",
        targetElement: "O",
        targetCount: 4,
        elementColor: Colors.redAccent,
      ),
      ChemistryTask(
        formula: "C₆H₁₂O₆",
        name: "Глюкоза",
        targetElement: "C",
        targetCount: 6,
        elementColor: Colors.grey,
      ),
      ChemistryTask(
        formula: "H₂O₂",
        name: "Перекись водорода",
        targetElement: "O",
        targetCount: 2,
        elementColor: Colors.redAccent,
      ),
    ],
    4: [
      ChemistryTask(
        formula: "Fe₂O₃",
        name: "Ржавчина",
        targetElement: "Fe",
        targetCount: 2,
        elementColor: Colors.brown,
      ),
      ChemistryTask(
        formula: "Al₂O₃",
        name: "Оксид алюминия",
        targetElement: "Al",
        targetCount: 2,
        elementColor: Colors.blueGrey,
      ),
      ChemistryTask(
        formula: "P₂O₅",
        name: "Оксид фосфора",
        targetElement: "P",
        targetCount: 2,
        elementColor: Colors.yellowAccent,
      ),
      ChemistryTask(
        formula: "C₂H₅OH",
        name: "Спирт",
        targetElement: "H",
        targetCount: 6,
        elementColor: Colors.lightBlueAccent,
      ),
      ChemistryTask(
        formula: "CuSO₄",
        name: "Медный купорос",
        targetElement: "O",
        targetCount: 4,
        elementColor: Colors.redAccent,
      ),
      ChemistryTask(
        formula: "AgNO₃",
        name: "Нитрат серебра",
        targetElement: "O",
        targetCount: 3,
        elementColor: Colors.redAccent,
      ),
    ],
    5: [
      ChemistryTask(
        formula: "C₈H₁₈",
        name: "Октан",
        targetElement: "C",
        targetCount: 8,
        elementColor: Colors.grey,
      ),
      ChemistryTask(
        formula: "C₁₂H₂₂O₁₁",
        name: "Сахар",
        targetElement: "O",
        targetCount: 11,
        elementColor: Colors.redAccent,
      ),
      ChemistryTask(
        formula: "K₂Cr₂O₇",
        name: "Дихромат калия",
        targetElement: "O",
        targetCount: 7,
        elementColor: Colors.redAccent,
      ),
      ChemistryTask(
        formula: "Na₂S₂O₃",
        name: "Тиосульфат натрия",
        targetElement: "O",
        targetCount: 3,
        elementColor: Colors.redAccent,
      ),
      ChemistryTask(
        formula: "C₂₀H₁₄O₄",
        name: "Фенолфталеин",
        targetElement: "C",
        targetCount: 20,
        elementColor: Colors.grey,
      ),
      ChemistryTask(
        formula: "Cu₂(OH)₂CO₃",
        name: "Малахит",
        targetElement: "OH",
        targetCount: 2,
        elementColor: Colors.greenAccent,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _particlesController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _onAcceptElement(bool success) {
    if (!success) {
      setState(() {
        _isError = true;
      });
      _shakeController.forward(from: 0.0).then((_) {
        setState(() {
          _isError = false;
        });
      });
      return;
    }

    final tasks = _levelTasks[_selectedLevel]!;
    final currentTask = tasks[_currentTaskIndex];

    setState(() {
      _currentElementCount++;
      if (_currentElementCount >= currentTask.targetCount) {
        _isSolved = true;
        _particlesController.forward(from: 0.0);
      }
    });
  }

  void _nextTask() {
    final tasks = _levelTasks[_selectedLevel]!;
    setState(() {
      if (_currentTaskIndex < tasks.length - 1) {
        _currentTaskIndex++;
        _currentElementCount = 0;
        _isSolved = false;
        _particlesController.reset();
      } else {
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    final tasksCompleted = _levelTasks[_selectedLevel]?.length ?? 0;
    context.read<UserProvider>().updateStats(answeredQuestions: tasksCompleted, gamesPlayed: 1);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Эксперименты завершены!"),
        content: Text(
          "Вы успешно собрали все молекулы на уровне $_selectedLevel!",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _selectedLevel = null;
                _currentTaskIndex = 0;
                _currentElementCount = 0;
                _isSolved = false;
              });
            },
            child: const Text("К выбору уровня"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("В меню"),
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
        title: const Text(
          "Космическая лаборатория",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _selectedLevel == null
            ? _buildLevelSelection()
            : _buildGameContent(),
      ),
    );
  }

  Widget _buildLevelSelection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Выберите уровень лаборатории",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          ...List.generate(5, (index) {
            int level = index + 1;
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 40,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white24,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedLevel = level;
                      _currentTaskIndex = 0;
                    });
                  },
                  child: Text(
                    "Уровень $level",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
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
        // Background Stars
        ...List.generate(30, (index) => _buildStar(index)),

        // Draggable Elements
        if (!_isSolved) ...[
          Positioned(
            top: 150,
            left: 50,
            child: _buildDraggableAtom(
              currentTask.targetElement,
              currentTask.elementColor,
            ),
          ),
          Positioned(
            bottom: 150,
            right: 50,
            child: _buildDraggableAtom(
              "N", // Wrong element
              Colors.purpleAccent,
            ),
          ),
          Positioned(
            top: 300,
            right: 100,
            child: _buildDraggableAtom(
              "C", // Wrong element
              Colors.grey,
            ),
          ),
        ],

        // Center Target
        Center(
          child: _isSolved
              ? _buildMolecule(currentTask)
              : _buildOxygenTarget(currentTask),
        ),

        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Center(
            child: Column(
              children: [
                Text(
                  "Из чего состоит ${currentTask.name}?",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_currentElementCount > 0)
                  Text(
                    "(${currentTask.formula})",
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
              ],
            ),
          ),
        ),

        if (_isSolved)
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _nextTask,
                child: const Text(
                  "Следующий опыт",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStar(int index) {
    final rand = (index * 13) % 100;
    return Positioned(
      top: (index * 25.0) % MediaQuery.of(context).size.height,
      left: (rand * 15.0) % MediaQuery.of(context).size.width,
      child: Container(
        width: 2,
        height: 2,
        decoration: const BoxDecoration(
          color: Colors.white54,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildDraggableAtom(String symbol, Color color) {
    final atomWidget = Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Text(
          symbol,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Draggable<String>(
      data: symbol,
      feedback: Transform.scale(scale: 1.2, child: atomWidget),
      childWhenDragging: Opacity(opacity: 0.3, child: atomWidget),
      child: ScaleTransition(scale: _pulseAnimation, child: atomWidget),
    );
  }

  Widget _buildOxygenTarget(ChemistryTask task) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;
        
        // Shake animation for error
        return AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            final double offset = (sin(_shakeController.value * 10 * pi) * 10) * (_isError ? 1 : 0);
            return Transform.translate(
              offset: Offset(offset, 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isHovered ? 150 : 120,
                height: isHovered ? 150 : 120,
                decoration: BoxDecoration(
                  color: _isError 
                      ? Colors.red 
                      : (isHovered ? task.elementColor.withValues(alpha: 0.9) : Colors.white10),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isError ? Colors.orange : (isHovered ? Colors.white : Colors.white24), 
                    width: 2
                  ),
                  boxShadow: [
                    if (_isError)
                      const BoxShadow(color: Colors.orange, blurRadius: 40, spreadRadius: 15),
                    if (isHovered && !_isError)
                      BoxShadow(color: task.elementColor.withValues(alpha: 0.3), blurRadius: 30, spreadRadius: 10), // Reduced opacity for shadow
                  ],
                ),
                child: Center(
                  child: _isError 
                    ? const Icon(Icons.error, color: Colors.white, size: 50)
                    : Text(
                        "(${task.targetElement}: $_currentElementCount/${task.targetCount})",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
            );
          },
        );
      },
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        _onAcceptElement(details.data == task.targetElement && _currentElementCount < task.targetCount);
      },
    );
  }

  Widget _buildMolecule(ChemistryTask task) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: AnimatedBuilder(
        animation: _particlesController,
        builder: (context, child) {
          final scale = 1.0 + (_particlesController.value * 0.2);
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withValues(alpha: 
                      max(0.0, 1.0 - _particlesController.value),
                    ),
                    blurRadius: 50 * _particlesController.value,
                    spreadRadius: 20 * _particlesController.value,
                  ),
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.6),
                    blurRadius: 20,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "${task.formula}\nГотово!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
