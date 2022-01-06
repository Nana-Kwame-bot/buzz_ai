import 'package:flutter/material.dart';
import 'package:buzz_ai/models/report_accident/validation.dart';

class SubmitAccidentReport with ChangeNotifier {
  
  ValidationItem _carNumberPlate = ValidationItem(null, "");
  ValidationItem _numberOfPeopleInjured = ValidationItem(null, "");

  ValidationItem get carNumberPlate => _carNumberPlate;
  ValidationItem get numberOfPeopleInjured => _numberOfPeopleInjured;

  bool get isValid{
    if (_carNumberPlate != null){
      return true;
    }else {
      return false;
    }
  }

  void changeCarNumberPlate(String value) {
    if (value.length >= 3) {
      _carNumberPlate = ValidationItem(value, "");
    } else {
      _carNumberPlate = ValidationItem(null, "This field Is Required");
    }
    notifyListeners();
  }
  void changeNumberOfPeopleInjured(String value) {
    if (value.isNotEmpty) {
      _numberOfPeopleInjured = ValidationItem(value, "");
    } else {
      _numberOfPeopleInjured = ValidationItem(null, "");
    }
  }

}