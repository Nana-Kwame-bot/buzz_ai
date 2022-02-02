import 'package:buzz_ai/models/profile/emergency_contact/first_emergency_contact.dart';
import 'package:buzz_ai/models/profile/emergency_contact/third_emergency_contact.dart';
import 'package:flutter/material.dart';

class ThirdEmergencyContactController extends ChangeNotifier {
  var thirdEmergencyContact = const ThirdEmergencyContact(contactAdded: false);

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
  //   thirdEmergencyContact = thirdEmergencyContact.copyWith(
  //     contactAdded: false,
  //   );
  //   notifyListeners();
  // }

  void contactAdded() {
    thirdEmergencyContact = thirdEmergencyContact.copyWith(contactAdded: true);
    notifyListeners();
  }

  void setEmergencyContact(String? newValue) {
    thirdEmergencyContact =
        thirdEmergencyContact.copyWith(contactNumber: newValue);
    notifyListeners();
  }

  void setRelation(String? newValue) {
    thirdEmergencyContact = thirdEmergencyContact.copyWith(relation: newValue);
    notifyListeners();
  }

  void setName(String? newValue) {
    thirdEmergencyContact = thirdEmergencyContact.copyWith(name: newValue);
    notifyListeners();
  }

  void clear() {
    thirdEmergencyContact = thirdEmergencyContact.copyWith(
      name: "",
      relation: "",
      contactNumber: "",
      contactAdded: false,
    );

    notifyListeners();
  }
}
