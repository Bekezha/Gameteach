import 'dart:convert';
import 'package:flutter/material.dart';
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
        Future.microtask(() {
          Navigator.pushNamed(
            context,
            '/profile',
            arguments: {'name': user['name'], 'email': user['email']},
          );
        });
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
        backgroundColor: const Color.fromARGB(255, 191, 88, 209),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  labelText: "Аты-жөні",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  labelText: "Құпиясөз",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmpaswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                  labelText: "Құпиясөзді растау",
                ),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          191,
                          88,
                          209,
                        ),
                      ),
                      child: const Text("Тіркелу"),
                    ),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                child: const Text("Кіруге өту"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
