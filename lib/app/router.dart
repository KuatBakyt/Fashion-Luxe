import 'package:go_router/go_router.dart';
import 'package:luxe/data/models/order.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../data/repositories/product_repository.dart';
import '../data/models/product.dart';

import '../features/home/home_view.dart';
import '../features/shop/shop_view.dart';
import '../features/product/product_detail_view.dart';
import '../features/product/product_detail_view_model.dart';
import '../features/cart/cart_view.dart';
import '../features/favorites/favorites_view.dart';
import '../features/checkout/checkout_view.dart';
import '../features/checkout/order_success_view.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    // HOME
    GoRoute(path: '/', builder: (context, state) => const HomeView()),

    // SHOP
    GoRoute(path: '/shop', builder: (context, state) => const ShopView()),

    // PRODUCT DETAIL
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');

        if (id == null) {
          return const Scaffold(
            body: Center(child: Text('Invalid product ID')),
          );
        }

        return FutureBuilder<Product>(
          future: context.read<ProductRepository>().getProductById(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const Scaffold(
                body: Center(child: Text('Could not load product')),
              );
            }

            return ChangeNotifierProvider(
              create: (_) => ProductDetailViewModel(),
              child: ProductDetailView(product: snapshot.data!),
            );
          },
        );
      },
    ),

    // FAVORITES
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesView(),
    ),

    // CART
    GoRoute(path: '/cart', builder: (context, state) => const CartView()),

    // CHECKOUT
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutView(),
    ),

    // ORDER SUCCESS
    GoRoute(
      path: '/order-success',
      builder: (context, state) {
        final order = state.extra;

        if (order is! Order) {
          return const HomeView();
        }

        return OrderSuccessView(order: order);
      },
    ),
  ],
);
