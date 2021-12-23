import 'package:buzz_ai/models/profile/emergency_contact/emergency_contact.dart';
import 'package:get/get.dart';

class EmergencyContactController extends GetxController {
  EmergencyContact emergencyContact = EmergencyContact();

  void setName({required String name}) {
    emergencyContact = emergencyContact.copyWith(name: name);
    update();
  }

  void setRelation({required String relation}) {
    emergencyContact = emergencyContact.copyWith(relation: relation);
    update();
  }

  void setContactNumber({required String contactNumber}) {
    emergencyContact = emergencyContact.copyWith(contactNumber: contactNumber);
    update();
  }
}
