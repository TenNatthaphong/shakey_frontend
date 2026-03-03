import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shakey/models/menu.dart';
import 'package:shakey/services/auth_service.dart';

class MenuService {
  Future<List<Menu>> getMenus() async {
    try {
      final response = await AuthService.instance.dio.get('/menu');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Menu.fromJson(json)).toList();
      }
    } catch (e) {
      // TODO(backend): Implement real menu API
      debugPrint('Error fetching menus: $e');
    }
    return Menu.allMenus; // Fallback to mock
  }

  Future<List<Topping>> getToppings() async {
    try {
      final response = await AuthService.instance.dio.get('/topping');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Topping.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching toppings: $e');
    }
    return [];
  }

  Future<List<MenuSize>> getMenuVariants(String menuId) async {
    try {
      final response = await AuthService.instance.dio.get(
        '/menu/$menuId/variants',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
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
      debugPrint('Error fetching menu variants: $e');
    }
    return []; // Return empty list if fetch fails
  }

  Future<bool> createOrder(Order order) async {
    try {
      // TODO(backend): Implement order submission API
      return true;
    } catch (e) {
      debugPrint('Error creating order: $e');
      return false;
    }
  }

  Future<List<String>> getFavoriteIds() async {
    try {
      final userId = AuthService.instance.userId;
      if (userId == null) {
        debugPrint('MenuService: userId is null, skipping favorite fetch');
        return [];
      }

      debugPrint(
        'MenuService: fetching favorites for $userId at /menu/favorite/$userId',
      );
      final response = await AuthService.instance.dio.get(
        '/menu/favorite/$userId',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        debugPrint('MenuService: fetched ${data.length} favorites');
        return data.map((item) => item['menu_id'].toString()).toList();
      } else {
        debugPrint(
          'MenuService: getFavoriteIds failed status=${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('MenuService: Error fetching favorite IDs: $e');
    }
    return [];
  }

  Future<Map<String, dynamic>> toggleFavorite(
    String menuId,
    bool isCurrentlyFavorite,
  ) async {
    try {
      final endpoint = isCurrentlyFavorite ? 'remove' : 'add';
      debugPrint(
        'MenuService: toggling favorite for $menuId. endpoint=$endpoint',
      );

      final response = await AuthService.instance.dio.post(
        '/user/favorite/$endpoint',
        data: {'menu_id': menuId},
      );

      debugPrint('MenuService: toggle status=${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true};
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      debugPrint('MenuService: Error toggling favorite: $e');
      String message = e.message ?? 'Unknown error';
      if (e.response != null) {
        message =
            e.response?.data?['message']?.toString() ??
            'Error ${e.response?.statusCode}';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      debugPrint('MenuService: Error toggling favorite: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
