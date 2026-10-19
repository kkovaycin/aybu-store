import 'package:flutter/material.dart';

import '../models/product.dart';

class CartPage extends StatefulWidget {
  final List<Product> products;
  final Map<int, int> quantities;
  final void Function(Product product, int change) onChangeQuantity;

  const CartPage({
    super.key,
    required this.products,
    required this.quantities,
    required this.onChangeQuantity,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartProducts = widget.products.where((product) {
      return (widget.quantities[product.id] ?? 0) > 0;
    }).toList();

    final total = cartProducts.fold<double>(0, (sum, product) {
      final quantity = widget.quantities[product.id] ?? 0;
      return sum + product.price * quantity;
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Sepetim')),
      body: cartProducts.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text('Sepetiniz henüz boş.', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                final product = cartProducts[index];
                final quantity = widget.quantities[product.id] ?? 0;

                return Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: product.image.startsWith('http')
                                ? Image.network(
                                    product.image,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.image_not_supported_outlined,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    product.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.image_not_supported_outlined,
                                      );
                                    },
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(product.priceLabel),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        widget.onChangeQuantity(product, -1);
                                      });
                                    },
                                  ),
                                  Text('$quantity'),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      setState(() {
                                        widget.onChangeQuantity(product, 1);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cartProducts.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Toplam:', style: TextStyle(fontSize: 18)),
                    Text(
                      '${total.toStringAsFixed(2)} '
                      '${cartProducts.first.currency}',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF17365D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
