import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _selectedLanguage = 'Қазақша';
  bool _isDarkMode = false;

  final List<String> _languages = ['Қазақша', 'Русский', 'English'];

  @override
  void initState() {
    super.initState();
    _loadSettings(); // баптауларды жүктеу
  }

  // SharedPreferences-тен мәндерді оқу
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'Қазақша';
      _isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  // SharedPreferences-ке сақтау
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _selectedLanguage);
    await prefs.setBool('darkMode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
              appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 70, 23, 97),
              ),
            )
          : ThemeData.light().copyWith(
              appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 191, 88, 209),
              ),
            ),
      home: Scaffold(
        appBar: AppBar(title: const Text("Баптаулар"), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "🌐 Тіл баптаулары",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Тілді таңдаңыз",
                ),
                value: _selectedLanguage,
                items: _languages.map((lang) {
                  return DropdownMenuItem<String>(
                    value: lang,
                    child: Text(lang),
                  );
                }).toList(),
                onChanged: (value) async {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  await _saveSettings();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Тіл "${value}" таңдалды!'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              const Text(
                "💡 Режим",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: const Text("Қараңғы режим"),
                value: _isDarkMode,
                onChanged: (value) async {
                  setState(() {
                    _isDarkMode = value;
                  });
                  await _saveSettings();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value
                            ? "Қараңғы режим қосылды 🌙"
                            : "Жарық режим орнатылды ☀️",
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
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
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Артқа қайту",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
