import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Screen/profile/profile_model.dart';

class UserProvider extends ChangeNotifier {
  ProfileModel? _user;
  String? _token;

  ProfileModel? get user => _user;
  bool get isAuthenticated => _token != null;

  final _storage = const FlutterSecureStorage();
  String get baseUrl => 'https://gameteach-32zy.onrender.com/api/users';

  Future<void> init() async {
    _token = await _storage.read(key: 'jwt_token');
    if (_token != null) {
      // Fire and forget — не блокируем запуск приложения ожиданием сервера
      fetchProfile();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _user = ProfileModel.fromJson(data['user']);
        
        await _storage.write(key: 'jwt_token', value: _token);
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("Login error: $e");
    }
    return false;
  }

  /// Возвращает null при успехе, или сообщение ошибки при неудаче
  Future<String?> register(String name, String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password, 'role': role}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        return null; // успех
      }
      // Возвращаем реальную ошибку сервера
      try {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Қате: ${response.statusCode}';
      } catch (_) {
        return 'Қате: ${response.statusCode}';
      }
    } catch (e) {
      debugPrint("Register error: $e");
      if (e.toString().contains('TimeoutException')) {
        return 'Сервер жауап бермейді (timeout). Қайталап көріңіз.';
      }
      return 'Желі қатесі: $e';
    }
  }

  Future<void> fetchProfile() async {
    if (_token == null) return;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: {'Authorization': 'Bearer $_token'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _user = ProfileModel.fromJson(data);
        notifyListeners();
      } else {
        await logout(); // Token expired or invalid
      }
    } catch (e) {
      debugPrint("Fetch profile error: $e");
    }
  }

  Future<void> updateStats({int answeredQuestions = 0, int gamesPlayed = 0}) async {
    if (_token == null) return;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update-stats'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'answeredQuestions': answeredQuestions,
          'gamesPlayed': gamesPlayed,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _user = ProfileModel.fromJson(data);
        notifyListeners(); // Updates UI
      }
    } catch (e) {
      debugPrint("Update stats error: $e");
    }
  }

  Future<List<ProfileModel>> getLeaderboard() async {
    if (_token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/leaderboard?limit=10'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ProfileModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Leaderboard error: $e");
    }
    return [];
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    _token = null;
    _user = null;
    notifyListeners();
  }
}
