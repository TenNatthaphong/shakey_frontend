import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shakey/models/menu.dart';
import 'package:shakey/services/auth_service.dart';

class MenuService {
  static const String baseUrl = 'http://127.0.0.1:3333';

  Future<List<Menu>> getMenus() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/menu'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Menu.fromJson(json)).toList();
      }
    } catch (e) {
      // TODO(backend): Implement real menu API
      print('Error fetching menus: $e');
    }
    return Menu.allMenus; // Fallback to mock
  }

  Future<List<Topping>> getToppings() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/topping'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Topping.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching toppings: $e');
    }
    return [];
  }

  Future<List<MenuSize>> getMenuVariants(String menuId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/menu/$menuId/variants'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) {
          return MenuSize(
            name: json['size'] ?? '', // Expecting 'S', 'M', 'L'
            price:
                (json['price_upsize'] as num?)?.toDouble() ??
                0.0, // The upsize price to add
          );
        }).toList();
      }
    } catch (e) {
      print('Error fetching menu variants: $e');
    }
    return []; // Return empty list if fetch fails
  }

  Future<bool> createOrder(Order order) async {
    try {
      // TODO(backend): Implement order submission API
      return true;
    } catch (e) {
      print('Error creating order: $e');
      return false;
    }
  }

  Future<bool> toggleFavorite(String menuId, bool isCurrentlyFavorite) async {
    try {
      final endpoint = isCurrentlyFavorite ? 'remove' : 'add';
      final token = AuthService.instance.accessToken;

      final response = await http
          .post(
            Uri.parse('$baseUrl/user/favorite/$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({'menu_id': menuId}),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error toggling favorite: $e');
      return false;
    }
  }
}
