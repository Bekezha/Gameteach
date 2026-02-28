import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../app_settings.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text("Баптаулар")),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInLeft(
                child: Text(
                  "🌐 Тіл баптаулары",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 10),
              FadeInRight(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
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
              ),
              const SizedBox(height: 30),
              FadeInLeft(
                child: Text(
                  "💡 Режим",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              FadeInRight(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Қараңғы режим"),
                  value: _isDarkMode,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) async {
                    setState(() {
                      _isDarkMode = value;
                    });
                    await _saveSettings();
                    // Optional: update provider settings to reflect immediately
                    Provider.of<AppSettings>(context, listen: false).toggleTheme(value);
                    
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
              ),
              const SizedBox(height: 40),
              FadeInUp(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
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
