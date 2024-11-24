import 'package:flutter/material.dart';
import 'package:resepmakanan/ui/home_screen.dart';
import 'package:resepmakanan/ui/login_screen.dart';
import 'package:resepmakanan/ui/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
