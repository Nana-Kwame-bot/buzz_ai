import 'package:buzz_ai/models/profile/emergency_contact/first_emergency_contact.dart';
import 'package:buzz_ai/models/profile/emergency_contact/second_emergency_contact.dart';
import 'package:flutter/material.dart';

class SecondEmergencyContactController extends ChangeNotifier {
  var secondEmergencyContact =
      const SecondEmergencyContact(contactAdded: false);

  bool isEmergencyContactValid = false;

  void makeValid() {
    isEmergencyContactValid = true;
    notifyListeners();
  }

  void makeInvalid() {
    isEmergencyContactValid = false;
    notifyListeners();
  }

  void contactAdded() {
    secondEmergencyContact =
        secondEmergencyContact.copyWith(contactAdded: true);
    notifyListeners();
  }

  // void removeContact() {
  //   secondEmergencyContact = secondEmergencyContact.copyWith(
  //     contactAdded: false,
  //   );
  //   notifyListeners();
  // }

  void setEmergencyContact(String? newValue) {
    secondEmergencyContact =
        secondEmergencyContact.copyWith(contactNumber: newValue);
    notifyListeners();
  }

  void setRelation(String? newValue) {
    secondEmergencyContact =
        secondEmergencyContact.copyWith(relation: newValue);
    notifyListeners();
  }

  void setName(String? newValue) {
    secondEmergencyContact = secondEmergencyContact.copyWith(name: newValue);
    notifyListeners();
  }
}
