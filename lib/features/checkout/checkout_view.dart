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
                const Text('ORDER SUMMARY', style: TextStyle(letterSpacing: 2)),
                const SizedBox(height: 16),
                ...cart.items.map((item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.product.name),
                  subtitle: Text('Size ${item.size} · Qty ${item.quantity}'),
                  trailing: Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                )),
                const Divider(),
                ListTile(title: const Text('Subtotal'),
                  trailing: Text('\$${cart.totalPrice.toStringAsFixed(2)}')),
                ListTile(title: const Text('Shipping'),
                  trailing: Text(checkout.shippingPrice == 0 ? 'FREE'
                    : '\$${checkout.shippingPrice.toStringAsFixed(2)}')),
                const Divider(),
                ListTile(title: const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text('\$${(cart.totalPrice + checkout.shippingPrice).toStringAsFixed(2)}')),
                const SizedBox(height: 24),
                const Text('DELIVERY METHOD', style: TextStyle(letterSpacing: 2)),
                RadioListTile<DeliveryMethod>(
                  title: const Text('Standard · 5–7 business days · FREE'),
                  value: DeliveryMethod.standard,
                  groupValue: checkout.deliveryMethod,
                  onChanged: (value) { if (value != null) checkout.selectDelivery(value); },
                ),
                RadioListTile<DeliveryMethod>(
                  title: const Text('Express · 1–2 business days · \$15'),
                  value: DeliveryMethod.express,
                  groupValue: checkout.deliveryMethod,
                  onChanged: (value) { if (value != null) checkout.selectDelivery(value); },
                ),
              ],
            ),
      bottomNavigationBar: cart.items.isEmpty ? null : SafeArea(
        child: Padding(padding: const EdgeInsets.all(16),
          child: FilledButton(onPressed: () => context.push('/checkout/address'),
            child: const Text('CONTINUE TO ADDRESS'))),
      ),
    );
  }
}
