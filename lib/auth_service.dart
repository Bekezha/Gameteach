import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = "https://gameteach-32zy.onrender.com/api/users";
  final _storage = const FlutterSecureStorage();

  Future<bool> register(String name, String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (res.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      await _storage.write(key: 'token', value: data['token']);
      await _storage.write(key: 'userName', value: data['user']['name']);
      await _storage.write(key: 'userEmail', value: data['user']['email']);
      return true;
    }
    return false;
  }

  Future<Map<String, String?>> getUserInfo() async {
    return {
      'name': await _storage.read(key: 'userName'),
      'email': await _storage.read(key: 'userEmail'),
    };
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }
}
