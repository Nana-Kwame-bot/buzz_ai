import 'package:buzz_ai/controllers/profile/gender/gender_controller.dart';
import 'package:get/get.dart';

class GenderBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() {
      return GenderController();
    });
  }
}
