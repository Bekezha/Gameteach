import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> pairs = [
    {"left": "int", "right": "бүтін сан"},
    {"left": "str", "right": "мәтін"},
    {"left": "bool", "right": "ақиқат/жалған"},
  ];

  Map<String, String?> selectedMatches = {};
  int currentIndex = 0;
  int score = 0;

  // Позицияларды алу үшін GlobalKey
  final List<GlobalKey> leftKeys = [];
  final List<GlobalKey> rightKeys = [];

  List<OffsetPair> lines = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < pairs.length; i++) {
      leftKeys.add(GlobalKey());
      rightKeys.add(GlobalKey());
    }
  }

  void checkAnswer(String left, String? right, int index) {
    if (right == null) return;

    final correct = pairs[index]["right"];
    if (right == correct) {
      score++;
      drawLine(index);
      Future.delayed(const Duration(seconds: 1), () {
        if (currentIndex < pairs.length - 1) {
          setState(() {
            currentIndex++;
          });
        } else {
          context.read<UserProvider>().updateStats(answeredQuestions: score, gamesPlayed: 1);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Ойын аяқталды! Ұпай: $score / ${pairs.length}"),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Қате сәйкестендіру! Қайта байқап көр."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void drawLine(int index) {
    final leftBox =
        leftKeys[index].currentContext?.findRenderObject() as RenderBox?;
    final rightBox =
        rightKeys[index].currentContext?.findRenderObject() as RenderBox?;

    if (leftBox != null && rightBox != null) {
      final leftPosition = leftBox.localToGlobal(
        leftBox.size.center(Offset.zero),
      );
      final rightPosition = rightBox.localToGlobal(
        rightBox.size.center(Offset.zero),
      );

      setState(() {
        lines.add(OffsetPair(leftPosition, rightPosition));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GameTeach"),
        backgroundColor: const Color.fromARGB(255, 191, 88, 209),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Сызықтарды сызу
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: LinePainter(lines),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Python типтерін сәйкестендір",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Сол жақ элементтер
                          Expanded(
                            child: ListView.builder(
                              itemCount: currentIndex + 1,
                              itemBuilder: (context, index) {
                                final left = pairs[index]["left"]!;
                                return Card(
                                  key: leftKeys[index],
                                  color: Colors.deepPurple.shade100,
                                  child: ListTile(
                                    title: Text(
                                      left,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Оң жақтағы таңдау тізімі
                          Expanded(
                            child: ListView.builder(
                              itemCount: currentIndex + 1,
                              itemBuilder: (context, index) {
                                final left = pairs[index]["left"]!;
                                return Card(
                                  key: rightKeys[index],
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: const Text("Таңдау..."),
                                    value: selectedMatches[left],
                                    items: pairs
                                        .map(
                                          (pair) => DropdownMenuItem<String>(
                                            value: pair["right"],
                                            child: Text(pair["right"]!),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedMatches[left] = value;
                                      });
                                      checkAnswer(left, value, index);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Ұпай: $score",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Сызықтар үшін деректер типі
class OffsetPair extends Offset {
  final Offset start;
  final Offset end;

  OffsetPair(this.start, this.end) : super(start.dx, start.dy);
}

// Сызық сызатын CustomPainter
class LinePainter extends CustomPainter {
  final List<OffsetPair> lines;
  LinePainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final line in lines) {
      canvas.drawLine(line.start, line.end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
