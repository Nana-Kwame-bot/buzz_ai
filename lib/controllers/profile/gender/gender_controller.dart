import 'package:buzz_ai/models/profile/gender/gender.dart';
import 'package:get/get.dart';

class GenderController extends GetxController {
  Gender? gender = Gender.male;

  void setGender(Gender? value) {
    gender = value;
    update();
  }
}
