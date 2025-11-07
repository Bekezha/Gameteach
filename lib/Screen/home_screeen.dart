import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({super.key});

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  int _selectedIndex = 0;
  String? userName; // для приветствия

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Gamer';
    });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 191, 88, 209),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                "Hello, ${userName ?? 'Gamer'} 👋",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/introduction');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 191, 88, 209),
                ),
                child: const Text(
                  'Перейти ознакомление',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/connect");
                          },
                          icon: Image.asset(
                            "assets/images/game1.jpg",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Text("Связывание"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/movement');
                          },
                          icon: Image.asset(
                            "assets/images/game2.jpg",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Text("Направление"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/quiz");
                          },
                          icon: Image.asset(
                            "assets/images/game3.jpg",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Text("Викторина"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromARGB(255, 191, 88, 209),
        selectedItemColor: const Color.fromARGB(255, 191, 88, 209),
        unselectedItemColor: const Color.fromARGB(255, 191, 88, 209),
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Главная"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Настройки",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark),
            label: "Игры",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Профиль"),
        ],
      ),
    );
  }
}
