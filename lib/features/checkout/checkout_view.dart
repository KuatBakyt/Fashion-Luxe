import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../cart/cart_view_model.dart';
import 'checkout_view_model.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();
    final checkout = context.watch<CheckoutViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('CHECKOUT')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your bag is empty'))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('ORDER SUMMARY'),
                const SizedBox(height: 16),
                for (final item in cart.items)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.product.name),
                    subtitle: Text(
                      'Size ${item.size} · Quantity ${item.quantity}',
                    ),
                    trailing: Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                    ),
                  ),
                const Divider(),
                _PriceRow(
                  label: 'Subtotal',
                  price: cart.totalPrice,
                ),
                _PriceRow(
                  label: 'Shipping',
                  price: checkout.shippingPrice,
                ),
                const Divider(),
                _PriceRow(
                  label: 'Total',
                  price: cart.totalPrice + checkout.shippingPrice,
                ),
                const SizedBox(height: 24),
                const Text('DELIVERY METHOD'),
                RadioListTile<DeliveryMethod>(
                  title: const Text('Standard delivery (free)'),
                  value: DeliveryMethod.standard,
                  groupValue: checkout.deliveryMethod,
                  onChanged: (method) {
                    if (method != null) checkout.selectDelivery(method);
                  },
                ),
                RadioListTile<DeliveryMethod>(
                  title: const Text('Express delivery (\$15)'),
                  value: DeliveryMethod.express,
                  groupValue: checkout.deliveryMethod,
                  onChanged: (method) {
                    if (method != null) checkout.selectDelivery(method);
                  },
                ),
              ],
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: () => context.push('/checkout/address'),
                  child: const Text('CONTINUE TO ADDRESS'),
                ),
              ),
            ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.price});

  final String label;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(price == 0 ? 'FREE' : '\$${price.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
