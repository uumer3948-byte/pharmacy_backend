import 'package:flutter/material.dart';
import 'screens/pos_screen.dart';

void main() {
  runApp(const PharmacyApp());
}

class PharmacyApp extends StatelessWidget {
  const PharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fanar Pharmacy POS",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const POSScreen(),
    );
  }
}