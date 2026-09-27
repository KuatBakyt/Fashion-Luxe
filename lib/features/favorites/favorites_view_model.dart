import 'package:flutter/foundation.dart';

import '../../data/models/product.dart';

class FavoritesViewModel extends ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Product product) {
    return _favorites.any(
      (item) => item.id == product.id,
    );
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      _favorites.removeWhere(
        (item) => item.id == product.id,
      );
    } else {
      _favorites.add(product);
    }

    notifyListeners();
  }
}