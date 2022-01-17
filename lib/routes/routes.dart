import 'package:buzz_ai/routes/screen_arguments/profile_screen_arguments.dart';
import 'package:buzz_ai/screens/bottom_navigation/bottom_navigation.dart';
import 'package:buzz_ai/screens/login/loginscreen.dart';
import 'package:buzz_ai/screens/profile_screen/profile_screen.dart';
import 'package:buzz_ai/screens/splashscreen/splashscreen.dart';
import 'package:buzz_ai/screens/verification_screen/verification_screen.dart';
import 'package:buzz_ai/screens/accidentreport_screen/accidentreport_screen.dart';
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
        final profileArgs = routeSettings.arguments as ProfileScreenArguments;
        return MaterialPageRoute(builder: (context) {
          return ProfileScreen(
            isFromSignUp: profileArgs.isFromSignUp,
          );
        });
      case VerificationScreen.iD:
        return MaterialPageRoute(builder: (context) {
          return const VerificationScreen();
        });

      case AccidentReportScreen.iD:
        return MaterialPageRoute(builder: (context) {
          return const AccidentReportScreen();
        });
      case BottomNavigation.iD:
        return MaterialPageRoute(builder: (context) {
          return const BottomNavigation();
        });
      default:
        return MaterialPageRoute(builder: (context) {
          return const Text("You should probably not be passing null");
        });
    }
  }
}
