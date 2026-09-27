import '../../data/models/product.dart';

sealed class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final List<Product> products;

  ProductSuccess(this.products);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}