import 'package:buzz_ai/models/profile/basic_detail/basic_detail.dart';
import 'package:buzz_ai/models/profile/gender/gender.dart';
import 'package:get/get.dart';

class BasicDetailController extends GetxController {
  BasicDetail basicDetail = BasicDetail();

  void setFullName({required String fullname}) {
    basicDetail = basicDetail.copyWith(fullname: fullname);
    update();
  }

  void setDOB({required String dateOfBirth}) {
    basicDetail = basicDetail.copyWith(dateOfBirth: dateOfBirth);
    update();
  }

  void setWeight({required int weight}) {
    basicDetail = basicDetail.copyWith(weight: weight);
    update();
  }

  void setGender({required Gender gender}) {
    basicDetail = basicDetail.copyWith(gender: gender);
    update();
  }

  void setAge({required int age}) {
    basicDetail = basicDetail.copyWith(age: age);
    update();
  }

  void setBloodGroup({required String bloodGroup}) {
    basicDetail = basicDetail.copyWith(bloodGroup: bloodGroup);
    update();
  }

  void setLicenseNumber({required int licenseNumber}) {
    basicDetail = basicDetail.copyWith(licenseNumber: licenseNumber);
    update();
  }
}
