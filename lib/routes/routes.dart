import 'package:buzz_ai/bindings/profile/basic_detail/basic_detail_binding.dart';
import 'package:buzz_ai/bindings/profile/contact_detail/contact_detail_binding.dart';
import 'package:buzz_ai/bindings/profile/emergency_contact/emergency_contact_binding.dart';
import 'package:buzz_ai/bindings/profile/gender/gender_binding.dart';
import 'package:buzz_ai/bindings/profile/vehicle_info/vehicle_info_binding.dart';
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
      bindings: [
        BasicDetailBinding(),
        ContactDetailBinding(),
        EmergencyContactBinding(),
        GenderBinding(),
        VehicleInfoBinding(),
      ],
    ),

    // GetPage(name: Routes.APRESENTACAO, page:()=> ApresentacaoPage()),
  ];
}
