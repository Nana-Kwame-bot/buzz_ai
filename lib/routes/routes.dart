import 'package:buzz_ai/screens/splashscreen/splashscreen.dart';
import 'package:get/get.dart';

abstract class Routes {
  static const INITIAL = '/';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.INITIAL,
      page: () => SplashScreen(),
    ),

    // GetPage(name: Routes.APRESENTACAO, page:()=> ApresentacaoPage()),
  ];
}
