import 'package:buzz_ai/models/profile/basic_detail/basic_detail.dart';
import 'package:flutter/material.dart';

class BasicDetailController extends ChangeNotifier {
  var basicDetail = const BasicDetail(imageURL: 'ghjk');
  final basicDetailsFormKey = GlobalKey<FormState>();


  bool validateBasicDetailForms() {
    return basicDetailsFormKey.currentState!.validate();
  }

  void setFullName(String? newValue) {
    basicDetail = basicDetail.copyWith(fullName: newValue);
    notifyListeners();
  }

  void setDOB(String? newValue) {
    basicDetail = basicDetail.copyWith(dateOfBirth: newValue);
    notifyListeners();
  }

  void setWeight(String? newValue) {
    basicDetail = basicDetail.copyWith(weight: int.tryParse(newValue!));
    notifyListeners();
  }

  void setAge(String? newValue) {
    basicDetail = basicDetail.copyWith(age: int.tryParse(newValue!));
    notifyListeners();
  }

  void setBloodGroup(String? newValue) {
    basicDetail = basicDetail.copyWith(bloodGroup: newValue);
    notifyListeners();
  }

  void setLicenseNumber(String? newValue) {
    basicDetail = basicDetail.copyWith(licenseNumber: int.tryParse(newValue!));
    notifyListeners();
  }
}
