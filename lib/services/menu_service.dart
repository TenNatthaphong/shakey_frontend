import 'package:dio/dio.dart';
import 'package:shakey/models/menu.dart';
import 'package:shakey/services/auth_service.dart';

class MenuService {
  static const String baseUrl = 'http://127.0.0.1:3333';

  Future<List<Menu>> getMenus() async {
    try {
      final response = await AuthService.instance.dio.get('/menu');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final menus = data.map((json) => Menu.fromJson(json)).toList();

        // Fetch variants for each menu to support fast-add with correct ID
        return await Future.wait(
          menus.map((m) async {
            final variants = await getMenuVariants(m.id);
            return m.copyWith(sizes: variants);
          }),
        );
      }
    } catch (e) {
      // TODO(backend): Implement real menu API
      print('Error fetching menus: $e');
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
      print('Error fetching toppings: $e');
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
            variantId: json['variant_id'] ?? '',
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
      final response = await AuthService.instance.dio.post(
        '/order',
        data: {
          'delivery': order.delivery,
          'order_details': order.items.map((item) => item.toJson()).toList(),
          'total_price': order.items.fold(
            0,
            (sum, item) => sum + item.totalPrice,
          ),
        },
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error creating order: $e');
      return false;
    }
  }

  Future<List<String>> getFavoriteIds() async {
    try {
      final userId = AuthService.instance.userId;
      if (userId == null) {
        print('MenuService: userId is null, skipping favorite fetch');
        return [];
      }

      print('MenuService: fetching favorites at $baseUrl/menu/favorite');
      final response = await AuthService.instance.dio.get('/menu/favorite');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print('MenuService: fetched ${data.length} favorites');
        return data.map((item) => item['menu_id'].toString()).toList();
      } else {
        print(
          'MenuService: getFavoriteIds failed status=${response.statusCode}',
        );
      }
    } catch (e) {
      print('MenuService: Error fetching favorite IDs: $e');
    }
    return [];
  }

  Future<Map<String, dynamic>> toggleFavorite(
    String menuId,
    bool isCurrentlyFavorite,
  ) async {
    try {
      final endpoint = isCurrentlyFavorite ? 'remove' : 'add';
      print('MenuService: toggling favorite for $menuId. endpoint=$endpoint');

      final response = await AuthService.instance.dio.post(
        '/user/favorite/$endpoint',
        data: {'menu_id': menuId},
      );

      print('MenuService: toggle status=${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true};
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      print('MenuService: Error toggling favorite: $e');
      String message = e.message ?? 'Unknown error';
      if (e.response != null) {
        message =
            e.response?.data?['message']?.toString() ??
            'Error ${e.response?.statusCode}';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      print('MenuService: Error toggling favorite: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
