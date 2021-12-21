import 'package:buzz_ai/models/profile/vehicle_info/vehicle_info.dart';
import 'package:get/get.dart';

class VehicleInfoController extends GetxController {
  VehicleInfo vehicleInfo = VehicleInfo();

  void setOwnerName({required String ownerName}) {
    vehicleInfo = vehicleInfo.copyWith(ownerName: ownerName);
    update();
  }

  void setModel({required String model}) {
    vehicleInfo = vehicleInfo.copyWith(model: model);
    update();
  }

  void setYear({required String year}) {
    vehicleInfo = vehicleInfo.copyWith(year: year);
    update();
  }

  void setPlateNumber({required String plateNumber}) {
    vehicleInfo = vehicleInfo.copyWith(plateNumber: plateNumber);
    update();
  }
}
