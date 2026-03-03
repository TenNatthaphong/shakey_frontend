import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shakey/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService instance = AuthService._internal();
  SharedPreferences? _prefs;
  late final Dio _dio;

  Dio get dio => _dio;

  AuthService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        headers: {"Content-Type": "application/json"},
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = accessToken;
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final rt = refreshToken;
            if (rt != null) {
              try {
                // Try to refresh token
                final refreshResponse = await Dio().post(
                  "${AppConfig.baseUrl}/auth/refresh",
                  options: Options(headers: {"Authorization": "Bearer $rt"}),
                );

                final newAt = refreshResponse.data["access_token"];
                final newRt = refreshResponse.data["refresh_token"];

                if (newAt is String) {
                  await _prefs?.setString("access_token", newAt);
                }
                if (newRt is String) {
                  await _prefs?.setString("refresh_token", newRt);
                }

                // Retry original request
                e.requestOptions.headers["Authorization"] = "Bearer $newAt";
                final response = await _dio.fetch(e.requestOptions);
                return handler.resolve(response);
              } catch (refreshError) {
                // If refresh fails, logout
                await logout();
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isAuthenticated => _prefs?.containsKey("access_token") ?? false;
  String? get userId => _prefs?.getString("user_id");
  String? get accessToken => _prefs?.getString("access_token");
  String? get refreshToken => _prefs?.getString("refresh_token");

  // PIN Management
  bool get hasPin => _prefs?.containsKey("user_pin") ?? false;

  Future<void> savePin(String pin) async {
    await _prefs?.setString("user_pin", pin);
  }

  bool verifyPin(String pin) {
    return _prefs?.getString("user_pin") == pin;
  }

  Future<void> logout() async {
    debugPrint("Logging out...");
    await _prefs?.remove("access_token");
    await _prefs?.remove("refresh_token");
    await _prefs?.remove("user_id");
    // We keep the PIN even after logout as requested.
    // await _prefs?.remove("user_pin");
    debugPrint("Logout complete, storage cleared (PIN kept).");
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    debugPrint("Google Sign In requested (dummy)");
    return {};
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required String phone,
  }) async {
    try {
      final response = await _dio.post(
        "/auth/register",
        data: {
          "email": email,
          "password": password,
          "firstname": firstname,
          "lastname": lastname,
          "phone": phone,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        await _saveSession(data);
      }

      return data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response!.data["message"] is List
              ? e.response!.data["message"][0]
              : e.response!.data["message"],
        );
      } else {
        throw Exception("Connection error");
      }
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post("/auth/forgot_password", data: {"email": email});
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data["message"]);
      } else {
        throw Exception("Connection error");
      }
    }
  }

  Future<String> verifyOtp(String email, String otp) async {
    try {
      final response = await _dio.post(
        "/auth/otp",
        data: {"email": email, "otp": otp},
      );
      return response.data["resetToken"];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data["message"]);
      } else {
        throw Exception("Connection error");
      }
    }
  }

  Future<void> resetPassword(String resetToken, String newPassword) async {
    try {
      await _dio.post(
        "/auth/reset_password",
        data: {"reset_token": resetToken, "new_password": newPassword},
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data["message"]);
      } else {
        throw Exception("Connection error");
      }
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        "/auth/login",
        data: {"email": email, "password": password},
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        await _saveSession(data);
      }
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response!.data["message"] is List
              ? e.response!.data["message"][0]
              : e.response!.data["message"],
        );
      } else {
        throw Exception("Connection error");
      }
    }
  }

  Future<void> _saveSession(Map<String, dynamic> data) async {
    final at = data["access_token"];
    final rt = data["refresh_token"];
    final user = data["user"];
    if (at is String) await _prefs?.setString("access_token", at);
    if (rt is String) await _prefs?.setString("refresh_token", rt);
    if (user != null && user["user_id"] != null) {
      await _prefs?.setString("user_id", user["user_id"].toString());
    }
  }

  Future<void> refreshTokenManual() async {
    final rt = refreshToken;
    if (rt == null) return;
    try {
      final response = await Dio().post(
        "${AppConfig.baseUrl}/auth/refresh",
        options: Options(headers: {"Authorization": "Bearer $rt"}),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        await _saveSession(data);
      }
    } catch (e) {
      debugPrint("Manual refresh failed: $e");
    }
  }
}
