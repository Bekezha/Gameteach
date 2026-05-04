import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_model.dart';

class ProfileService {
  static const String baseUrl = 'http://192.168.1.106:5000';

  Future<ProfileModel?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      try {
        final response = await http
            .get(
              Uri.parse('$baseUrl/api/users/me'),
              headers: {'Authorization': 'Bearer $token'},
            )
            .timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final profile = ProfileModel.fromJson(data);

          await prefs.setString('userName', profile.name);
          await prefs.setString('userEmail', profile.email);

          return profile;
        }
      } catch (e) {
        print("Error fetching profile from server: $e");
      }
    }

    final storedName = prefs.getString('userName');
    final storedEmail = prefs.getString('userEmail');

    if (storedName != null && storedName.isNotEmpty) {
      return ProfileModel(name: storedName, email: storedEmail ?? '');
    }

    return null;
  }

  Future<void> updateUserStats(int questions, int games) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      try {
        await http.post(
          Uri.parse('$baseUrl/api/users/update-stats'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'answeredQuestions': questions,
            'gamesPlayed': games,
          }),
        );
      } catch (e) {
        print("Error updating stats: $e");
      }
    }
  }

  Future<List<ProfileModel>> getLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/api/users/leaderboard'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          return data.map((json) => ProfileModel.fromJson(json)).toList();
        }
      } catch (e) {
        print("Error fetching leaderboard: $e");
      }
    }
    return [];
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
