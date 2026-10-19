import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetailArguments {
  final Product product;
  final ValueChanged<Product> onAddToCart;

  const ProductDetailArguments({
    required this.product,
    required this.onAddToCart,
  });
}

class ProductDetailPage extends StatelessWidget {
  final ProductDetailArguments arguments;

  const ProductDetailPage({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    final product = arguments.product;

    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Detayı')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                height: 290,
                color: Colors.white,
                child: product.image.startsWith('http')
                    ? Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Image.asset(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              product.category,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              product.priceLabel,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF17365D),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ürün Açıklaması',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              product.description,
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                arguments.onAddToCart(product);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} sepete eklendi.'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Sepete Ekle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF17365D),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
