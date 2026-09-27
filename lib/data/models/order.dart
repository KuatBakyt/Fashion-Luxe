class Order {
  final String id;
  final String fullName;
  final String phone;
  final String city;
  final String address;
  final double totalPrice;
  final String deliveryMethod;
  final String paymentMethod;

  const Order({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.city,
    required this.address,
    required this.totalPrice,
    required this.deliveryMethod,
    required this.paymentMethod,
  });
}