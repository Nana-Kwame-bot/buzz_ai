import 'package:buzz_ai/models/profile/contact_detail/contact_detail.dart';
import 'package:flutter/material.dart';

class ContactDetailController extends ChangeNotifier {
  ContactDetail contactDetail = const ContactDetail();

  bool isContactDetailValid = false;

  void makeValid() {
    isContactDetailValid = true;
    notifyListeners();
  }

  void makeInvalid() {
    isContactDetailValid = false;
    notifyListeners();
  }

  void setAddress(String? newValue) {
    contactDetail = contactDetail.copyWith(address: newValue);
    notifyListeners();
  }

  void setPhoneNumber(String? newValue) {
    contactDetail = contactDetail.copyWith(phoneNumber: newValue);
    notifyListeners();
  }
}
