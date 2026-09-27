import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/order.dart';

class OrderSuccessView extends StatelessWidget {
  final Order order;

  const OrderSuccessView({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              const Icon(
                Icons.check_circle_outline,
                size: 90,
              ),

              const SizedBox(height: 30),

              const Text(
                'ORDER CONFIRMED',
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Thank you for your purchase.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              _InfoRow(
                title: 'Order',
                value: '#${order.id}',
              ),

              const Divider(),

              _InfoRow(
                title: 'Customer',
                value: order.fullName,
              ),

              const Divider(),

              _InfoRow(
                title: 'Delivery',
                value: order.deliveryMethod,
              ),

              const Divider(),

              _InfoRow(
                title: 'Payment',
                value: order.paymentMethod,
              ),

              const Divider(),

              _InfoRow(
                title: 'Total',
                value:
                    '\$${order.totalPrice.toStringAsFixed(2)}',
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: const Text(
                    'CONTINUE SHOPPING',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const Spacer(),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}