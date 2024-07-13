import 'dart:convert';

import 'package:cmru_application/config/app.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<bool> checkLogin() async {
    final prefs = await _prefs;
    final token = prefs.getString('token');
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    final Response response = await post(
      Uri.parse('$API_URL/api/auth/login'),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final prefs = await _prefs;
      await prefs.setString('token', jsonDecode(response.body)['token']);
      return true;
    }
    return false;
  }
}
