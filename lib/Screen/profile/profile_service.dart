import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_model.dart';

class ProfileService {
  static const String baseUrl = 'http://10.0.2.2:5000';

  Future<ProfileModel?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final storedName = prefs.getString('userName');
    final storedEmail = prefs.getString('userEmail');
    final token = prefs.getString('token');

    // 1️⃣ Егер локально сақталған болса
    if (storedName != null && storedName.isNotEmpty) {
      return ProfileModel(name: storedName, email: storedEmail ?? '');
    }

    // 2️⃣ Егер токен бар болса — серверден аламыз
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

          // Кэшке сақтау
          await prefs.setString('userName', profile.name);
          await prefs.setString('userEmail', profile.email);

          return profile;
        }
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
