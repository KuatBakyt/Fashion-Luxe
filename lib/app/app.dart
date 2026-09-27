import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'router.dart';
import 'app_theme.dart';

import '../core/network/dio_client.dart';

import '../data/repositories/product_repository.dart';
import '../data/repositories/order_repository.dart';

import '../data/services/product_service.dart';
import '../data/services/order_service.dart';

import '../features/home/home_view_model.dart';
import '../features/shop/shop_view_model.dart';
import '../features/cart/cart_view_model.dart';
import '../features/favorites/favorites_view_model.dart';
import '../features/checkout/checkout_view_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        Provider<Dio>(
          create: (_) => DioClient().dio,
        ),

        Provider<ProductService>(
          create: (context) {
            return ProductService(
              context.read<Dio>(),
            );
          },
        ),

        Provider<OrderService>(
          create: (_) => OrderService(),
        ),

        ProxyProvider<ProductService, ProductRepository>(
          update: (_, service, _) {
            return ProductRepository(service);
          },
        ),

        ProxyProvider<OrderService, OrderRepository>(
          update: (_, service, _) {
            return OrderRepository(
              service: service,
            );
          },
        ),

        ChangeNotifierProvider(
          create: (context) {
            final viewModel = HomeViewModel(
              context.read<ProductRepository>(),
            );

            viewModel.loadProducts();

            return viewModel;
          },
        ),

        ChangeNotifierProvider(
          create: (context) {
            final viewModel = ShopViewModel(
              context.read<ProductRepository>(),
            );

            viewModel.loadProducts();

            return viewModel;
          },
        ),

        ChangeNotifierProvider(
          create: (_) => CartViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => FavoritesViewModel(),
        ),

        ChangeNotifierProvider(
          create: (context) {
            return CheckoutViewModel(
              repository: context.read<OrderRepository>(),
            );
          },
        ),
      ],

      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'LUXE',
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}