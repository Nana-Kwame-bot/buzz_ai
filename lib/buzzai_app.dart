import 'package:buzz_ai/routes/routes.dart';
import 'package:buzz_ai/screens/splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';

class BuzzaiApp extends StatelessWidget {
  const BuzzaiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRouter().onGenerateRoute,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
