import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmpaswordController = TextEditingController();
  bool _isLoading = false;
  String _selectedRole = 'student';

  Future<void> registerUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();
    final confirm = confirmpaswordController.text.trim();

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Құпиясөздер сәйкес емес")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await context.read<UserProvider>().register(name, email, password, _selectedRole);

      if (success && mounted) {
        final loginSuccess = await context.read<UserProvider>().login(email, password);

        if (loginSuccess && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Тіркелу сәтті ✅")));
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Қате тіркелу')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Серверге қосылу сәтсіз: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
              const SizedBox(height: 12),
              FadeInLeft(
                child: DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.school),
                    labelText: "Рөл",
                  ),
                  items: const [
                    DropdownMenuItem(value: 'student', child: Text("Оқушы")),
                    DropdownMenuItem(value: 'teacher', child: Text("Мұғалім")),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedRole = val);
                  },
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
