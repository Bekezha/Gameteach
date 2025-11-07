import 'package:flutter/material.dart';

class Introduction extends StatelessWidget {
  const Introduction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EFFF),
      appBar: AppBar(
        title: const Text(
          "GameTeach",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: const Color.fromARGB(255, 191, 88, 209),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Логотип немесе иллюстрация
            Center(
              child: Image.asset(
                "assets/images/game_intro.png", // өз суретіңнің жолын жаз
                height: 200,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Қош келдіңіз GameTeach қосымшасына!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 103, 32, 128),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Бұл қосымша ойын арқылы білім мен логиканы дамытатын интерактивті орта болып табылады. "
              "Мұнда түрлі интеллектуалды ойындар, тапсырмалар мен викториналар арқылы өз ой-өрісіңді кеңейтіп, "
              "жылдам ойлау қабілетіңді арттыра аласың.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 25),

            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 191, 88, 209),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: const Text(
                "🎯 GameTeach мақсаты:\n\n"
                "• Балалардың логикалық ойлау қабілетін дамыту\n"
                "• Қызықты ойындар арқылы үйренуге ынталандыру\n"
                "• Математика, есте сақтау және зейінге арналған жаттығулар ұсыну",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "🔮 Алда не күтіп тұр?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 127, 63, 152),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "• Интеллектуалды мини-ойындар\n"
              "• Викториналар мен логикалық сұрақтар\n"
              "• Өзіңнің жетістіктеріңді бақылау мүмкіндігі",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.6),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 191, 88, 209),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // артқа оралу (мысалы, /home)
              },
              child: const Text(
                "Артқа қайту",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
