import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductRepository {
  static const String primaryApi = 'https://fakestoreapi.com/products';

  static const String backupApi = 'https://dummyjson.com/products?limit=30';

  static String lastSource = 'Henüz yüklenmedi';

  static Future<String> _fetchJson(String url) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 6);

    try {
      final uri = Uri.parse(url);

      final request = await client
          .getUrl(uri)
          .timeout(const Duration(seconds: 7));

      final response = await request.close().timeout(
        const Duration(seconds: 7),
      );

      if (response.statusCode != HttpStatus.ok) {
        throw HttpException('HTTP ${response.statusCode}', uri: uri);
      }

      return await response
          .transform(utf8.decoder)
          .join()
          .timeout(const Duration(seconds: 7));
    } finally {
      client.close(force: true);
    }
  }

  static Future<List<Product>> loadProducts() async {
    // Primary remote API
    try {
      debugPrint('Primary API: Fake Store');

      final response = await _fetchJson(primaryApi);
      final decoded = jsonDecode(response) as List<dynamic>;

      final products = decoded.map((item) {
        return Product.fromFakeStore(item as Map<String, dynamic>);
      }).toList();

      if (products.isEmpty) {
        throw const FormatException('Empty product list');
      }

      lastSource = 'Fake Store API';
      debugPrint('Data source: $lastSource');

      return products;
    } catch (error) {
      debugPrint('Primary API failed: $error');
    }

    // Backup remote API
    try {
      debugPrint('Backup API: DummyJSON');

      final response = await _fetchJson(backupApi);

      final decoded = jsonDecode(response) as Map<String, dynamic>;

      final data = decoded['products'] as List<dynamic>;

      final products = data.map((item) {
        return Product.fromDummyJson(item as Map<String, dynamic>);
      }).toList();

      if (products.isEmpty) {
        throw const FormatException('Empty product list');
      }

      lastSource = 'DummyJSON';
      debugPrint('Data source: $lastSource');

      return products;
    } catch (error) {
      debugPrint('Backup API failed: $error');
    }

    // Local fallback
    debugPrint('Loading local products.json');

    final jsonString = await rootBundle.loadString('assets/data/products.json');

    final decoded = jsonDecode(jsonString) as List<dynamic>;

    final products = decoded.map((item) {
      return Product.fromJson(item as Map<String, dynamic>);
    }).toList();

    lastSource = 'Yerel JSON';
    debugPrint('Data source: $lastSource');

    return products;
  }
}
