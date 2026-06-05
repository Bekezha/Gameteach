import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class GameProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  String get baseUrl => 'https://gameteach-32zy.onrender.com/api/games';

  Future<bool> createGame(String title, List<Map<String, dynamic>> questions) async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'title': title,
          'questions': questions,
        }),
      );

      if (response.statusCode == 201) {
        notifyListeners(); // Refresh games if necessary
        return true;
      } else {
        debugPrint("Error creating game: ${response.body}");
      }
    } catch (e) {
      debugPrint("Create game error: $e");
    }
    return false;
  }

  Future<List<dynamic>> fetchGames() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint("Fetch games error: $e");
    }
    return [];
  }

  Future<List<dynamic>> fetchMyGames() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/my-games'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint("Error fetching my games: ${response.body}");
      }
    } catch (e) {
      debugPrint("Fetch my games error: $e");
    }
    return [];
  }
}
