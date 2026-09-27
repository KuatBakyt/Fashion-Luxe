class Product {
  final int id;
  final String name;
  final String category;
  final String imageUrl;
  final double price;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.description,
  });
  
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['title'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      imageUrl: json['image'] as String,
    );
  }
}
