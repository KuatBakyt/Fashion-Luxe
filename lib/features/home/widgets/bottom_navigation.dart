import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    int selectedIndex = switch (location) {
      '/shop' => 1,
      '/favorites' => 2,
      '/cart' => 3,
      _ => 0,
    };

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/');
          case 1:
            context.go('/shop');
          case 2:
            context.go('/favorites');
          case 3:
            context.go('/cart');
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront),
          label: 'Shop',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border),
          selectedIcon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          selectedIcon: Icon(Icons.shopping_bag),
          label: 'Bag',
        ),
      ],
    );
  }
}