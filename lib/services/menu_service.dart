import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shakey/models/menu.dart';

class MenuService {
  static const String baseUrl = 'http://localhost:3333';

  Future<List<Menu>> getMenus() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/menus'));
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
      final response = await http.get(Uri.parse('$baseUrl/toppings'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Topping.fromJson(json)).toList();
      }
    } catch (e) {
      // TODO(backend): Implement real topping API
      print('Error fetching toppings: $e');
    }
    // Fallback Mock Toppings
    return const [
      Topping(id: 't1', name: 'Cream Cheese (separate)', price: 30),
      Topping(id: 't2', name: 'Konjac Jelly (separate)', price: 15),
      Topping(id: 't3', name: 'Yogurt (separate)', price: 30),
      Topping(
        id: 't4',
        name: 'Fresh Peeled Grapes (separate)',
        price: 55,
      ),
    ];
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
