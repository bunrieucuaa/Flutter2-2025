import 'package:flutter/material.dart';
import 'presentation/widgets/bottom_nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RBC Smart AIoT',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BottomNav(),
    );
  }
}
