import 'dart:convert';
import 'dart:developer';
import 'package:buzz_ai/controllers/profile/basic_detail/basic_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/contact_detail/contact_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contact/emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/multiple_car/multiple_car_controller.dart';
import 'package:buzz_ai/controllers/profile/vehicle_info/vehicle_info_controller.dart';
import 'package:buzz_ai/models/profile/basic_detail/basic_detail.dart';
import 'package:buzz_ai/models/profile/contact_detail/contact_detail.dart';
import 'package:buzz_ai/models/profile/emergency_contact/emergency_contact.dart';
import 'package:buzz_ai/models/profile/gender/gender.dart';
import 'package:buzz_ai/models/profile/multiple_vehicle/multiple_vehicle.dart';
import 'package:buzz_ai/models/profile/user_profile/user_profile.dart';
import 'package:buzz_ai/models/profile/vehicle_info/vehicle_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileController extends ChangeNotifier {
  UserProfile userProfile = const UserProfile();
  FirebaseDatabase database = FirebaseDatabase.instance;
  Gender? gender = Gender.male;
  bool formEnabled = false;

  bool isBasicDetailValid = false;
  bool isContactDetailValid = false;
  bool isVehicleFormValid = false;

  void getBasicDetailValid(bool? value) {
    isBasicDetailValid = value ?? false;
    notifyListeners();
  }

  void getContactDetailValid(bool? value) {
    isContactDetailValid = value ?? false;
    notifyListeners();
  }

  void getVehicleFormValid(bool? value) {
    isVehicleFormValid = value ?? false;
    notifyListeners();
  }

  void changeFormState() {
    formEnabled = !formEnabled;
    notifyListeners();
  }

  void setGender(Gender? value) {
    gender = value;
    notifyListeners();
  }

  bool validateForms({required BuildContext context}) {
    if (Provider.of<BasicDetailController>(context, listen: false)
            .isBasicDetailValid &&
        Provider.of<ContactDetailController>(context, listen: false)
            .isContactDetailValid &&
        Provider.of<VehicleInfoController>(context, listen: false)
            .isVehicleInfoValid) {
      return true;
    }
    return false;
  }

  UserProfile setProfileData({
    required BasicDetail basicDetail,
    required ContactDetail contactDetail,
    required EmergencyContact emergencyContact,
    required Gender gender,
    required MultipleVehicle multipleVehicle,
    required VehicleInfo vehicleInfo,
  }) {
    userProfile = userProfile.copyWith(
      basicDetail: basicDetail,
      contactDetail: contactDetail,
      emergencyContact: emergencyContact,
      gender: gender,
      multipleVehicle: multipleVehicle,
      vehicleInfo: vehicleInfo,
    );

    return userProfile;
  }

  void getBasicDetail(BasicDetail basicDetail, BuildContext context) {
    var basicDetailController = context.read<BasicDetailController>();
    basicDetailController.basicDetail =
        basicDetailController.basicDetail.copyWith(
      imageURL: basicDetail.imageURL,
      fullName: basicDetail.fullName,
      dateOfBirth: basicDetail.dateOfBirth,
      weight: basicDetail.weight,
      age: basicDetail.age,
      bloodGroup: basicDetail.bloodGroup,
      licenseNumber: basicDetail.licenseNumber,
    );
  }

  void getContactDetail(ContactDetail contactDetail, BuildContext context) {
    var contactDetailController = context.read<ContactDetailController>();
    contactDetailController.contactDetail =
        contactDetailController.contactDetail.copyWith(
      address: contactDetail.address,
      phoneNumber: contactDetail.phoneNumber,
    );
  }

  void getEmergencyContact(
      EmergencyContact emergencyContact, BuildContext context) {
    var emergencyContactController = context.read<EmergencyContactController>();

    emergencyContactController.emergencyContact =
        emergencyContactController.emergencyContact.copyWith(
      name: emergencyContact.name,
      relation: emergencyContact.relation,
      contactNumber: emergencyContact.contactNumber,
      contactAdded: emergencyContact.contactAdded,
    );
  }

  void getMultipleVehicle(
      MultipleVehicle multipleVehicle, BuildContext context) {
    var multipleVehicleController = context.read<MultipleVehicleController>();
    multipleVehicleController.multipleVehicle =
        multipleVehicleController.multipleVehicle.copyWith(
      ownerName: multipleVehicle.ownerName,
      model: multipleVehicle.model,
      year: multipleVehicle.year,
      plateNumber: multipleVehicle.plateNumber,
      added: multipleVehicle.added,
    );
  }

  void getVehicleInfo(VehicleInfo vehicleInfo, BuildContext context) {
    var vehicleInfoController = context.read<VehicleInfoController>();
    vehicleInfoController.vehicleInfo =
        vehicleInfoController.vehicleInfo.copyWith(
      ownerName: vehicleInfo.ownerName,
      model: vehicleInfo.model,
      year: vehicleInfo.year,
      plateNumber: vehicleInfo.plateNumber,
    );
  }

  void setPersistence() {
    database.setPersistenceEnabled(true);
    notifyListeners();
  }

  Future<UserProfile> readProfileData(
      {required String userId, required BuildContext context}) async {
    DatabaseReference ref = database.ref("users/$userId");
    Map<String, dynamic>? data;

    try {
      final DataSnapshot? snapShot = await ref.get();
      data = jsonDecode(jsonEncode(snapShot?.value));
    } on Exception catch (e) {
      log(e.toString());
    }

    if (data != null) {
      log(data.toString());
      log('data is not null');
      userProfile = UserProfile.fromMap(data);
      getBasicDetail(userProfile.basicDetail!, context);
      getContactDetail(userProfile.contactDetail!, context);
      getEmergencyContact(userProfile.emergencyContact!, context);
      getMultipleVehicle(userProfile.multipleVehicle!, context);
      getVehicleInfo(userProfile.vehicleInfo!, context);
      setGender(userProfile.gender);
      notifyListeners();
    } else {
      log('data is null');
    }
    return userProfile;
  }
}
