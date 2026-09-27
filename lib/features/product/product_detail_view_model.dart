import 'package:flutter/foundation.dart';

class ProductDetailViewModel extends ChangeNotifier {
  String? selectedSize;

  final List<String> sizes = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
  ];

  void selectSize(String size) {
    selectedSize = size;
    notifyListeners();
  }

  bool get hasSelectedSize => selectedSize != null;
}