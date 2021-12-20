import 'package:buzz_ai/screens/slpashscreen/splashscrenn.dart';
import 'package:get/get.dart';

abstract class Routes {
  static const INITIAL = '/';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.INITIAL,
      page: () => const SplashScreen(),
    ),

    // GetPage(name: Routes.APRESENTACAO, page:()=> ApresentacaoPage()),
  ];
}
