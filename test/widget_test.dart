import 'package:flutter_test/flutter_test.dart';

import 'package:aybu_store/models/product.dart';

void main() {
  test('Local JSON product conversion', () {
    final json = {
      'id': 1,
      'name': 'AYBÜ Sweatshirt',
      'description': 'University sweatshirt',
      'category': 'Giyim',
      'price': 799.90,
      'image': 'assets/images/sweatshirt.png',
    };

    final product = Product.fromJson(json);

    expect(product.id, 1);
    expect(product.name, 'AYBÜ Sweatshirt');
    expect(product.price, 799.90);
    expect(product.currency, 'TL');

    final converted = product.toJson();

    expect(converted['name'], 'AYBÜ Sweatshirt');
    expect(converted['price'], 799.90);
  });

  test('Fake Store product conversion', () {
    final json = {
      'id': 2,
      'title': 'Backpack',
      'description': 'A demo backpack',
      'category': 'bags',
      'price': 59.99,
      'image': 'https://example.com/bag.png',
    };

    final product = Product.fromFakeStore(json);

    expect(product.name, 'Backpack');
    expect(product.price, 59.99);
    expect(product.currency, 'USD');
  });

  test('DummyJSON product conversion', () {
    final json = {
      'id': 3,
      'title': 'Headphones',
      'description': 'Wireless headphones',
      'category': 'electronics',
      'price': 89.99,
      'thumbnail': 'https://example.com/headphones.png',
    };

    final product = Product.fromDummyJson(json);

    expect(product.name, 'Headphones');
    expect(product.price, 89.99);
    expect(product.currency, 'USD');
  });
}
