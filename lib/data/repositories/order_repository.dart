import '../models/order.dart';
import '../services/order_service.dart';

class OrderRepository {
  final OrderService service;

  OrderRepository({
    required this.service,
  });

  Future<Order> createOrder(Order order) {
    return service.createOrder(order);
  }
}