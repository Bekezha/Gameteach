import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'games.dart';

class GamesBySubjectScreen extends StatelessWidget {
  const GamesBySubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> subjects = [
      {
        "title": "Математика",
        "icon": Icons.calculate_rounded,
        "color": Colors.blueAccent,
        "games": ["Цифры", "Быстрый ответ", "Сравнение"]
      },
      {
        "title": "Окружающий мир",
        "icon": Icons.public_rounded,
        "color": Colors.green,
        "games": ["Выбери правильный ответ", "Правда или ложь", "Сортировка"]
      },
      {
        "title": "Логика и внимание",
        "icon": Icons.psychology_rounded,
        "color": Colors.orangeAccent,
        "games": ["Логический ответ", "Реши загадку", "Связывание", "Что лишнее"]
      },
      {
        "title": "Чтение и грамота",
        "icon": Icons.menu_book_rounded,
        "color": Colors.purpleAccent,
        "games": ["Найди ошибку", "Составь пазл", "Собери слово"]
      },
      {
        "title": "Виртуальные игры",
        "icon": Icons.videogame_asset_rounded,
        "color": Colors.deepPurpleAccent,
        "games": ["Космическая лаб.", "Магический лес", "Ловец слов", "Машина времени"]
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8EFFF),
      appBar: AppBar(
        title: const Text("Игры по предметам", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return FadeInUp(
              delay: Duration(milliseconds: 100 * index),
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Games(
                          subjectTitle: subject['title'],
                          allowedGames: List<String>.from(subject['games']),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          subject['color'].withOpacity(0.8),
                          subject['color'],
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(subject['icon'], size: 40, color: Colors.white),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subject['title'],
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${subject['games'].length} игр(ы)",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
