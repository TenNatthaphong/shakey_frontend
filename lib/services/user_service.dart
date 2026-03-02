import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shakey/models/user.dart';
import 'package:shakey/services/auth_service.dart';

class UserService extends ChangeNotifier {
  static final UserService instance = UserService._internal();
  UserService._internal();

  User? _user;

  User? get user => _user;

  Future<User?> getProfile() async {
    try {
      final response = await AuthService.instance.dio.get('/user/profile');

      if (response.statusCode == 200) {
        final userData = User.fromJson(response.data);
        _user = userData;
        notifyListeners();
        return _user;
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      if (e is DioException && e.response?.statusCode == 401) {
        _user = null;
        notifyListeners();
      }
      return null;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await AuthService.instance.dio.post(
        '/user/edit_profile',
        data: data,
      );

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
    try {
      final response = await AuthService.instance.dio.post(
        '/user/update_point',
        data: {'point': points},
      );

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
