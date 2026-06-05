import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordHidden = true;

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final success = await context.read<UserProvider>().login(email, password);

      if (!mounted) return;
      if (success) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email немесе құпиясөз қате')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Қате: $e')));
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 12),
              FadeInDown(
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 120,
                ),
              ),
              const SizedBox(height: 24),
              FadeInLeft(
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
              const SizedBox(height: 16),
              FadeInRight(
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
      ),
    );
  }
}
