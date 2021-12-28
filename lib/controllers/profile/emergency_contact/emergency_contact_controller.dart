import 'package:buzz_ai/models/profile/emergency_contact/emergency_contact.dart';
import 'package:flutter/material.dart';

class EmergencyContactController extends ChangeNotifier {
  var emergencyContact = EmergencyContact();

  void setEmergencyContact(String? newValue) {
    emergencyContact = emergencyContact.copyWith(contactNumber: newValue);
    notifyListeners();
  }

  void setRelation(String? newValue) {
    emergencyContact = emergencyContact.copyWith(relation: newValue);
    notifyListeners();
  }

  void setName(String? newValue) {
    emergencyContact = emergencyContact.copyWith(name: newValue);
    notifyListeners();
  }
}
