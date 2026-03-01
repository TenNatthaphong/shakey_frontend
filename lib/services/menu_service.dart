import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shakey/models/menu.dart';

class MenuService {
  static const String baseUrl = 'http://127.0.0.1:3333';

  Future<List<MenuReward>> getRewardList() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/reward'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => MenuReward.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching reward list: $e');
    }
    return [];
  }

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

  Future<List<UserReward>> getUserRewards(String userId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/reward/my?userId=$userId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => UserReward.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching user rewards: $e');
    }
    return [];
  }

  Future<bool> redeemReward(String userId, String rewardId) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/reward/redeem'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'userId': userId, 'rewardId': rewardId}),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error redeeming reward: $e');
      return false;
    }
  }

  Future<bool> useReward(String userId, String userRewardId) async {
    try {
      final response = await http
          .patch(
            Uri.parse('$baseUrl/reward/use/$userRewardId'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'userId': userId}),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('Error using reward: $e');
      return false;
    }
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
      // final response = await http.post(...)
      return true;
    } catch (e) {
      print('Error creating order: $e');
      return false;
    }
  }
}
