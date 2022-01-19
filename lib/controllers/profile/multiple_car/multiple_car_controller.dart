import 'package:buzz_ai/models/profile/multiple_vehicle/multiple_vehicle.dart';
import 'package:flutter/cupertino.dart';

class MultipleVehicleController extends ChangeNotifier {
  var multipleVehicle = const MultipleVehicle();

  void onStart() {
    multipleVehicle = multipleVehicle.copyWith(added: false);
    notifyListeners();
  }

  void added() {
    multipleVehicle = multipleVehicle.copyWith(added: true);
    notifyListeners();
  }

  void setOwnerName(String? newValue) {
    multipleVehicle = multipleVehicle.copyWith(ownerName: newValue);
    notifyListeners();
  }

  void setModel(String? newValue) {
    multipleVehicle = multipleVehicle.copyWith(model: newValue);
    notifyListeners();
  }

  void setYear(String? newValue) {
    multipleVehicle = multipleVehicle.copyWith(year: newValue);
    notifyListeners();
  }

  void setPlateNumber(String? newValue) {
    multipleVehicle = multipleVehicle.copyWith(plateNumber: newValue);
    notifyListeners();
  }
}
