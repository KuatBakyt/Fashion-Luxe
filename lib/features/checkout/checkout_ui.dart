import 'package:flutter/material.dart';

const checkoutAccent = Color(0xFFDD8560);
const checkoutInk = Color(0xFF1A1A1A);

class CheckoutStepHeader extends StatelessWidget {
  final int step;
  final String title;

  const CheckoutStepHeader({super.key, required this.step, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 8),
      Text(title, textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, letterSpacing: 3,
          fontWeight: FontWeight.w400)),
      const SizedBox(height: 12),
      const Text('◇', style: TextStyle(color: checkoutAccent, fontSize: 20)),
      const SizedBox(height: 14),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (var index = 1; index <= 3; index++) ...[
          CircleAvatar(radius: 13,
            backgroundColor: index <= step ? checkoutInk : const Color(0xFFEDEDED),
            child: Text('$index', style: TextStyle(fontSize: 11,
              color: index <= step ? Colors.white : Colors.black54))),
          if (index < 3) Container(width: 44, height: 1,
            color: index < step ? checkoutInk : const Color(0xFFE0E0E0)),
        ],
      ]),
      const SizedBox(height: 28),
    ]);
  }
}

class CheckoutSectionTitle extends StatelessWidget {
  final String title;
  const CheckoutSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Text(title, style: const TextStyle(fontSize: 14,
      letterSpacing: 2, fontWeight: FontWeight.w500)),
  );
}

class CheckoutTotal extends StatelessWidget {
  final String label;
  final String value;
  final bool prominent;

  const CheckoutTotal({super.key, required this.label, required this.value,
    this.prominent = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(letterSpacing: prominent ? 2 : 0,
        fontWeight: prominent ? FontWeight.w500 : FontWeight.normal)),
      Text(value, style: TextStyle(color: prominent ? checkoutAccent : checkoutInk,
        fontSize: prominent ? 18 : 14,
        fontWeight: prominent ? FontWeight.w600 : FontWeight.normal)),
    ]),
  );
}
