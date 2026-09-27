import 'package:go_router/go_router.dart';
import 'package:luxe/data/models/order.dart';
import 'package:provider/provider.dart';

import '../data/models/product.dart';

import '../features/home/home_view.dart';
import '../features/shop/shop_view.dart';
import '../features/product/product_detail_view.dart';
import '../features/product/product_detail_view_model.dart';
import '../features/cart/cart_view.dart';
import '../features/favorites/favorites_view.dart';
import '../features/checkout/checkout_view.dart';
import '../features/checkout/order_success_view.dart';
import '../features/checkout/shipping_address_view.dart';
import '../features/checkout/payment_view.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    // HOME
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),

    // SHOP
    GoRoute(
      path: '/shop',
      builder: (context, state) => const ShopView(),
    ),

    // PRODUCT DETAIL
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final product = state.extra;
        if (product is! Product) return const ShopView();

        return ChangeNotifierProvider(
          create: (_) => ProductDetailViewModel(),
          child: ProductDetailView(
            product: product,
          ),
        );
      },
    ),

    // FAVORITES
    GoRoute(
      path: '/favorites',
      builder: (context, state) =>
          const FavoritesView(),
    ),

    // CART
    GoRoute(
      path: '/cart',
      builder: (context, state) =>
          const CartView(),
    ),

    // CHECKOUT
    GoRoute(
      path: '/checkout',
      builder: (context, state) =>
          const CheckoutView(),
    ),
    GoRoute(
      path: '/checkout/address',
      builder: (context, state) => const ShippingAddressView(),
    ),
    GoRoute(
      path: '/checkout/payment',
      builder: (context, state) => const PaymentView(),
    ),

    // ORDER SUCCESS
    GoRoute(
      path: '/order-success',
      builder: (context, state) {
        final order = state.extra;

        if (order is! Order) {
          return const HomeView();
        }

        return OrderSuccessView(
          order: order,
        );
      },
    ),
  ],
);
