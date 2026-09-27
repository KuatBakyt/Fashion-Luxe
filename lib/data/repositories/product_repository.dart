import '../models/product.dart';
import '../services/product_service.dart';

class ProductRepository {
  final ProductService service;

  ProductRepository(this.service);

  Future<List<Product>> getProducts() {
    return service.getProducts();
  }
}