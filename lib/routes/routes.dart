import 'package:buzz_ai/screens/profile_screen/profile_screen.dart';
import 'package:buzz_ai/screens/slpashscreen/splashscrenn.dart';
import 'package:get/get.dart';

abstract class Routes {
  static const INITIAL = '/';
  static const PROFILE = '/profile';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.INITIAL,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileScreen(),
    ),

    // GetPage(name: Routes.APRESENTACAO, page:()=> ApresentacaoPage()),
  ];
}
