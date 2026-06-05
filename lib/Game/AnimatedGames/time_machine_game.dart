import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class TimeItem {
  final int id;
  final String label;
  final IconData icon;
  final String era; // 'Ancient' or 'Modern'
  double topPosition;
  double leftPosition;
  bool isCaught;

  TimeItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.era,
    required this.topPosition,
    required this.leftPosition,
    this.isCaught = false,
  });
}

class TimeMachineGame extends StatefulWidget {
  const TimeMachineGame({super.key});

  @override
  State<TimeMachineGame> createState() => _TimeMachineGameState();
}

class _TimeMachineGameState extends State<TimeMachineGame> {
  int? _selectedLevel;
  int _score = 0;
  final List<TimeItem> _items = [];
  Timer? _gameTimer;
  Timer? _spawnTimer;
  int _idCounter = 0;
  int _countSpawned = 0;
  bool _isLevelComplete = false;

  final Map<int, List<Map<String, dynamic>>> _levelPools = {
    1: [
      {'label': 'Шлем', 'icon': Icons.security, 'era': 'Ancient', 'category': 'Тұлға'},
      {'label': 'Свиток', 'icon': Icons.menu_book, 'era': 'Ancient', 'category': 'Құжат'},
      {'label': 'Құмыра', 'icon': Icons.wine_bar, 'era': 'Ancient', 'category': 'Ыдыс'},
      {'label': 'Семсер', 'icon': Icons.colorize, 'era': 'Ancient', 'category': 'Қару'},
      {'label': 'Сандал', 'icon': Icons.beach_access, 'era': 'Ancient', 'category': 'Киім'},
      {'label': 'Тиын', 'icon': Icons.monetization_on, 'era': 'Ancient', 'category': 'Ақша'},
      {'label': 'Пирамида', 'icon': Icons.architecture, 'era': 'Ancient', 'category': 'Құрылыс'},
      {'label': 'Колесница', 'icon': Icons.minor_crash, 'era': 'Ancient', 'category': 'Көлік'},
    ],
    2: [
      {'label': 'Смартфон', 'icon': Icons.smartphone, 'era': 'Modern', 'category': 'Техника'},
      {'label': 'Ноутбук', 'icon': Icons.laptop, 'era': 'Modern', 'category': 'Техника'},
      {'label': 'Дрон', 'icon': Icons.airplanemode_active, 'era': 'Modern', 'category': 'Техника'},
      {'label': 'Кофемашина', 'icon': Icons.coffee_maker, 'era': 'Modern', 'category': 'Тұрмыс'},
      {'label': 'Құлаққап', 'icon': Icons.headphones, 'era': 'Modern', 'category': 'Техника'},
      {'label': 'Самокат', 'icon': Icons.electric_scooter, 'era': 'Modern', 'category': 'Көлік'},
      {'label': 'Интернет', 'icon': Icons.language, 'era': 'Modern', 'category': 'Желі'},
      {'label': 'Робот', 'icon': Icons.smart_toy, 'era': 'Modern', 'category': 'ИИ'},
    ],
    3: [
      {'label': 'Мөр', 'icon': Icons.architecture, 'era': 'Ancient', 'category': 'Құжат'},
      {'label': 'Ат арба', 'icon': Icons.minor_crash, 'era': 'Ancient', 'category': 'Көлік'},
      {'label': 'Папирус', 'icon': Icons.article, 'era': 'Ancient', 'category': 'Жазу'},
      {'label': 'Зымыран', 'icon': Icons.rocket_launch, 'era': 'Modern', 'category': 'Ғарыш'},
      {'label': 'Спутник', 'icon': Icons.settings_input_antenna, 'era': 'Modern', 'category': 'Байланыс'},
      {'label': 'Электромобиль', 'icon': Icons.electric_car, 'era': 'Modern', 'category': 'Көлік'},
    ],
    4: [
      {'label': 'Ғибадатхана', 'icon': Icons.temple_hindu, 'era': 'Ancient', 'category': 'Құрылыс'},
      {'label': 'Амфора', 'icon': Icons.liquor, 'era': 'Ancient', 'category': 'Ыдыс'},
      {'label': 'Қалқан', 'icon': Icons.shield, 'era': 'Ancient', 'category': 'Қорғаныс'},
      {'label': 'Микроскоп', 'icon': Icons.biotech, 'era': 'Modern', 'category': 'Ғылым'},
      {'label': 'Телескоп', 'icon': Icons.visibility, 'era': 'Modern', 'category': 'Ғылым'},
      {'label': 'VR-көзілдірік', 'icon': Icons.view_in_ar, 'era': 'Modern', 'category': 'Ойын'},
    ],
    5: [
      {'label': 'Балта', 'icon': Icons.handyman, 'era': 'Ancient', 'category': 'Құрал'},
      {'label': 'Найза', 'icon': Icons.architecture, 'era': 'Ancient', 'category': 'Қару'},
      {'label': 'От', 'icon': Icons.local_fire_department, 'era': 'Ancient', 'category': 'Табиғат'},
      {'label': 'AI', 'icon': Icons.psychology, 'era': 'Modern', 'category': 'Болашақ'},
      {'label': 'Чип', 'icon': Icons.memory, 'era': 'Modern', 'category': 'Микро'},
      {'label': 'Есептеуіш', 'icon': Icons.computer, 'era': 'Modern', 'category': 'Тарих'},
    ],
  };

  @override
  void initState() {
    super.initState();
  }

  void _startGame(int level) {
    _idCounter = 0;
    _countSpawned = 0;
    _score = 0;
    _isLevelComplete = false;
    _items.clear();

    double speed = 2.0 + (level * 0.5);
    int spawnRateMs = max(1000, 2500 - (level * 300));

    _gameTimer?.cancel();
    _spawnTimer?.cancel();

    // Timer to drop items
    _gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        for (var item in _items) {
          if (!item.isCaught) {
            item.topPosition += speed;
          }
        }
        // Remove items that fell off the screen
        _items.removeWhere(
          (item) => item.topPosition > MediaQuery.of(context).size.height,
        );
      });
    });

    // Timer to spawn new items
    _spawnTimer = Timer.periodic(Duration(milliseconds: spawnRateMs), (timer) {
      if (_countSpawned >= 10) {
        // 10 items per level
        timer.cancel();
        return;
      }

      final pool = _levelPools[_selectedLevel]!;
      final data = pool[_countSpawned % pool.length];
      final leftPos =
          50.0 +
          ((_idCounter * 71) % (MediaQuery.of(context).size.width - 150));

      setState(() {
        _items.add(
          TimeItem(
            id: _idCounter++,
            label: "${data['category']}: ${data['label']}",
            icon: data['icon'],
            era: data['era'],
            topPosition: -80,
            leftPosition: leftPos,
          ),
        );
        _countSpawned++;
      });
    });
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    super.dispose();
  }

  void _onAccept(String era, TimeItem item) {
    setState(() {
      item.isCaught = true;
      if (item.era == era) {
        _score += 10;
      } else {
        _score -= 5;
      }
      _items.removeWhere((element) => element.id == item.id);

      if (_countSpawned >= 10 && _items.isEmpty && !_isLevelComplete) {
        _isLevelComplete = true;
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    context.read<UserProvider>().updateStats(answeredQuestions: max(0, _score ~/ 10), gamesPlayed: 1);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Дәуір аяқталды!"),
        content: Text("Сіздің жинаған ұпайыңыз: $_score ($_selectedLevel деңгей)"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _selectedLevel = null;
                _score = 0;
              });
            },
            child: const Text("Деңгей таңдау"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
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
        title: const Text(
          "Машина времени",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Счет: $_score",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF355C7D), Color(0xFF6C5B7B), Color(0xFFC06C84)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _selectedLevel == null
            ? _buildLevelSelection()
            : Stack(
                children: [
                  // Portals
                  Positioned(
                    left: 20,
                    bottom: 50,
                    child: _buildPortal('Ancient', 'Ежелгі', Colors.amber),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 50,
                    child: _buildPortal('Modern', 'Қазіргі', Colors.cyan),
                  ),

                  // Falling Items
                  ..._items.map((item) {
                    return Positioned(
                      top: item.topPosition,
                      left: item.leftPosition,
                      child: Draggable<TimeItem>(
                        data: item,
                        childWhenDragging: const SizedBox.shrink(),
                        feedback: _buildItemWidget(item),
                        child: _buildItemWidget(item),
                      ),
                    );
                  }),
                ],
              ),
      ),
    );
  }

  Widget _buildLevelSelection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Выберите уровень времени",
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
                    });
                    _startGame(level);
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

  Widget _buildPortal(String era, String label, Color color) {
    return DragTarget<TimeItem>(
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isHovered ? 140 : 120,
          height: isHovered ? 140 : 120,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: isHovered ? Colors.white : color,
              width: isHovered ? 4 : 2,
            ),
            boxShadow: [
              if (isHovered)
                BoxShadow(color: color, blurRadius: 20, spreadRadius: 5),
            ],
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        _onAccept(era, details.data);
      },
    );
  }

  Widget _buildItemWidget(TimeItem item) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, size: 30, color: Colors.indigo),
          const SizedBox(height: 5),
          Text(
            item.label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
