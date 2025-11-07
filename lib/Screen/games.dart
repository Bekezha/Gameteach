import 'package:flutter/material.dart';

class Games extends StatefulWidget {
  const Games({super.key});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  // Барлық ойындардың тізімі
  final List<Map<String, String>> games = [
    {"title": "Цифры", "image": "assets/images/play1.jpg"},
    {"title": "Выбери правильный ответ", "image": "assets/images/play2.jpg"},
    {"title": "Быстрый ответ", "image": "assets/images/play3.jpg"},
    {"title": "Связывание", "image": "assets/images/play4.jpg"},
    {"title": "Логический ответ", "image": "assets/images/play5.jpg"},
    {"title": "Правда или ложь", "image": "assets/images/play6.jpg"},
    {"title": "Реши загадку", "image": "assets/images/play7.jpg"},
    {"title": "Найди ошибку", "image": "assets/images/play8.jpg"},
    {"title": "Составь пазл", "image": "assets/images/play9.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EFFF),
      appBar: AppBar(
        title: const Text(
          "GameTeach",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 191, 88, 209),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: games.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // екі баған
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9, // пропорциясы
          ),
          itemBuilder: (context, index) {
            final game = games[index];
            return GestureDetector(
              onTap: () {
                // Мұнда әр ойынға жеке маршрут беруге болады
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Ойын: ${game['title']}")),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        game['image']!,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      game['title']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6C3483),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
