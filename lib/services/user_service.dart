import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shakey/models/user.dart';
import 'package:shakey/services/auth_service.dart';

class UserService extends ChangeNotifier {
  static final UserService instance = UserService._internal();
  UserService._internal();

  static const String baseUrl = 'http://127.0.0.1:3333';
  User? _user;

  User? get user => _user;

  Future<User?> getProfile() async {
    final token = AuthService.instance.accessToken;
    if (token == null) {
      _user = null;
      notifyListeners();
      return null;
    }

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/user/profile'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final userData = User.fromJson(json.decode(response.body));
        _user = userData;
        notifyListeners();
        return _user;
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    final token = AuthService.instance.accessToken;
    if (token == null) return false;

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/user/edit_profile'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getProfile();
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  void clearCache() {
    _user = null;
    notifyListeners();
  }

  Future<bool> updatePoints(int points) async {
    final token = AuthService.instance.accessToken;
    if (token == null) return false;

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/user/update_point'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({'point': points}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getProfile(); // Refresh profile to get new points
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating points: $e');
      return false;
    }
  }
}
