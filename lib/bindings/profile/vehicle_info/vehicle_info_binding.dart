import 'package:buzz_ai/controllers/profile/vehicle_info/vehicle_info_controller.dart';
import 'package:get/get.dart';

class VehicleInfoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() {
      return VehicleInfoController();
    });
  }
}
