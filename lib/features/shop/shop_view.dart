import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:luxe/features/favorites/favorites_view_model.dart';
import 'package:provider/provider.dart';

import 'shop_view_model.dart';
import 'product_state.dart';

class ShopView extends StatefulWidget {
  const ShopView({super.key});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (GoRouterState.of(context).uri.queryParameters['search'] == '1') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _searchFocus.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ShopViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LUXE',
          style: TextStyle(letterSpacing: 6, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showSortBottomSheet(context, viewModel);
            },
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: switch (viewModel.state) {
        ProductInitial() ||
        ProductLoading() => const Center(child: CircularProgressIndicator()),

        ProductSuccess() => Column(
          children: [
            _buildSearch(viewModel),
            _buildCategories(viewModel),
            Expanded(child: _buildProducts(viewModel)),
          ],
        ),

        ProductError(:final message) => _buildError(viewModel, message),
      },
    );
  }

  Widget _buildError(ShopViewModel viewModel, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 60),

            const SizedBox(height: 16),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 20),

            FilledButton(
              onPressed: viewModel.loadProducts,
              child: const Text('TRY AGAIN'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch(ShopViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: SearchBar(
        controller: _searchController,
        focusNode: _searchFocus,
        hintText: 'SEARCH PRODUCTS',
        leading: const Icon(Icons.search),
        trailing: [IconButton(
          tooltip: 'Clear search',
          onPressed: () {
            _searchController.clear();
            viewModel.searchProducts('');
          },
          icon: const Icon(Icons.close),
        )],
        onChanged: viewModel.searchProducts,
      ),
    );
  }

  Widget _buildCategories(ShopViewModel viewModel) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,

        itemCount: viewModel.categories.length,

        separatorBuilder: (_, __) {
          return const SizedBox(width: 8);
        },

        itemBuilder: (context, index) {
          final category = viewModel.categories[index];

          return ChoiceChip(
            label: Text(_categoryTitle(category)),
            selected: viewModel.selectedCategory == category,
            onSelected: (_) {
              viewModel.filterByCategory(category);
            },
          );
        },
      ),
    );
  }

  Widget _buildProducts(ShopViewModel viewModel) {
    if (viewModel.filteredProducts.isEmpty) {
      return const Center(
        child: Text('No products found', style: TextStyle(fontSize: 18)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.filteredProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 24,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final product = viewModel.filteredProducts[index];

        return GestureDetector(
          onTap: () {
            context.push('/product/${product.id}', extra: product);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.zero,
                      child: Image.network(
                        product.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),

                    Positioned(
                      right: 6,
                      bottom: 6,
                      child: Consumer<FavoritesViewModel>(
                        builder: (context, favoritesViewModel, child) {
                          final isFavorite = favoritesViewModel.isFavorite(
                            product,
                          );

                          return IconButton(
                            onPressed: () {
                              favoritesViewModel.toggleFavorite(product);
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? const Color(0xFFDD8560)
                                  : Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, letterSpacing: 0.5),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(color: Color(0xFFA8715A), fontSize: 15),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSortBottomSheet(BuildContext context, ShopViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Sort by',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              ListTile(
                title: const Text('Default'),
                trailing: viewModel.sortOption == 'Default'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  viewModel.sortProducts('Default');
                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text('Price: Low to High'),
                trailing: viewModel.sortOption == 'Price: Low to High'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  viewModel.sortProducts('Price: Low to High');
                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text('Price: High to Low'),
                trailing: viewModel.sortOption == 'Price: High to Low'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  viewModel.sortProducts('Price: High to Low');
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  String _categoryTitle(String category) {
    switch (category) {
      case 'All':
        return 'ALL';

      case "women's clothing":
        return 'WOMEN';

      case "men's clothing":
        return 'MEN';

      case 'jewelery':
        return 'JEWELRY';

      case 'electronics':
        return 'OTHER';

      default:
        return category.toUpperCase();
    }
  }
}
