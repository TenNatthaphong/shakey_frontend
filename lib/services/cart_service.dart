import 'package:flutter/foundation.dart';
import 'package:shakey/models/menu.dart';

class CartService extends ChangeNotifier {
  CartService._();

  static final CartService instance = CartService._();

  final List<OrderDetail> _items = [];

  List<OrderDetail> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addMenu(Menu menu, {int quantity = 1}) {
    if (quantity <= 0) return;

    // Default to 'S' size if available
    MenuSize? selectedVariant;
    try {
      selectedVariant = menu.sizes.firstWhere(
        (s) =>
            s.name.toUpperCase() == 'S' || s.name.toUpperCase().contains('S'),
      );
    } catch (e) {
      if (menu.sizes.isNotEmpty) {
        selectedVariant = menu.sizes.first;
      }
    }

    final int basePrice = menu.price.toInt();
    final int upsizePrice = selectedVariant?.price.toInt() ?? 0;
    final int unitPrice = basePrice + upsizePrice;

    addOrderDetail(
      OrderDetail(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        menu: menu,
        variant: selectedVariant,
        quantity: quantity,
        sweetness: '100% Sweet', // Default to 100%
        price: unitPrice,
        selectedToppings: const [], // No toppings
      ),
    );
  }

  void addOrderDetail(OrderDetail detail) {
    if (detail.quantity <= 0) return;

    final existingIndex = _items.indexWhere((item) => _canMerge(item, detail));
    if (existingIndex >= 0) {
      final existing = _items[existingIndex];
      _items[existingIndex] = OrderDetail(
        id: existing.id,
        menu: existing.menu,
        variant: existing.variant,
        quantity: existing.quantity + detail.quantity,
        sweetness: existing.sweetness,
        price: existing.price,
        selectedToppings: existing.selectedToppings,
        note: existing.note,
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
        a.variant?.variantId == b.variant?.variantId &&
        a.price == b.price &&
        a.sweetness == b.sweetness &&
        a.note == b.note &&
        listEquals(
          a.selectedToppings.map((t) => t.id).toList(),
          b.selectedToppings.map((t) => t.id).toList(),
        );
  }
}
