import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? email;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    // 1) Попробуем аргументы
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['name'] != null && args['email'] != null) {
      setState(() {
        name = args['name'];
        email = args['email'];
        loading = false;
      });
      return;
    }

    // 2) Если аргументы отсутствуют, берем из SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('userName');
    final storedEmail = prefs.getString('userEmail');
    final token = prefs.getString('token');

    if (storedName != null && storedName.isNotEmpty) {
      setState(() {
        name = storedName;
        email = storedEmail;
        loading = false;
      });
      // дальше можно обновить данные с сервера, если есть токен
    } else if (token != null && token.isNotEmpty) {
      // 3) Если нет локально, но есть токен — запросим /api/users/me
      try {
        final url = Uri.parse('http://10.0.2.2:5000/api/users/me');
        final res = await http.get(
          url,
          headers: {'Authorization': 'Bearer $token'},
        );
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          setState(() {
            name = data['name'] ?? data['user']?['name'];
            email = data['email'] ?? data['user']?['email'];
            loading = false;
          });
        } else {
          setState(() {
            loading = false;
          });
        }
      } catch (_) {
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: const Color.fromARGB(255, 191, 88, 209),
      ),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : (name == null
                  ? const Text('Ошибка: нет данных пользователя')
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 36,
                          child: Icon(Icons.person, size: 36),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          name!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(email ?? '', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _logout,
                          child: const Text('Шығу'),
                        ),
                      ],
                    )),
      ),
    );
  }
}
