import 'package:flutter/material.dart';

import 'screens/home_page.dart';
import 'screens/product_detail_page.dart';

void main() {
  runApp(const AybuStoreApp());
}

class AybuStoreApp extends StatelessWidget {
  const AybuStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AYBÜ Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF17365D)),
        scaffoldBackgroundColor: const Color(0xFFF7F8FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF17365D),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const HomePage(),
      onGenerateRoute: (settings) {
        if (settings.name == '/product') {
          final arguments = settings.arguments as ProductDetailArguments;

          return MaterialPageRoute<void>(
            settings: settings,
            builder: (context) => ProductDetailPage(arguments: arguments),
          );
        }

        return null;
      },
    );
  }
}
