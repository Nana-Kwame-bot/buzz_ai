import 'package:buzz_ai/models/profile/vehicle_info/vehicle_info.dart';
import 'package:flutter/material.dart';

class VehicleInfoController extends ChangeNotifier {
  VehicleInfo vehicleInfo = const VehicleInfo();
  final vehicleInfoFormKey = GlobalKey<FormState>();

  bool validateVehicleForms() {
    return vehicleInfoFormKey.currentState!.validate();
  }

  void setOwnerName(String? newValue) {
    vehicleInfo = vehicleInfo.copyWith(ownerName: newValue);
    notifyListeners();
  }

  void setModel(String? newValue) {
    vehicleInfo = vehicleInfo.copyWith(model: newValue);
    notifyListeners();
  }

  void setYear(String? newValue) {
    vehicleInfo = vehicleInfo.copyWith(year: newValue);
    notifyListeners();
  }

  void setPlateNumber(String? newValue) {
    vehicleInfo = vehicleInfo.copyWith(plateNumber: newValue);
    notifyListeners();
  }
}
