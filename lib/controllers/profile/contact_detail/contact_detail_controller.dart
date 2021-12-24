import 'package:buzz_ai/models/profile/contact_detail/contact_detail.dart';
import 'package:flutter/material.dart';

class ContactDetailController extends ChangeNotifier {
  ContactDetail contactDetail = ContactDetail();

  final contactDetailsFormKey = GlobalKey<FormState>();

  void validateBasicDetailForms() {
    if (contactDetailsFormKey.currentState!.validate()) {}
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
