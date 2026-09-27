import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../cart/cart_view_model.dart';
import 'checkout_view_model.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final checkout = context.watch<CheckoutViewModel>();
    final cart = context.watch<CartViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CHECKOUT',
          style: TextStyle(letterSpacing: 3, fontSize: 16),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SHIPPING ADDRESS',
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 24),

            _CheckoutField(label: 'Full name', onChanged: checkout.setFullName),

            const SizedBox(height: 16),

            _CheckoutField(
              label: 'Phone number',
              keyboardType: TextInputType.phone,
              onChanged: checkout.setPhone,
            ),

            const SizedBox(height: 16),

            _CheckoutField(label: 'City', onChanged: checkout.setCity),

            const SizedBox(height: 16),

            _CheckoutField(label: 'Address', onChanged: checkout.setAddress),

            const SizedBox(height: 36),

            const Divider(),

            const SizedBox(height: 24),

            const SizedBox(height: 120),

            const SizedBox(height: 36),

            const Divider(),

            const SizedBox(height: 24),

            const Text(
              'DELIVERY METHOD',
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 16),

            _DeliveryOption(
              title: 'Standard Delivery',
              subtitle: '5-7 business days',
              price: 'FREE',
              selected: checkout.deliveryMethod == DeliveryMethod.standard,
              onTap: () {
                checkout.selectDelivery(DeliveryMethod.standard);
              },
            ),

            const SizedBox(height: 12),

            _DeliveryOption(
              title: 'Express Delivery',
              subtitle: '1-2 business days',
              price: '\$15',
              selected: checkout.deliveryMethod == DeliveryMethod.express,
              onTap: () {
                checkout.selectDelivery(DeliveryMethod.express);
              },
            ),

            const SizedBox(height: 36),

            const Divider(),

            const SizedBox(height: 24),

            const Text(
              'PAYMENT METHOD',
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 12),

            _PaymentOption(
              icon: Icons.payments_outlined,
              title: 'Cash on Delivery',
              selected: checkout.paymentMethod == PaymentMethod.cash,
              onTap: () {
                checkout.selectPayment(PaymentMethod.cash);
              },
            ),

            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                'Demo checkout: no real payment is processed.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),

            const Text(
              'ORDER SUMMARY',
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            _SummaryRow(
              title: 'Subtotal',
              value: '\$${cart.totalPrice.toStringAsFixed(2)}',
            ),

            const SizedBox(height: 12),

            _SummaryRow(
              title: 'Shipping',
              value: checkout.shippingPrice == 0
                  ? 'FREE'
                  : '\$${checkout.shippingPrice.toStringAsFixed(2)}',
            ),

            const SizedBox(height: 16),

            const Divider(),

            const SizedBox(height: 16),

            _SummaryRow(
              title: 'TOTAL',
              value:
                  '\$${(cart.totalPrice + checkout.shippingPrice).toStringAsFixed(2)}',
              bold: true,
            ),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomBar(context, checkout, cart),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    CheckoutViewModel checkout,
    CartViewModel cart,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton(
            onPressed:
                !checkout.isValid || checkout.isLoading || cart.items.isEmpty
                ? null
                : () async {
                    final order = await checkout.placeOrder(
                      cartTotal: cart.totalPrice,
                    );

                    if (!context.mounted) {
                      return;
                    }

                    if (order == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            checkout.error ?? 'Something went wrong',
                          ),
                        ),
                      );

                      return;
                    }

                    cart.clearCart();

                    context.go('/order-success', extra: order);
                  },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A1A),
            ),
            child: checkout.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'PLACE ORDER',
                    style: TextStyle(letterSpacing: 2, fontSize: 13),
                  ),
          ),
        ),
      ),
    );
  }
}

class _CheckoutField extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  const _CheckoutField({
    required this.label,
    required this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: const UnderlineInputBorder(),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool bold;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _DeliveryOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  const _DeliveryOption({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Colors.black : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: selected,
              onChanged: (_) => onTap(),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),

            Text(price, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Colors.black : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(icon),

            const SizedBox(width: 16),

            Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),

            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
            ),
          ],
        ),
      ),
    );
  }
}
