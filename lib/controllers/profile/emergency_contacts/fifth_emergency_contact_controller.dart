// ignore_for_file: unused_import

import 'package:buzz_ai/models/profile/emergency_contact/fifth_emergency_contact.dart';
import 'package:buzz_ai/models/profile/emergency_contact/first_emergency_contact.dart';
import 'package:flutter/material.dart';

class FifthEmergencyContactController extends ChangeNotifier {
  var fifthEmergencyContact = const FifthEmergencyContact(contactAdded: false);

  bool isEmergencyContactValid = false;

  void makeValid() {
    isEmergencyContactValid = true;
    notifyListeners();
  }

  void makeInvalid() {
    isEmergencyContactValid = false;
    notifyListeners();
  }

  // void removeContact() {
  //   fifthEmergencyContact = fifthEmergencyContact.copyWith(contactAdded: false);
  //   notifyListeners();
  // }

  void contactAdded() {
    fifthEmergencyContact = fifthEmergencyContact.copyWith(contactAdded: true);
    notifyListeners();
  }

  void setEmergencyContact(String? newValue) {
    fifthEmergencyContact =
        fifthEmergencyContact.copyWith(contactNumber: newValue);
    notifyListeners();
  }

  void setRelation(String? newValue) {
    fifthEmergencyContact = fifthEmergencyContact.copyWith(relation: newValue);
    notifyListeners();
  }

  void setName(String? newValue) {
    fifthEmergencyContact = fifthEmergencyContact.copyWith(name: newValue);
    notifyListeners();
  }

  void clear() {
    fifthEmergencyContact = fifthEmergencyContact.copyWith(
      name: "",
      relation: "",
      contactNumber: "",
      contactAdded: false,
    );

    notifyListeners();
  }
}
