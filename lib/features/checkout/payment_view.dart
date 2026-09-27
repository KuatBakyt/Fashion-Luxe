import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../cart/cart_view_model.dart';
import 'checkout_view_model.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final checkout = context.watch<CheckoutViewModel>();
    final cart = context.watch<CartViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('PAYMENT')),
      body: cart.items.isEmpty ? const Center(child: Text('Your bag is empty')) :
        ListView(padding: const EdgeInsets.all(20), children: [
          const Text('PAYMENT METHOD', style: TextStyle(letterSpacing: 2)),
          RadioListTile<PaymentMethod>(
            title: const Text('Cash on delivery'),
            value: PaymentMethod.cash,
            groupValue: checkout.paymentMethod,
            onChanged: (value) { if (value != null) checkout.selectPayment(value); },
          ),
          const Divider(),
          const Text('Online card payment is not connected yet.'),
          const SizedBox(height: 24),
          Text('Total: \$${(cart.totalPrice + checkout.shippingPrice).toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 20)),
          if (!checkout.isValid) const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('Enter your shipping address before placing an order.'),
          ),
        ]),
      bottomNavigationBar: cart.items.isEmpty ? null : SafeArea(
        child: Padding(padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: !checkout.isValid || checkout.isLoading ? null : () async {
              final order = await checkout.placeOrder(cartTotal: cart.totalPrice);
              if (!context.mounted) return;
              if (order == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(checkout.error ?? 'Could not place order')));
                return;
              }
              cart.clearCart();
              checkout.reset();
              context.go('/order-success', extra: order);
            },
            child: checkout.isLoading
              ? const SizedBox(width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('PLACE ORDER'),
          )),
      ),
    );
  }
}
