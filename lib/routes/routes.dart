import 'package:buzz_ai/screens/login/loginscreen.dart';
import 'package:buzz_ai/screens/profile_screen/profile_screen.dart';
import 'package:buzz_ai/screens/splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case SplashScreen.iD:
        return MaterialPageRoute(builder: (context) {
          return const SplashScreen();
        });
      case LoginScreen.iD:
        return MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        });
      case ProfileScreen.iD:
        return MaterialPageRoute(builder: (context) {
          return const ProfileScreen();
        });
      default:
        return MaterialPageRoute(builder: (context) {
          return const Text("You should probably not be passing null");
        });
    }
  }
}
