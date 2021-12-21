import 'package:buzz_ai/controllers/profile/contact_detail/contact_detail_controller.dart';
import 'package:get/get.dart';

class ContactDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() {
      return ContactDetailController();
    });
  }
}
