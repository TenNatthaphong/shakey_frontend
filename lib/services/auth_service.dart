import 'package:dio/dio.dart';

class AuthService {
  static final Map<String, String> _demoStorage = <String, String>{};
  late final Dio _dio;

  AuthService() {
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
          final accessToken = _demoStorage["access_token"];
          if (accessToken != null) {
            options.headers["Authorization"] = "Bearer $accessToken";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = _demoStorage["refresh_token"];
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
                  _demoStorage["access_token"] = newAccessToken;
                }
                if (newRefreshToken is String) {
                  _demoStorage["refresh_token"] = newRefreshToken;
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

  Future<void> logout() async {
    print("Logging out...");
    _demoStorage.clear();
    print("Logout complete, storage cleared.");
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    print("Google Sign In requested (dummy)");
    // Return empty map or mock data as needed
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
        if (accessToken is String) {
          _demoStorage["access_token"] = accessToken;
        }
        if (refreshToken is String) {
          _demoStorage["refresh_token"] = refreshToken;
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
