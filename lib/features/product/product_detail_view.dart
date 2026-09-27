import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/product.dart';
import '../cart/cart_view_model.dart';
import '../favorites/favorites_view_model.dart';
import 'product_detail_view_model.dart';

class ProductDetailView extends StatelessWidget {
  final Product product;

  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesViewModel>();
    final isFavorite = favorites.isFavorite(product);
    final detailViewModel = context.watch<ProductDetailViewModel>();

    return Scaffold(
      appBar: _buildAppBar(context, isFavorite),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),

            const SizedBox(height: 24),

            _buildProductInfo(),

            const SizedBox(height: 24),

            _buildSizes(detailViewModel),

            const SizedBox(height: 32),

            _buildDescription(),

            const SizedBox(height: 32),

            _buildExtraInfo(),

            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isFavorite) {
    return AppBar(
      leading: IconButton(
        tooltip: 'Back to catalog',
        onPressed: () => context.go('/shop'),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text(
        'LUXE',
        style: TextStyle(letterSpacing: 6, fontWeight: FontWeight.w500),
      ),
      actions: [
        IconButton(
          tooltip: 'Open bag',
          onPressed: () => context.push('/cart'),
          icon: const Icon(Icons.shopping_bag_outlined),
        ),
        IconButton(
          onPressed: () {
            context.read<FavoritesViewModel>().toggleFavorite(product);
          },
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        ),
      ],
    );
  }

  Widget _buildProductImage() {
    return AspectRatio(
      aspectRatio: 0.78,
      child: Image.network(
        product.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.image_not_supported_outlined, size: 40),
          );
        },
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.category.toUpperCase(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            product.name.toUpperCase(),
            style: const TextStyle(
              fontSize: 22,
              letterSpacing: 2,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFFA8715A),
              fontSize: 18,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizes(ProductDetailViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text('SIZE', style: TextStyle(fontSize: 13, letterSpacing: 2)),

          const SizedBox(width: 20),

          ...viewModel.sizes.map((size) {
            final isSelected = viewModel.selectedSize == size;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SizedBox(
                width: 38,
                height: 38,
                child: OutlinedButton(
                  onPressed: () {
                    viewModel.selectSize(size);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,

                    backgroundColor: isSelected
                        ? const Color(0xFF1A1A1A)
                        : Colors.transparent,

                    foregroundColor: isSelected ? Colors.white : Colors.black,

                    shape: const CircleBorder(),
                  ),
                  child: Text(size, style: const TextStyle(fontSize: 11)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        product.description,
        style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.7),
      ),
    );
  }

  Widget _buildExtraInfo() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Divider(),

          _InfoRow(
            icon: Icons.local_shipping_outlined,
            title: 'SHIPPING',
            subtitle: 'Free standard shipping',
          ),

          Divider(),

          _InfoRow(
            icon: Icons.refresh,
            title: 'RETURNS',
            subtitle: 'Free returns within 30 days',
          ),

          Divider(),

          _InfoRow(
            icon: Icons.eco_outlined,
            title: 'MATERIALS',
            subtitle: 'Premium quality materials',
          ),

          Divider(),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final detailViewModel = context.watch<ProductDetailViewModel>();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Color(0xFF1A1A1A)),
        child: Row(
          children: [
            const Icon(Icons.add, color: Colors.white),

            const SizedBox(width: 12),

            Expanded(
              child: InkWell(
                onTap: () {
                  // Сначала проверяем размер
                  if (!detailViewModel.hasSelectedSize) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a size')),
                    );

                    return;
                  }

                  // Добавляем товар + выбранный размер
                  context.read<CartViewModel>().addToCart(
                    product,
                    detailViewModel.selectedSize!,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${product.name} '
                        '(${detailViewModel.selectedSize}) '
                        'added to Bag',
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'ADD TO BASKET',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),

            IconButton(
              onPressed: () {
                context.read<FavoritesViewModel>().toggleFavorite(product);
              },
              icon: Icon(
                context.watch<FavoritesViewModel>().isFavorite(product)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Icon(icon, size: 22),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, letterSpacing: 1.5),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          const Icon(Icons.add, size: 18),
        ],
      ),
    );
  }
}
