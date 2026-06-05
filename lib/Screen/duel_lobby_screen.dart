import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/duel_provider.dart';
import '../providers/user_provider.dart';
import 'package:animate_do/animate_do.dart';

class DuelLobbyScreen extends StatelessWidget {
  const DuelLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final duelProvider = context.watch<DuelProvider>();
    final userProvider = context.read<UserProvider>();

    // Navigate when match is found
    if (duelProvider.duelData != null && !duelProvider.isSearching) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/duel-game');
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Поиск дуэли')),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1a2a6c), Color(0xFFb21f1f), Color(0xFFfdbb2d)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!duelProvider.isSearching) ...[
              FadeInDown(
                child: const Icon(Icons.bolt, size: 100, color: Colors.amber),
              ),
              const SizedBox(height: 30),
              FadeInUp(
                child: const Text(
                  "Дайынсың ба, батыр?",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                  "Нағыз білім шайқасы басталмақ!",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
              const SizedBox(height: 50),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: ElevatedButton(
                  onPressed: () {
                    duelProvider.startSearch(
                      userProvider.user?.name ?? 'Ойыншы',
                      userProvider.user?.email ?? 'anon'
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Қарсылас іздеу", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ] else ...[
              const CircularProgressIndicator(color: Colors.amber),
              const SizedBox(height: 30),
              FadeIn(
                child: const Text(
                  "Қарсылас ізделуде...",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: duelProvider.stopSearch,
                child: const Text("Тоқтату", style: TextStyle(color: Colors.white70)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
