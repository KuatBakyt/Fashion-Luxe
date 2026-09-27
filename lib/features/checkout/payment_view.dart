import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../cart/cart_view_model.dart';
import 'checkout_view_model.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();
    final checkout = context.watch<CheckoutViewModel>();
    final total = cart.totalPrice + checkout.shippingPrice;

    return Scaffold(
      appBar: AppBar(title: const Text('PAYMENT')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your bag is empty'))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('PAYMENT METHOD'),
                const ListTile(
                  leading: Icon(Icons.payments_outlined),
                  title: Text('Cash on delivery'),
                  trailing: Icon(Icons.check_circle),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Card payments are not connected. No payment is taken in this demo.',
                  style: TextStyle(color: Colors.grey),
                ),
                const Divider(height: 40),
                Text('Total: \$${total.toStringAsFixed(2)}'),
                if (!checkout.isValid)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Enter your shipping address first.'),
                  ),
              ],
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: checkout.isValid && !checkout.isLoading
                      ? () => _placeOrder(context, cart, checkout)
                      : null,
                  child: checkout.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('PLACE ORDER'),
                ),
              ),
            ),
    );
  }

  Future<void> _placeOrder(
    BuildContext context,
    CartViewModel cart,
    CheckoutViewModel checkout,
  ) async {
    final order = await checkout.placeOrder(cartTotal: cart.totalPrice);
    if (!context.mounted) return;

    if (order == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(checkout.error ?? 'Could not place order')),
      );
      return;
    }

    cart.clearCart();
    checkout.reset();
    context.go('/order-success', extra: order);
  }
}
