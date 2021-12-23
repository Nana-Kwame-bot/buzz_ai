import 'package:buzz_ai/controllers/profile/emergency_contact/emergency_contact_controller.dart';
import 'package:get/get.dart';

class EmergencyContactBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () {
        return EmergencyContactController();
      },
      fenix: true,
    );
  }
}
