import 'package:buzz_ai/models/profile/gender/gender.dart';
import 'package:flutter/cupertino.dart';

class GenderController extends ChangeNotifier {
  Gender? gender = Gender.male;

  void setGender(Gender? value) {
    gender = value;
    notifyListeners();
  }
}
