import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class Introduction extends StatelessWidget {
  const Introduction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EFFF),
      appBar: AppBar(
        title: const Text("GameTeach"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Логотип немесе иллюстрация
            FadeInDown(
              child: Center(
                child: Image.asset(
                  "assets/images/game_intro.png", // өз суретіңнің жолын жаз
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 30),

            FadeInLeft(
              child: Text(
                "Қош келдіңіз GameTeach қосымшасына!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),

            const SizedBox(height: 20),

            FadeInRight(
              child: Text(
                "Бұл қосымша ойын арқылы білім мен логиканы дамытатын интерактивті орта болып табылады. "
                "Мұнда түрлі интеллектуалды ойындар, тапсырмалар мен викториналар арқылы өз ой-өрісіңді кеңейтіп, "
                "жылдам ойлау қабілетіңді арттыра аласың.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
            ),

            const SizedBox(height: 25),

            FadeInUp(
              child: Card(
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "🎯 GameTeach мақсаты:\n\n"
                    "• Балалардың логикалық ойлау қабілетін дамыту\n"
                    "• Қызықты ойындар арқылы үйренуге ынталандыру\n"
                    "• Математика, есте сақтау және зейінге арналған жаттығулар ұсыну",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          height: 1.5,
                        ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  Text(
                    "🔮 Алда не күтіп тұр?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "• Интеллектуалды мини-ойындар\n"
                    "• Викториналар мен логикалық сұрақтар\n"
                    "• Өзіңнің жетістіктеріңді бақылау мүмкіндігі",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // артқа оралу (мысалы, /home)
                  },
                  child: const Text("Артқа қайту"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
