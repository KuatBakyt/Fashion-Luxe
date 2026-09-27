import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../cart/cart_view_model.dart';
import 'checkout_view_model.dart';
import 'checkout_ui.dart';

class ShippingAddressView extends StatefulWidget {
  const ShippingAddressView({super.key});

  @override
  State<ShippingAddressView> createState() => _ShippingAddressViewState();
}

class _ShippingAddressViewState extends State<ShippingAddressView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final checkout = context.watch<CheckoutViewModel>();
    final cart = context.watch<CartViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('LUXE', style: TextStyle(letterSpacing: 6))),
      body: cart.items.isEmpty ? const Center(child: Text('Your bag is empty')) :
        Form(key: _formKey, child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const CheckoutStepHeader(step: 2, title: 'SHIPPING ADDRESS'),
            const CheckoutSectionTitle('DELIVERY DETAILS'),
            _field('Full name', checkout.fullName, checkout.setFullName),
            _field('Phone number', checkout.phone, checkout.setPhone,
                keyboard: TextInputType.phone),
            _field('City', checkout.city, checkout.setCity),
            _field('Street address', checkout.address, checkout.setAddress),
            const SizedBox(height: 16),
            const Text('This address is kept for the current checkout only.',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        )),
      bottomNavigationBar: cart.items.isEmpty ? null : SafeArea(
        child: Padding(padding: const EdgeInsets.all(16),
          child: FilledButton(onPressed: () {
            if (_formKey.currentState!.validate()) context.push('/checkout/payment');
          }, child: const Text('CONTINUE TO PAYMENT'))),
      ),
    );
  }

  Widget _field(String label, String value, ValueChanged<String> onChanged,
      {TextInputType? keyboard}) {
    return Padding(padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        keyboardType: keyboard,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: label,
          floatingLabelStyle: const TextStyle(color: checkoutAccent),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDADADA))),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: checkoutAccent))),
        validator: (text) => text == null || text.trim().isEmpty
            ? 'Enter $label' : null,
        onChanged: onChanged,
      ),
    );
  }
}
