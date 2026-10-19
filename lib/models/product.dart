class Product {
  final int id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String image;
  final String currency;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.image,
    this.currency = 'TL',
  });

  String get priceLabel => '${price.toStringAsFixed(2)} $currency';

  // Local JSON data
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      currency: json['currency'] as String? ?? 'TL',
    );
  }

  // Fake Store API data
  factory Product.fromFakeStore(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      currency: 'USD',
    );
  }

  // DummyJSON API data
  factory Product.fromDummyJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['thumbnail'] as String,
      currency: 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'image': image,
      'currency': currency,
    };
  }
}
