import 'package:buzz_ai/controllers/profile/basic_detail/basic_detail_controller.dart';
import 'package:get/get.dart';

class BasicDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() {
      return BasicDetailController();
    });
  }
}
