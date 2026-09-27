import '../models/order.dart';

class OrderService {
  Future<Order> createOrder(Order order) async {
    // Имитируем запрос на сервер.
    await Future.delayed(
      const Duration(seconds: 2),
    );

    return order;
  }
}