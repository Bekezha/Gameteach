import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushNamed(context, '/settings');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/games');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/profile'); // данные берутся в профиле
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final userName = userProvider.user?.name ?? 'Ойыншы';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Басты бет'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeInDown(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Сәлем, $userName 👋",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/introduction');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Text('Қосымшамен танысу'),
                      ),
                      if (userProvider.user?.role == 'teacher') ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/create-game');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('Ойын жасау', textAlign: TextAlign.center),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/my-games');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white24,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  side: const BorderSide(color: Colors.white54),
                                ),
                                child: const Text('Менің ойындарым', textAlign: TextAlign.center),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeInUp(
                child: Text(
                  "Ойындар",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: _buildGameCard(
                        context,
                        "Байланыс",
                        "assets/images/game1.jpg",
                        "/connect",
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: _buildGameCard(
                        context,
                        "Бағыт",
                        "assets/images/game2.jpg",
                        "/movement",
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: _buildGameCard(
                        context,
                        "Викторина",
                        "assets/images/game3.jpg",
                        "/quiz",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: _buildBigActionCard(
                  context,
                  "Дуэль (Real-time)",
                  "Соперникпен білім сынасу",
                  Icons.bolt,
                  Colors.orangeAccent,
                  '/duel-lobby',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Басты бет"),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: "Баптаулар"),
          BottomNavigationBarItem(icon: Icon(Icons.games_rounded), label: "Ойындар"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Профиль"),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String title, String imagePath, String route) {
    // ... code for _buildGameCard
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        // ... grid item ui
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(imagePath, height: 60, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
              Text(
                title, 
                textAlign: TextAlign.center, 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBigActionCard(BuildContext context, String title, String subtitle, IconData icon, Color color, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }
}
