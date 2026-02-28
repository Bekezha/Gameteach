import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreeen extends StatefulWidget {
  const LoginScreeen({super.key});

  @override
  State<LoginScreeen> createState() => _LoginScreeenState();
}

class _LoginScreeenState extends State<LoginScreeen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveUserLocally(
    Map<String, dynamic> user,
    String? token,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', user['name'] ?? '');
    await prefs.setString('userEmail', user['email'] ?? '');
    if (token != null) await prefs.setString('token', token);
  }

  Future<void> loginUser() async {
    setState(() => _isLoading = true);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final url = Uri.parse(
      'http://localhost:5000/api/users/login',
    ); // <- поменяй если нужно

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final user = data['user'] as Map<String, dynamic>;
        final token = data['token'] as String?;
        // Сохраняем локально — чтобы profile всегда мог взять данные
        await _saveUserLocally(user, token);

        // Надёжный переход: сначала /home, затем асинхронно открываем /profile с аргументами
        Navigator.pushReplacementNamed(context, '/home');

        Future.microtask(() {
          Navigator.pushNamed(
            context,
            '/profile',
            arguments: {'name': user['name'], 'email': user['email']},
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Ошибка входа')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка сервера: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GameTeach"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            FadeInDown(
              child: Image.asset(
                "assets/images/game_intro.png",
                height: 120,
              ),
            ),
            const SizedBox(height: 24),
            FadeInLeft(
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: "Email",
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInRight(
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: "Құпиясөз",
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : loginUser,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Кіру"),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text("Тіркелуге өту"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
