
# AYBÜ Store

AYBÜ Store is a Flutter-based mobile product catalog application developed as an educational project.

The application uses a university-themed interface and demonstrates product listing, navigation, JSON parsing, searching, category filtering, and basic shopping cart state management.

**Note:** This is an educational demo and is not an official Ankara Yıldırım Beyazıt University store.

## Technologies

- Flutter 3.38.5
- Dart 3.10.4
- Material Design 3
- Android Studio
- REST APIs
- JSON

## Features

- Product listing with GridView
- Product detail screen
- Navigation using Navigator and Route Arguments
- Product search and category filtering
- Shopping cart simulation
- Quantity management and total price calculation
- Remote API integration
- Automatic API fallback
- Local JSON fallback
- Asset and network image support

## Data Sources

The application tries the following data sources in order:

1. Fake Store API (Primary)
   https://fakestoreapi.com/products

2. DummyJSON (Backup)
   https://dummyjson.com/products?limit=30

3. Local JSON (Fallback)
   assets/data/products.json

If the primary API fails, the application automatically tries the backup API.

If both remote services fail, the application loads local sample products.

Remote APIs contain general demo products. Local JSON contains fictional AYBÜ-themed products.

## Requirements

- Flutter SDK 3.38.5
- Dart SDK 3.10.4
- Android Studio
- Android Emulator or physical Android device

## Installation

Clone the repository:

```bash
git clone https://github.com/kkovaycin/aybu-store.git
```

Navigate to the project:

```bash
cd aybu-store
```

Install dependencies:

```bash
flutter pub get
```

Run on an Android device or emulator:

```bash
flutter run
```

The current HTTP implementation uses dart:io and targets Android and iOS, not Flutter Web.

## Testing

Run static analysis:

```bash
flutter analyze
```

Run unit tests:

```bash
flutter test
```

The existing unit tests validate product model conversions for local JSON, Fake Store API, and DummyJSON.

API fallback behavior was also observed during an Android emulator run.

## Project Structure

```text
lib/
├── main.dart
├── data/
│   └── product_repository.dart
├── models/
│   └── product.dart
├── screens/
│   ├── home_page.dart
│   ├── product_detail_page.dart
│   └── cart_page.dart
└── widgets/
    └── product_card.dart

assets/
├── data/
│   └── products.json
└── images/

test/
└── widget_test.dart
```

## Screenshots

Screenshots are available in the screenshots directory.

- Main product catalog
- Product details
- Shopping cart
- Empty cart

## Disclaimer

AYBÜ Store is an independent educational project. Product prices and content are provided for demonstration purposes only. No real payments or orders are processed.
