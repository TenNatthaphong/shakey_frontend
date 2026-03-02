import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService instance = AuthService._internal();
  SharedPreferences? _prefs;
  late final Dio _dio;

  AuthService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "http://localhost:3333",
        headers: {"Content-Type": "application/json"},
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = this.accessToken;
          if (accessToken != null) {
            options.headers["Authorization"] = "Bearer $accessToken";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = this.refreshToken;
            if (refreshToken != null) {
              try {
                // Try to refresh token
                final refreshResponse = await Dio().post(
                  "http://localhost:3333/auth/refresh",
                  options: Options(
                    headers: {"Authorization": "Bearer $refreshToken"},
                  ),
                );

                final newAccessToken = refreshResponse.data["access_token"];
                final newRefreshToken = refreshResponse.data["refresh_token"];

                if (newAccessToken is String) {
                  await _prefs?.setString("access_token", newAccessToken);
                }
                if (newRefreshToken is String) {
                  await _prefs?.setString("refresh_token", newRefreshToken);
                }

                // Retry original request
                e.requestOptions.headers["Authorization"] =
                    "Bearer $newAccessToken";
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
    print("Logging out...");
    await _prefs?.remove("access_token");
    await _prefs?.remove("refresh_token");
    await _prefs?.remove("user_id");
    // We keep the PIN even after logout as requested.
    // await _prefs?.remove("user_pin");
    print("Logout complete, storage cleared (PIN kept).");
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    print("Google Sign In requested (dummy)");
    return {};
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required String phone,
  }) async {
    try {
      await _dio.post(
        "/auth/register",
        data: {
          "email": email,
          "password": password,
          "firstname": firstname,
          "lastname": lastname,
          "phone": phone,
        },
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
        final accessToken = data["access_token"];
        final refreshToken = data["refresh_token"];
        final userData = data["user"];
        if (accessToken is String) {
          await _prefs?.setString("access_token", accessToken);
        }
        if (refreshToken is String) {
          await _prefs?.setString("refresh_token", refreshToken);
        }
        if (userData != null && userData["user_id"] != null) {
          await _prefs?.setString("user_id", userData["user_id"].toString());
        }
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
}
