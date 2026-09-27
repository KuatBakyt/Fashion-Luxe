import 'package:flutter/foundation.dart';
import 'package:luxe/core/error/app_exeption.dart';

import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';
import 'product_state.dart';

class ShopViewModel extends ChangeNotifier {
  final ProductRepository repository;

  ShopViewModel(this.repository);

  ProductState _state = ProductInitial();

  ProductState get state => _state;

  List<Product> products = [];
  List<Product> filteredProducts = [];

  String searchQuery = '';
  String selectedCategory = 'All';
  String sortOption = 'Default';

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
    _state = ProductLoading();
    notifyListeners();

    try {
      products = await repository.getProducts();

      filteredProducts = List.from(products);

      _state = ProductSuccess(filteredProducts);
    } on AppException catch (e) {
      _state = ProductError(e.message);
    } catch (e) {
      _state = ProductError(
        'Something went wrong',
      );
    }

    notifyListeners();
  }

  void searchProducts(String query) {
    searchQuery = query;
    _applyFilters();
  }

  void filterByCategory(String category) {
    selectedCategory = category;
    _applyFilters();
  }

  void sortProducts(String option) {
    sortOption = option;
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchQuery.toLowerCase().trim();

    filteredProducts = products.where((product) {
      final matchesCategory =
          selectedCategory == 'All' ||
          product.category == selectedCategory;

      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();

    switch (sortOption) {
      case 'Price: Low to High':
        filteredProducts.sort(
          (a, b) => a.price.compareTo(b.price),
        );
        break;

      case 'Price: High to Low':
        filteredProducts.sort(
          (a, b) => b.price.compareTo(a.price),
        );
        break;
    }

    _state = ProductSuccess(filteredProducts);

    notifyListeners();
  }
}