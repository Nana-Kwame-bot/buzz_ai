import 'package:buzz_ai/models/profile/vehicle_info/vehicle_info.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/vehicle_information.dart';
import 'package:flutter/material.dart';

class VehicleInfoController extends ChangeNotifier {
  VehicleInfo vehicleInfo = VehicleInfo();

  final vehicleInfoFormKey = GlobalKey<FormState>();
  final mutipleCarFormKey = GlobalKey<FormState>();

  List<Widget> multipleCars = [];

  void addMoreCars() {
    multipleCars.add(const VehicleInformation());

    notifyListeners();
  }

  void validateMultipleCarForms() {
    if (mutipleCarFormKey.currentState!.validate()) {
      addMoreCars();
    }
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
