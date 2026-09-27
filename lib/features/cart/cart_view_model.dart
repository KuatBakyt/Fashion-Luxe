import 'package:flutter/foundation.dart';

import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';

class CartViewModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get totalPrice {
    return _items.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  int get totalItems {
    return _items.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }

  void addToCart(
    Product product,
    String size,
  ) {
    final index = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.size == size,
    );

    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(
        CartItem(
          product: product,
          size: size,
        ),
      );
    }

    notifyListeners();
  }

  void increaseQuantity(
    int productId,
    String size,
  ) {
    final index = _items.indexWhere(
      (item) =>
          item.product.id == productId &&
          item.size == size,
    );

    if (index == -1) return;

    _items[index].quantity++;

    notifyListeners();
  }

  void decreaseQuantity(
    int productId,
    String size,
  ) {
    final index = _items.indexWhere(
      (item) =>
          item.product.id == productId &&
          item.size == size,
    );

    if (index == -1) return;

    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  void removeFromCart(
    int productId,
    String size,
  ) {
    _items.removeWhere(
      (item) =>
          item.product.id == productId &&
          item.size == size,
    );

    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}