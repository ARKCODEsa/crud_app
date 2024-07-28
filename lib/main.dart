import 'package:flutter/material.dart';
import 'package:crud_app/login/Login.dart';
import 'package:crud_app/check_in/check_In.dart';
import 'package:crud_app/products/Product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD App',
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/check_in': (context) => const Check_In(),
        '/products': (context) => const ProductPage(),
        // Add other routes here
      },
    );
  }
}