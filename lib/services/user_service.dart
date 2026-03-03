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
    // Return cached user immediately if available (perceived performance)
    if (_user != null) {
      // Still fetch in background to keep data fresh
      _fetchInBackground();
      return _user;
    }

    return await _fetchProfileInternal();
  }

  Future<void> _fetchInBackground() async {
    try {
      await _fetchProfileInternal();
    } catch (e) {
      debugPrint('Background profile refresh failed: $e');
    }
  }

  Future<User?> _fetchProfileInternal() async {
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
      debugPrint('Error fetching user profile: $e');
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
      debugPrint('Error updating profile: $e');
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
      debugPrint('Error updating points: $e');
      return false;
    }
  }

  // Address Management
  Future<List<Address>> getAddresses() async {
    try {
      final response = await AuthService.instance.dio.get('/user/address');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Address.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching addresses: $e');
    }
    return [];
  }

  Future<bool> addAddress(String name, String detail) async {
    try {
      final response = await AuthService.instance.dio.post(
        '/user/address/add',
        data: {'name': name, 'detail': detail},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('Error adding address: $e');
      return false;
    }
  }

  Future<bool> updateAddress(
    String addressId,
    String name,
    String detail,
  ) async {
    try {
      final response = await AuthService.instance.dio.post(
        '/user/update_address',
        data: {'address_id': addressId, 'name': name, 'detail': detail},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('Error updating address: $e');
      return false;
    }
  }

  Future<bool> deleteAddress(String addressId) async {
    try {
      final response = await AuthService.instance.dio.post(
        '/user/address/delete',
        data: {'address_id': addressId},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('Error deleting address: $e');
      return false;
    }
  }
}
