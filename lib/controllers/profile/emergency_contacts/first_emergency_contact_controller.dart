import 'package:buzz_ai/models/profile/emergency_contact/first_emergency_contact.dart';
import 'package:flutter/material.dart';

class FirstEmergencyContactController extends ChangeNotifier {
  var firstEmergencyContact = const FirstEmergencyContact(contactAdded: false);

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
    firstEmergencyContact = firstEmergencyContact.copyWith(contactAdded: true);
    notifyListeners();
  }

  void setEmergencyContact(String? newValue) {
    firstEmergencyContact =
        firstEmergencyContact.copyWith(contactNumber: newValue);
    notifyListeners();
  }

  void setRelation(String? newValue) {
    firstEmergencyContact = firstEmergencyContact.copyWith(relation: newValue);
    notifyListeners();
  }

  void setName(String? newValue) {
    firstEmergencyContact = firstEmergencyContact.copyWith(name: newValue);
    notifyListeners();
  }
}
