import 'package:flutter/foundation.dart';
import 'package:shakey/models/menu.dart';

class CartService extends ChangeNotifier {
  CartService._();

  static final CartService instance = CartService._();

  final List<OrderDetail> _items = [];

  List<OrderDetail> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addMenu(Menu menu, {int quantity = 1, String sweetness = '100%'}) {
    if (quantity <= 0) return;
    final int unitPrice = (menu.price > 0 ? menu.price : menu.sizes.last.price)
        .toInt();
    addOrderDetail(
      OrderDetail(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        menu: menu,
        quantity: quantity,
        sweetness: sweetness,
        price: unitPrice,
      ),
    );
  }

  void addOrderDetail(OrderDetail detail) {
    if (detail.quantity <= 0) return;

    final existingIndex = _items.indexWhere(
      (item) => _canMerge(item, detail),
    );
    if (existingIndex >= 0) {
      final existing = _items[existingIndex];
      _items[existingIndex] = OrderDetail(
        id: existing.id,
        menu: existing.menu,
        quantity: existing.quantity + detail.quantity,
        sweetness: existing.sweetness,
        price: existing.price,
        selectedToppings: existing.selectedToppings,
      );
    } else {
      _items.add(detail);
    }
    notifyListeners();
  }

  void removeAt(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }

  bool _canMerge(OrderDetail a, OrderDetail b) {
    return a.menu.id == b.menu.id &&
        a.price == b.price &&
        a.sweetness == b.sweetness &&
        listEquals(
          a.selectedToppings.map((t) => t.id).toList(),
          b.selectedToppings.map((t) => t.id).toList(),
        );
  }
}
