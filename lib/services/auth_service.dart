import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shakey/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  static final AuthService instance = AuthService._internal();
  SharedPreferences? _prefs;
  late final Dio _dio;

  final String desktopClientId =
      '332567834398-u89qerr1d85dh1k9tepjt68dskgnibqo.apps.googleusercontent.com';

  Dio get dio => _dio;

  AuthService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        headers: {"Content-Type": "application/json"},
      ),
    );

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

                e.requestOptions.headers["Authorization"] = "Bearer $newAt";
                final response = await _dio.fetch(e.requestOptions);
                return handler.resolve(response);
              } catch (refreshError) {
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
    debugPrint("Logout complete, storage cleared (PIN kept).");
  }

  // ---------------------------------------------------------------------------
  // Google Auth Methods
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> signInWithGoogle() async {
    if (kIsWeb) {
      throw Exception('Web login is not implemented yet.');
    }

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return await _handleDesktopGoogleLogin();
    } else {
      throw Exception(
        'Mobile login requires google_sign_in package implementation.',
      );
    }
  }

  Future<Map<String, dynamic>> _handleDesktopGoogleLogin() async {
    HttpServer? server;
    try {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final redirectUri = 'http://localhost:${server.port}';

      final authUrl = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
        'client_id': desktopClientId,
        'redirect_uri': redirectUri,
        'response_type': 'code',
        'scope': 'email profile openid',
        'access_type': 'offline',
      });

      if (await canLaunchUrl(authUrl)) {
        await launchUrl(authUrl, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch browser');
      }

      final request = await server.first.timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('Login timed out. Please try again.');
        },
      );
      final code = request.uri.queryParameters['code'];

      request.response
        ..statusCode = 200
        ..headers.set('Content-Type', 'text/html; charset=utf-8')
        ..write('''
          <html>
            <body style="display:flex; justify-content:center; align-items:center; height:100vh; font-family:sans-serif; background-color:#FDF7E6;">
              <div style="text-align:center;">
                <h1 style="color:#E04A41;">Login Successful!</h1>
                <p>You can close this window and return to the app.</p>
              </div>
            </body>
          </html>
        ''');
      await request.response.close();

      if (code == null) {
        throw Exception('Authorization code not found from Google.');
      }

      return await _loginWithBackendGoogleDesktop(code, redirectUri);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Google Login Error: $e');
    } finally {
      await server?.close();
    }
  }

  Future<Map<String, dynamic>> _loginWithBackendGoogleDesktop(
    String code,
    String redirectUri,
  ) async {
    try {
      final response = await _dio.post(
        "/auth/google",
        data: {"code": code, "redirectUri": redirectUri},
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
        throw Exception("Connection error with backend.");
      }
    }
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
