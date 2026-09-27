import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../cart/cart_view_model.dart';
import 'checkout_view_model.dart';

class ShippingAddressView extends StatefulWidget {
  const ShippingAddressView({super.key});

  @override
  State<ShippingAddressView> createState() => _ShippingAddressViewState();
}

class _ShippingAddressViewState extends State<ShippingAddressView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();
    final checkout = context.read<CheckoutViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('SHIPPING ADDRESS')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your bag is empty'))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _addressField(
                    label: 'Full name',
                    initialValue: checkout.fullName,
                    onChanged: checkout.setFullName,
                  ),
                  _addressField(
                    label: 'Phone number',
                    initialValue: checkout.phone,
                    onChanged: checkout.setPhone,
                    keyboardType: TextInputType.phone,
                  ),
                  _addressField(
                    label: 'City',
                    initialValue: checkout.city,
                    onChanged: checkout.setCity,
                  ),
                  _addressField(
                    label: 'Street address',
                    initialValue: checkout.address,
                    onChanged: checkout.setAddress,
                  ),
                ],
              ),
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.push('/checkout/payment');
                    }
                  },
                  child: const Text('CONTINUE TO PAYMENT'),
                ),
              ),
            ),
    );
  }

  Widget _addressField({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Enter $label';
          }
          return null;
        },
      ),
    );
  }
}
