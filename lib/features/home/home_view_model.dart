import 'package:flutter/foundation.dart';
import 'package:luxe/core/error/app_exeption.dart';

import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final ProductRepository repository;

  HomeViewModel(this.repository);

  List<Product> products = [];
  List<Product> filteredProducts = [];

  bool isLoading = false;

  String? errorMessage;

  String selectedCategory = 'All';

  // Категории теперь берём из API
  List<String> get categories {
    final uniqueCategories = products
        .map((product) => product.category)
        .toSet()
        .toList();

    return [
      'All',
      ...uniqueCategories,
    ];
  }

  Future<void> loadProducts() async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      products = await repository.getProducts();

      filteredProducts = List.from(products);
    } on AppException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Something went wrong';
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  void filterByCategory(String category) {
    selectedCategory = category;

    if (category == 'All') {
      filteredProducts = List.from(products);
    } else {
      filteredProducts = products.where((product) {
        return product.category == category;
      }).toList();
    }

    notifyListeners();
  }
}