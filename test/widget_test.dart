import 'package:flutter_test/flutter_test.dart';
import 'package:luxe/data/models/order.dart';
import 'package:luxe/data/models/product.dart';
import 'package:luxe/data/repositories/order_repository.dart';
import 'package:luxe/data/services/order_service.dart';
import 'package:luxe/features/cart/cart_view_model.dart';
import 'package:luxe/features/checkout/checkout_view_model.dart';

class _FakeOrderService extends OrderService {
  @override
  Future<Order> createOrder(Order order) async => order;
}

void main() {
  test('checkout uses selected shipping, address and cash payment', () async {
    final cart = CartViewModel();
    const product = Product(id: 1, name: 'Dress', category: 'clothing',
      imageUrl: '', price: 20, description: '');
    cart.addToCart(product, 'M');
    final checkout = CheckoutViewModel(
      repository: OrderRepository(service: _FakeOrderService()),
    );
    checkout.setFullName('A Customer');
    checkout.setPhone('123456');
    checkout.setCity('Almaty');
    checkout.setAddress('Main Street 1');
    checkout.selectDelivery(DeliveryMethod.express);

    final order = await checkout.placeOrder(cartTotal: cart.totalPrice);
    expect(order?.totalPrice, 35);
    expect(order?.address, 'Main Street 1');
    expect(order?.paymentMethod, 'cash');
    checkout.reset();
    expect(checkout.isValid, isFalse);
  });
}
