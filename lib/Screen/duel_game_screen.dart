import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/duel_provider.dart';
import 'package:animate_do/animate_do.dart';

class DuelGameScreen extends StatelessWidget {
  const DuelGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DuelProvider>(
      builder: (context, duelProvider, child) {
        if (duelProvider.duelData == null) {
          return const Scaffold(body: Center(child: Text("Қате: Мәліметтер табылмады")));
        }

        final questions = duelProvider.duelData!['questions'] as List;
        final opponent = duelProvider.duelData!['opponent'];
        
        if (duelProvider.isGameOver) {
          return _buildResultScreen(context, duelProvider, opponent['name']);
        }

        final currentQuestion = questions[duelProvider.currentQuestionIndex];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Дуэль'),
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Сұрақ: ${duelProvider.currentQuestionIndex + 1}/${questions.length}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Score Bar
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildScoreColumn("Сіз", duelProvider.myScore, Colors.blue),
                    const Text("VS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    _buildScoreColumn(opponent['name'], duelProvider.opponentScore, Colors.red),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Question Area
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: FadeInRight(
                  key: ValueKey(duelProvider.currentQuestionIndex),
                  child: Text(
                    currentQuestion['q'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Options Area
              ...List.generate((currentQuestion['a'] as List).length, (index) {
                final option = currentQuestion['a'][index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        duelProvider.submitAnswer(option == currentQuestion['c']);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(option, style: const TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                );
              }),
              
              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreColumn(String name, int score, Color color) {
    return Column(
      children: [
        Text(name, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        Text("$score", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildResultScreen(BuildContext context, DuelProvider duelProvider, String opponentName) {
    final win = duelProvider.myScore > duelProvider.opponentScore;
    final draw = duelProvider.myScore == duelProvider.opponentScore;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                child: Icon(
                  win ? Icons.emoji_events : (draw ? Icons.handshake : Icons.sentiment_very_dissatisfied),
                  size: 120,
                  color: win ? Colors.amber : Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                win ? "ЖЕҢІС!" : (draw ? "ТЕҢ ОЙЫН!" : "ЖЕҢІЛІС!"),
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                "Сіз: ${duelProvider.myScore} бал\n$opponentName: ${duelProvider.opponentScore} бал",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  duelProvider.duelData = null; // Reset
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("Басты бетке"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
