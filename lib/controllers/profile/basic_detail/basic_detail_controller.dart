import 'package:buzz_ai/models/profile/basic_detail/basic_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasicDetailController extends GetxController {
  BasicDetail basicDetail = BasicDetail();

  final basicDetailsFormKey = GlobalKey<FormState>();

  void validateBasicDetailForms() {
    if (basicDetailsFormKey.currentState!.validate()) {
      Get.snackbar("", "Saving Data");
    }
  }

  void setFullName(String? newValue) {
    basicDetail = basicDetail.copyWith(fullname: newValue);
    update();
  }

  void setDOB(String? newValue) {
    basicDetail = basicDetail.copyWith(dateOfBirth: newValue);
    update();
  }

  void setWeight(String? newValue) {
    basicDetail = basicDetail.copyWith(weight: int.tryParse(newValue!));
    update();
  }

  void setAge(String? newValue) {
    basicDetail = basicDetail.copyWith(age: int.tryParse(newValue!));
    update();
  }

  void setBloodGroup(String? newValue) {
    basicDetail = basicDetail.copyWith(bloodGroup: newValue);
    update();
  }

  void setLicenseNumber(String? newValue) {
    basicDetail = basicDetail.copyWith(licenseNumber: int.tryParse(newValue!));
    update();
  }
}
