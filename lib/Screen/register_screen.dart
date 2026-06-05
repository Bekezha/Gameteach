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
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmpaswordController = TextEditingController();
  bool _isLoading = false;
  String _selectedRole = 'student';
  bool _isPasswordHidden = true;
  bool _isConfirmHidden = true;

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    
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
      final error = await context.read<UserProvider>().register(name, email, password, _selectedRole);

      if (!mounted) return;
      if (error == null) {
        // Регистрация успешна — сразу входим
        final loginSuccess = await context.read<UserProvider>().login(email, password);

        if (!mounted) return;
        if (loginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Тіркелу сәтті ✅")));
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Тіркелді, бірақ кіру мүмкін болмады. Қолмен кіріңіз.')),
          );
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        // Показываем реальную ошибку от сервера
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 5),
          ),
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 12),
                FadeInDown(
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 100,
                  ),
                ),
                const SizedBox(height: 24),
                FadeInLeft(
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: "Аты-жөні",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Аты-жөніңізді енгізіңіз';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                FadeInRight(
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: "Email",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email енгізіңіз';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Нақты email енгізіңіз';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                FadeInLeft(
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: _isPasswordHidden,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      labelText: "Құпиясөз",
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordHidden ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Құпиясөз енгізіңіз';
                      if (value.length < 6) return 'Кемінде 6 таңба';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                FadeInRight(
                  child: TextFormField(
                    controller: confirmpaswordController,
                    obscureText: _isConfirmHidden,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock_outline),
                      labelText: "Құпиясөзді растау",
                      suffixIcon: IconButton(
                        icon: Icon(_isConfirmHidden ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isConfirmHidden = !_isConfirmHidden;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Құпиясөзді растаңыз';
                      if (value != passwordController.text) return 'Құпиясөздер сәйкес емес';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                FadeInLeft(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedRole,
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
      ),
    );
  }
}
