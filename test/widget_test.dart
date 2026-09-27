import 'package:flutter_test/flutter_test.dart';
import 'package:luxe/data/models/product.dart';
import 'package:luxe/features/cart/cart_view_model.dart';

void main() {
  test('Adding a product updates cart total', () {
    final cart = CartViewModel();

    const product = Product(
      id: 1,
      name: 'Dress',
      category: 'Clothing',
      imageUrl: '',
      price: 25,
      description: 'Test product',
    );

    cart.addToCart(product, 'M');

    expect(cart.totalItems, 1);
    expect(cart.totalPrice, 25);
  });
}