import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'package:animate_do/animate_do.dart';
import 'play_custom_game_screen.dart';

class MyGamesScreen extends StatefulWidget {
  const MyGamesScreen({super.key});

  @override
  State<MyGamesScreen> createState() => _MyGamesScreenState();
}

class _MyGamesScreenState extends State<MyGamesScreen> {
  late Future<List<dynamic>> _myGamesFuture;

  @override
  void initState() {
    super.initState();
    _myGamesFuture = context.read<GameProvider>().fetchMyGames();
  }

  void _refreshGames() {
    setState(() {
      _myGamesFuture = context.read<GameProvider>().fetchMyGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Менің ойындарым'),
        actions: [
          IconButton(
            onPressed: _refreshGames,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _myGamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Қате: ${snapshot.error}"));
          }

          final games = snapshot.data ?? [];

          if (games.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.games_outlined, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "Сіз әлі ойын жасаған жоқсыз",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/create-game').then((_) => _refreshGames());
                    },
                    child: const Text("Ойын жасау"),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return FadeInUp(
                delay: Duration(milliseconds: index * 50),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.quiz, color: Colors.black),
                    ),
                    title: Text(
                      game['title'] ?? 'Атаусыз ойын',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text("${game['questions']?.length ?? 0} сұрақ"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayCustomGameScreen(game: game),
                        ),
                      ).then((_) => _refreshGames());
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.pushNamed(context, '/create-game').then((_) => _refreshGames());
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
