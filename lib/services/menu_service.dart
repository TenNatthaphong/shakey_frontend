import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shakey/models/menu.dart';
import 'package:shakey/models/user.dart';
import 'package:shakey/services/auth_service.dart';

class MenuService extends ChangeNotifier {
  MenuService._();
  static final MenuService instance = MenuService._();

  final Set<String> _favoriteIds = {};
  Set<String> get favoriteIds => _favoriteIds;
  Future<List<Menu>> getMenus() async {
    try {
      final response = await AuthService.instance.dio.get('/menu');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final menus = data.map((json) => Menu.fromJson(json)).toList();

        return await Future.wait(
          menus.map((m) async {
            final variants = await getMenuVariants(m.id);
            return m.copyWith(sizes: variants);
          }),
        );
      }
    } catch (e) {
      debugPrint('Error fetching menus: $e');
    }
    return [];
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
            variantId: json['variant_id'] ?? '',
            name: json['size'] ?? '',
            price: (json['price_upsize'] as num?)?.toDouble() ?? 0.0,
          );
        }).toList();
      }
    } catch (e) {
      debugPrint('Error fetching menu variants: $e');
    }
    return [];
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

      print('MenuService: fetching favorites at /menu/favorite');
      final response = await AuthService.instance.dio.get('/menu/favorite');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        debugPrint('MenuService: fetched ${data.length} favorites');
        final ids = data.map((item) => item['menu_id'].toString()).toList();
        _favoriteIds.clear();
        _favoriteIds.addAll(ids);
        notifyListeners();
        return ids;
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
      if (isCurrentlyFavorite) {
        await AuthService.instance.dio.delete(
          '/user/favorite/remove',
          data: {'menu_id': menuId},
        );
      } else {
        await AuthService.instance.dio.post(
          '/user/favorite/add',
          data: {'menu_id': menuId},
        );
      }

      if (isCurrentlyFavorite) {
        _favoriteIds.remove(menuId);
      } else {
        _favoriteIds.add(menuId);
      }
      notifyListeners();
      return {'success': true};
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

  Future<List<Order>> getOrderHistory() async {
    try {
      final response = await AuthService.instance.dio.get('/order/history');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Order.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching order history: $e');
    }
    return [];
  }

  Future<List<Branch>> getBranches() async {
    try {
      final response = await AuthService.instance.dio.get('/branch');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Branch.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching branches: $e');
    }
    return [];
  }
}
