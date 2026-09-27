import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/cart_item.dart';
import 'cart_view_model.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bag',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: cart.items.isEmpty
          ? _buildEmptyCart()
          : _buildCart(cart),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : _buildCheckout(context, cart),
    );
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 70,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Your bag is empty',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add something you like',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCart(CartViewModel cart) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cart.items.length,
      separatorBuilder: (_, __) {
        return const Divider(height: 32);
      },
      itemBuilder: (context, index) {
        final item = cart.items[index];

        return _buildCartItem(
          cart,
          item,
        );
      },
    );
  }

  Widget _buildCartItem(
    CartViewModel cart,
    CartItem item,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            item.product.imageUrl,
            width: 100,
            height: 130,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 15,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                item.product.category,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 6),

              // Теперь показываем размер
              Text(
                'Size: ${item.size}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                '\$${item.product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFFA8715A),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      cart.decreaseQuantity(
                        item.product.id,
                        item.size,
                      );
                    },
                    icon: const Icon(
                      Icons.remove,
                      size: 18,
                    ),
                  ),

                  Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      cart.increaseQuantity(
                        item.product.id,
                        item.size,
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 18,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {
                      cart.removeFromCart(
                        item.product.id,
                        item.size,
                      );
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckout(
    BuildContext context,
    CartViewModel cart,
  ) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFE5E5E5),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  '\$${cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFFA8715A),
                    fontSize: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () {
                  context.push('/checkout');
                },
                child: const Text(
                  'CHECKOUT',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}