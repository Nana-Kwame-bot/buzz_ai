import 'package:buzz_ai/models/profile/contact_detail/contact_detail.dart';
import 'package:get/get.dart';

class ContactDetailController extends GetxController {
  ContactDetail contactDetail = ContactDetail();

  void setAddress({required String address}) {
    contactDetail = contactDetail.copyWith(address: address);
    update();
  }

  void setPhoneNumber({required String phoneNumber}) {
    contactDetail = contactDetail.copyWith(phoneNumber: phoneNumber);
    update();
  }
}
