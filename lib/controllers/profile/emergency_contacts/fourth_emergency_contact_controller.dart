import 'package:buzz_ai/models/profile/emergency_contact/first_emergency_contact.dart';
import 'package:buzz_ai/models/profile/emergency_contact/fourth_emergency_contact.dart';
import 'package:flutter/material.dart';

class FourthEmergencyContactController extends ChangeNotifier {
  var fourthEmergencyContact =
      const FourthEmergencyContact(contactAdded: false);

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
  //   fourthEmergencyContact = fourthEmergencyContact.copyWith(
  //     contactAdded: false,
  //   );
  //   notifyListeners();
  // }

  void contactAdded() {
    fourthEmergencyContact =
        fourthEmergencyContact.copyWith(contactAdded: true);
    notifyListeners();
  }

  void setEmergencyContact(String? newValue) {
    fourthEmergencyContact =
        fourthEmergencyContact.copyWith(contactNumber: newValue);
    notifyListeners();
  }

  void setRelation(String? newValue) {
    fourthEmergencyContact =
        fourthEmergencyContact.copyWith(relation: newValue);
    notifyListeners();
  }

  void setName(String? newValue) {
    fourthEmergencyContact = fourthEmergencyContact.copyWith(name: newValue);
    notifyListeners();
  }

  void clear() {
    fourthEmergencyContact = fourthEmergencyContact.copyWith(
      name: "",
      relation: "",
      contactNumber: "",
      contactAdded: false,
    );

    notifyListeners();
  }
}
