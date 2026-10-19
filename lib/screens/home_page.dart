import 'package:flutter/material.dart';

import '../data/product_repository.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<List<Product>> _productsFuture;

  final Map<int, int> _cart = {};

  String _searchQuery = '';
  String _selectedCategory = 'Tümü';

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductRepository.loadProducts();
  }

  void _changeQuantity(Product product, int change) {
    setState(() {
      final current = _cart[product.id] ?? 0;
      final updated = current + change;

      if (updated <= 0) {
        _cart.remove(product.id);
      } else {
        _cart[product.id] = updated;
      }
    });
  }

  void _addToCart(Product product) {
    _changeQuantity(product, 1);
  }

  int get _cartCount {
    return _cart.values.fold<int>(0, (sum, quantity) => sum + quantity);
  }

  void _openProductDetail(Product product) {
    Navigator.pushNamed(
      context,
      '/product',
      arguments: ProductDetailArguments(
        product: product,
        onAddToCart: _addToCart,
      ),
    );
  }

  void _openCart(List<Product> products) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => CartPage(
          products: products,
          quantities: _cart,
          onChangeQuantity: _changeQuantity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        final products = snapshot.data ?? <Product>[];

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'AYBÜ Store',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      _openCart(products);
                    },
                  ),
                  if (_cartCount > 0)
                    Positioned(
                      right: 3,
                      top: 3,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$_cartCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          body: _buildBody(snapshot),
        );
      },
    );
  }

  Widget _buildBody(AsyncSnapshot<List<Product>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Ürünler yüklenemedi.\n${snapshot.error}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final products = snapshot.data ?? <Product>[];

    // Categories are generated from API data.
    final categories = [
      'Tümü',
      ...products.map((product) => product.category).toSet(),
    ];

    final filteredProducts = products.where((product) {
      final matchesSearch =
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesCategory =
          _selectedCategory == 'Tümü' || product.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBanner(),
                const SizedBox(height: 20),

                // Search
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Ürün ara...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Kategoriler',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Dynamic categories
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: _selectedCategory == category,
                          onSelected: (_) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Ürünlerimiz (${filteredProducts.length})',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Veri kaynağı: '
                  '${ProductRepository.lastSource}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),

        // Empty search results
        if (filteredProducts.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('Aradığınız ürün bulunamadı.')),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;

                final columns = width >= 700 ? 4 : 2;

                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 255,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = filteredProducts[index];

                    return ProductCard(
                      product: product,
                      onTap: () {
                        _openProductDetail(product);
                      },
                    );
                  }, childCount: filteredProducts.length),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF17365D),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.school_outlined, size: 38, color: Colors.white),
          SizedBox(height: 14),
          Text(
            'Kampüs stilini keşfet!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'AYBÜ ruhunu yansıtan ürünler burada.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
