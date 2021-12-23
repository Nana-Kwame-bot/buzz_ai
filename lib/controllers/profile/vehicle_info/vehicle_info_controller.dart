import 'package:buzz_ai/models/profile/vehicle_info/vehicle_info.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/multiple_car.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/vehicle_information.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleInfoController extends GetxController {
  VehicleInfo vehicleInfo = VehicleInfo();

  final vehicleInfoFormKey = GlobalKey<FormState>();
  final mutipleCarFormKey = GlobalKey<FormState>();

  List<Widget> multipleCars = [];

  void addMoreCars() {
    multipleCars.add(const VehicleInformation());
    Get.back();
    update();
  }

  void validateMultipleCarForms() {
    if (mutipleCarFormKey.currentState!.validate()) {
      addMoreCars();
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
