import 'package:buzz_ai/models/profile/contact_detail/contact_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactDetailController extends GetxController {
  ContactDetail contactDetail = ContactDetail();

  final contactDetailsFormKey = GlobalKey<FormState>();

  void validateBasicDetailForms() {
    if (contactDetailsFormKey.currentState!.validate()) {
      Get.snackbar("", "Saving Data");
    }
  }

  void setAddress(String? newValue) {
    contactDetail = contactDetail.copyWith(address: newValue);
    update();
  }

  void setPhoneNumber(String? newValue) {
    contactDetail = contactDetail.copyWith(phoneNumber: newValue);
    update();
  }
}
