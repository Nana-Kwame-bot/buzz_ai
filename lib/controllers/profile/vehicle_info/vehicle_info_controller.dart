import 'package:buzz_ai/models/profile/vehicle_info/vehicle_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleInfoController extends GetxController {
  VehicleInfo vehicleInfo = VehicleInfo();

  final vehicleInfoFormKey = GlobalKey<FormState>();

  void validateBasicDetailForms() {
    if (vehicleInfoFormKey.currentState!.validate()) {
      Get.snackbar("", "Saving Data");
    }
  }

  void setOwnerName(String? newValue) {
    vehicleInfo = vehicleInfo.copyWith(ownerName: newValue);
    update();
  }

  void setModel(String? newValue) {
    vehicleInfo = vehicleInfo.copyWith(model: newValue);
    update();
  }

  void setYear(String? newValue) {
    vehicleInfo = vehicleInfo.copyWith(year: newValue);
    update();
  }

  void setPlateNumber(String? newValue) {
    vehicleInfo = vehicleInfo.copyWith(plateNumber: newValue);
    update();
  }
}
