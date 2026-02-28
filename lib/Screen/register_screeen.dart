import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreeen extends StatefulWidget {
  const RegisterScreeen({super.key});

  @override
  State<RegisterScreeen> createState() => _RegisterScreeenState();
}

class _RegisterScreeenState extends State<RegisterScreeen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmpaswordController = TextEditingController();
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

  Future<void> registerUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();
    final confirm = confirmpaswordController.text.trim();

    if (password != confirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Парольдер сәйкес емес")));
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse('http://localhost:5000/api/users/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Если сервер вернул user, используем его; если вернул token — сохраняем тоже
        final user =
            data['user'] as Map<String, dynamic>? ??
            {'name': name, 'email': email};
        final token = data['token'] as String?;
        await _saveUserLocally(user, token);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Тіркелу сәтті ✅")));

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Қате тіркелу')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Серверге қосылу сәтсіз: $e')));
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              FadeInDown(
                child: Image.asset(
                  "assets/images/game_intro.png",
                  height: 100,
                ),
              ),
              const SizedBox(height: 24),
              FadeInLeft(
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: "Аты-жөні",
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FadeInRight(
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: "Email",
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FadeInLeft(
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: "Құпиясөз",
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FadeInRight(
                child: TextField(
                  controller: confirmpaswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock_outline),
                    labelText: "Құпиясөзді растау",
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                child: SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: registerUser,
                          child: const Text("Тіркелу"),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text("Кіруге өту"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
