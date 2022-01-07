import 'package:flutter/material.dart';
import 'package:buzz_ai/models/report_accident/validation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SubmitAccidentReport with ChangeNotifier {
  
  ValidationItem _carNumberPlate = ValidationItem(null, "");
  ValidationItem _numberOfPeopleInjured = ValidationItem(null, "");

  ValidationItem get carNumberPlate => _carNumberPlate;
  ValidationItem get numberOfPeopleInjured => _numberOfPeopleInjured;

  // bool get isValid{
  //   if (_carNumberPlate != null){
  //     return true;
  //   }else {
  //     return false;
  //   }
  // }

  changeCarNumberPlate(String value) {
    if (value.length >= 3) {
      _carNumberPlate = ValidationItem(value, "");
    } else {
      Fluttertoast.showToast(
        msg: "You must input carPlateNumber",
      );    }
    notifyListeners();
  }
  changeNumberOfPeopleInjured(String value) {
    if (value.isNotEmpty) {
      _numberOfPeopleInjured = ValidationItem(value, "");
    } else {
      _numberOfPeopleInjured = ValidationItem(null, "");
    }
  }

}