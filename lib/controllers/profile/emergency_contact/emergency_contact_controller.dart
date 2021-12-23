import 'package:buzz_ai/models/profile/emergency_contact/emergency_contact.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmergencyContactController extends GetxController {
  var emergencyContact = EmergencyContact().obs;

  final emergencyContactFormKey = GlobalKey<FormState>();

  void validateBasicDetailForms() {
    if (emergencyContactFormKey.currentState!.validate()) {
      emergencyContactFormKey.currentState!.save();
      Get.back();
    }
  }

  void setEmergencyContact(String? newValue) {
    emergencyContact.update((EmergencyContact? val) {
      val!.contactNumber = newValue;
    });
  }

  void setRelation(String? newValue) {
    emergencyContact.update((EmergencyContact? val) {
      val!.relation = newValue;
    });
  }

  void setName(String? newValue) {
    emergencyContact.update((EmergencyContact? val) {
      val!.name = newValue;
    });
  }
}
