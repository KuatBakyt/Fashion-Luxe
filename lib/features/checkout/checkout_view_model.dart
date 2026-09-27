import 'package:flutter/material.dart';

import '../../data/models/order.dart';
import '../../data/repositories/order_repository.dart';

enum DeliveryMethod { standard, express }

enum PaymentMethod { card, cash }

class CheckoutViewModel extends ChangeNotifier {
  String _fullName = '';
  String _phone = '';
  String _address = '';
  String _city = '';
  final OrderRepository repository;

  DeliveryMethod _deliveryMethod = DeliveryMethod.standard;
  PaymentMethod _paymentMethod = PaymentMethod.card;

  String get fullName => _fullName;
  String get phone => _phone;
  String get address => _address;
  String get city => _city;

  DeliveryMethod get deliveryMethod => _deliveryMethod;
  PaymentMethod get paymentMethod => _paymentMethod;
  CheckoutViewModel({required this.repository});

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  double get shippingPrice {
    switch (_deliveryMethod) {
      case DeliveryMethod.standard:
        return 0;
      case DeliveryMethod.express:
        return 15;
    }
  }

  void setFullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  void setAddress(String value) {
    _address = value;
    notifyListeners();
  }

  void setCity(String value) {
    _city = value;
    notifyListeners();
  }

  void selectDelivery(DeliveryMethod method) {
    _deliveryMethod = method;
    notifyListeners();
  }

  void selectPayment(PaymentMethod method) {
    _paymentMethod = method;
    notifyListeners();
  }

  bool get isValid {
    return _fullName.trim().isNotEmpty &&
        _phone.trim().isNotEmpty &&
        _address.trim().isNotEmpty &&
        _city.trim().isNotEmpty;
  }

  Future<Order?> placeOrder({required double cartTotal}) async {
    if (!isValid) {
      return null;
    }

    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      final total = cartTotal + shippingPrice;

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: fullName,
        phone: phone,
        city: city,
        address: address,
        totalPrice: total,
        deliveryMethod: deliveryMethod.name,
        paymentMethod: paymentMethod.name,
      );

      final result = await repository.createOrder(order);

      return result;
    } catch (e) {
      _error = 'Failed to create order';

      return null;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }
}
