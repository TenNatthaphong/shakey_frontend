import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
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
          final accessToken = await _storage.read(key: "access_token");
          if (accessToken != null) {
            options.headers["Authorization"] = "Bearer $accessToken";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = await _storage.read(key: "refresh_token");
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

                await _storage.write(
                  key: "access_token",
                  value: newAccessToken,
                );
                await _storage.write(
                  key: "refresh_token",
                  value: newRefreshToken,
                );

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

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> logout() async {
    await _storage.deleteAll();
    await _googleSignIn.signOut();
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();

      final googleUser = await _googleSignIn.authenticate();

      final googleAuth = googleUser.authentication;

      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception("No idToken received");
      }

      // ส่งไป backend ด้วย _dio
      final response = await _dio.post(
        "/auth/google",
        data: {"idToken": idToken},
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data["message"] ?? "Backend login failed");
      } else {
        throw Exception("Connection error");
      }
    } catch (e) {
      print("Google login error: $e");
      rethrow;
    }
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
