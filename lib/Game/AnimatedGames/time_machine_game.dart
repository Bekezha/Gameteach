import 'package:flutter/material.dart';
import 'dart:async';

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
  const TimeMachineGame({Key? key}) : super(key: key);

  @override
  State<TimeMachineGame> createState() => _TimeMachineGameState();
}

class _TimeMachineGameState extends State<TimeMachineGame> {
  int _score = 0;
  List<TimeItem> _items = [];
  Timer? _gameTimer;
  Timer? _spawnTimer;
  
  final List<Map<String, dynamic>> _itemPool = [
    {'label': 'Шлем', 'icon': Icons.security, 'era': 'Ancient'},
    {'label': 'Свиток', 'icon': Icons.menu_book, 'era': 'Ancient'},
    {'label': 'Смартфон', 'icon': Icons.smartphone, 'era': 'Modern'},
    {'label': 'Автомобиль', 'icon': Icons.directions_car, 'era': 'Modern'},
    {'label': 'Ноутбук', 'icon': Icons.laptop, 'era': 'Modern'},
    {'label': 'Меч', 'icon': Icons.colorize, 'era': 'Ancient'},
  ];

  int _idCounter = 0;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    double speed = 2.0;

    // Timer to drop items
    _gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        for (var item in _items) {
          if (!item.isCaught) {
            item.topPosition += speed;
          }
        }
        // Remove items that fell off the screen
        _items.removeWhere((item) => item.topPosition > MediaQuery.of(context).size.height);
      });
    });

    // Timer to spawn new items
    _spawnTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final randIndex = (_idCounter * 7) % _itemPool.length;
      final data = _itemPool[randIndex];
      // Random X position (roughly in middle)
      final leftPos = 100.0 + ((_idCounter * 43) % 150);
      
      setState(() {
         _items.add(TimeItem(
           id: _idCounter++,
           label: data['label'],
           icon: data['icon'],
           era: data['era'],
           topPosition: -80,
           leftPosition: leftPos,
         ));
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
        _score += 10; // Correct
      } else {
        _score -= 5; // Incorrect
      }
      _items.removeWhere((element) => element.id == item.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Машина времени", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
           Center(
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: Text(
                 "Счет: $_score", 
                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amberAccent)
               ),
             ),
           )
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
        child: Stack(
          children: [
            // Portals
            Positioned(
              left: 20,
              bottom: 50,
              child: _buildPortal('Ancient', 'Древность', Colors.amber),
            ),
            Positioned(
              right: 20,
              bottom: 50,
              child: _buildPortal('Modern', 'Наши дни', Colors.cyan),
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
            }).toList(),
          ],
        ),
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
            color: color.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: isHovered ? Colors.white : color, width: isHovered ? 4 : 2),
            boxShadow: [
              if (isHovered)
                BoxShadow(color: color, blurRadius: 20, spreadRadius: 5)
            ]
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        _onAccept(era, data);
      },
    );
  }

  Widget _buildItemWidget(TimeItem item) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, size: 30, color: Colors.indigo),
          const SizedBox(height: 5),
          Text(item.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
