import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/models/product.dart';
import '../favorites/favorites_view_model.dart';
import 'home_view_model.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/app_drawer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: _buildAppBar(context),
      body: _buildContent(context, viewModel),
      bottomNavigationBar: const AppBottomNavigation(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'LUXE',
        style: TextStyle(
          fontSize: 22,
          letterSpacing: 6,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => context.push('/shop'),
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {
            context.push('/cart');
          },
          icon: const Icon(Icons.shopping_bag_outlined),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return _buildError(viewModel);
    }

    return _buildBody(context, viewModel);
  }

  Widget _buildBody(BuildContext context, HomeViewModel viewModel) {
    return ListView(
      children: [
        _buildHero(context),

        const SizedBox(height: 36),

        _buildNewArrivalsTitle(),

        const SizedBox(height: 20),

        _buildCategories(viewModel),

        const SizedBox(height: 24),

        _buildProducts(context, viewModel),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildError(HomeViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_outlined, size: 64, color: Colors.grey),

            const SizedBox(height: 20),

            const Text(
              'Something went wrong',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            Text(
              viewModel.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 24),

            OutlinedButton(
              onPressed: () {
                viewModel.loadProducts();
              },
              child: const Text('RETRY'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // assets/images/hero.jpg — локальная картинка,
        // поэтому используем Image.asset, а не Image.network.
        Image.asset(
          'assets/images/hero.jpg',
          height: 470,
          width: double.infinity,
          fit: BoxFit.cover,
        ),

        Positioned(
          left: 28,
          bottom: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LUXURY\nFASHION',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  height: 1.1,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w300,
                ),
              ),

              const SizedBox(height: 24),

              OutlinedButton(
                onPressed: () {
                  context.push('/shop');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  shape: const RoundedRectangleBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'EXPLORE COLLECTION',
                  style: TextStyle(letterSpacing: 2),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewArrivalsTitle() {
    return const Column(
      children: [
        Text(
          'NEW ARRIVALS',
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 4,
            fontWeight: FontWeight.w400,
          ),
        ),

        SizedBox(height: 10),

        Text(
          'Explore our latest collection',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),

        SizedBox(height: 14),

        Text('◇', style: TextStyle(fontSize: 18)),
      ],
    );
  }

  Widget _buildCategories(HomeViewModel viewModel) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.categories.length,
        separatorBuilder: (_, _) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final category = viewModel.categories[index];

          return ChoiceChip(
            label: Text(category),
            selected: viewModel.selectedCategory == category,
            onSelected: (_) {
              viewModel.filterByCategory(category);
            },
          );
        },
      ),
    );
  }

  Widget _buildProducts(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.filteredProducts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: Text('No products found')),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,

      // ListView уже отвечает за scroll всей страницы.
      physics: const NeverScrollableScrollPhysics(),

      itemCount: viewModel.filteredProducts.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 28,
        childAspectRatio: 0.60,
      ),

      itemBuilder: (context, index) {
        final product = viewModel.filteredProducts[index];

        return _buildProductCard(context, product);
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        context.go('/product/${product.id}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  product.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('IMAGE ERROR: $error');
                    debugPrint('IMAGE URL: ${product.imageUrl}');

                    return const Center(
                      child: Icon(Icons.image_not_supported_outlined, size: 40),
                    );
                  },
                ),

                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Consumer<FavoritesViewModel>(
                    builder: (context, favorites, child) {
                      final isFavorite = favorites.isFavorite(product);

                      return IconButton(
                        onPressed: () => favorites.toggleFavorite(product),
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: const Color(0xFFDD8560),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, letterSpacing: 0.5),
          ),

          const SizedBox(height: 5),

          Text(
            product.category,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),

          const SizedBox(height: 5),

          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(color: Color(0xFFA8715A), fontSize: 15),
          ),
        ],
      ),
    );
  }
}
