import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:buzz_ai/controllers/profile/basic_detail/basic_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/contact_detail/contact_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/fifth_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/first_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/fourth_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/second_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/third_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/multiple_car/multiple_car_controller.dart';
import 'package:buzz_ai/controllers/profile/vehicle_info/vehicle_info_controller.dart';
import 'package:buzz_ai/models/profile/basic_detail/basic_detail.dart';
import 'package:buzz_ai/models/profile/contact_detail/contact_detail.dart';
import 'package:buzz_ai/models/profile/emergency_contact/fifth_emergency_contact.dart';
import 'package:buzz_ai/models/profile/emergency_contact/first_emergency_contact.dart';
import 'package:buzz_ai/models/profile/emergency_contact/fourth_emergency_contact.dart';
import 'package:buzz_ai/models/profile/emergency_contact/second_emergency_contact.dart';
import 'package:buzz_ai/models/profile/emergency_contact/third_emergency_contact.dart';
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

  void disableForms() {
    formEnabled = false;
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

  Future<bool> validateEmergency({required BuildContext context}) async {
    if (Provider.of<FirstEmergencyContactController>(context, listen: false)
        .firstEmergencyContact
        .contactAdded!) {
      return true;
    }
    return false;
  }

  Future<bool> validateForms({required BuildContext context}) async {
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
    required FirstEmergencyContact firstEmergencyContact,
    required SecondEmergencyContact secondEmergencyContact,
    required ThirdEmergencyContact thirdEmergencyContact,
    required FourthEmergencyContact fourthEmergencyContact,
    required FifthEmergencyContact fifthEmergencyContact,
    required Gender gender,
    required MultipleVehicle multipleVehicle,
    required VehicleInfo vehicleInfo,
  }) {
    userProfile = userProfile.copyWith(
      basicDetail: basicDetail,
      contactDetail: contactDetail,
      firstEmergencyContact: firstEmergencyContact,
      secondEmergencyContact: secondEmergencyContact,
      thirdEmergencyContact: thirdEmergencyContact,
      fourthEmergencyContact: fourthEmergencyContact,
      fifthEmergencyContact: fifthEmergencyContact,
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

  void getFirstEmergencyContact(
      FirstEmergencyContact firstEmergencyContact, BuildContext context) {
    var firstEmergencyContactController =
        context.read<FirstEmergencyContactController>();

    firstEmergencyContactController.firstEmergencyContact =
        firstEmergencyContactController.firstEmergencyContact.copyWith(
      name: firstEmergencyContact.name,
      relation: firstEmergencyContact.relation,
      contactNumber: firstEmergencyContact.contactNumber,
      contactAdded: firstEmergencyContact.contactAdded,
    );
  }

  void getSecondEmergencyContact(
      SecondEmergencyContact secondEmergencyContact, BuildContext context) {
    var secondEmergencyContactController =
        context.read<SecondEmergencyContactController>();

    secondEmergencyContactController.secondEmergencyContact =
        secondEmergencyContactController.secondEmergencyContact.copyWith(
      name: secondEmergencyContact.name,
      relation: secondEmergencyContact.relation,
      contactNumber: secondEmergencyContact.contactNumber,
      contactAdded: secondEmergencyContact.contactAdded,
    );
  }

  void getThirdEmergencyContact(
      ThirdEmergencyContact thirdEmergencyContact, BuildContext context) {
    var thirdEmergencyContactController =
        context.read<ThirdEmergencyContactController>();

    thirdEmergencyContactController.thirdEmergencyContact =
        thirdEmergencyContactController.thirdEmergencyContact.copyWith(
      name: thirdEmergencyContact.name,
      relation: thirdEmergencyContact.relation,
      contactNumber: thirdEmergencyContact.contactNumber,
      contactAdded: thirdEmergencyContact.contactAdded,
    );
  }

  void getFourthEmergencyContact(
      FourthEmergencyContact fourthEmergencyContact, BuildContext context) {
    var fourthEmergencyContactController =
        context.read<FourthEmergencyContactController>();

    fourthEmergencyContactController.fourthEmergencyContact =
        fourthEmergencyContactController.fourthEmergencyContact.copyWith(
      name: fourthEmergencyContact.name,
      relation: fourthEmergencyContact.relation,
      contactNumber: fourthEmergencyContact.contactNumber,
      contactAdded: fourthEmergencyContact.contactAdded,
    );
  }

  void getFifthEmergencyContact(
      FifthEmergencyContact fifthEmergencyContact, BuildContext context) {
    var fifthEmergencyContactController =
        context.read<FifthEmergencyContactController>();

    fifthEmergencyContactController.fifthEmergencyContact =
        fifthEmergencyContactController.fifthEmergencyContact.copyWith(
      name: fifthEmergencyContact.name,
      relation: fifthEmergencyContact.relation,
      contactNumber: fifthEmergencyContact.contactNumber,
      contactAdded: fifthEmergencyContact.contactAdded,
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
      getFirstEmergencyContact(userProfile.firstEmergencyContact!, context);
      getSecondEmergencyContact(userProfile.secondEmergencyContact!, context);
      getThirdEmergencyContact(userProfile.thirdEmergencyContact!, context);
      getFourthEmergencyContact(userProfile.fourthEmergencyContact!, context);
      getFifthEmergencyContact(userProfile.fifthEmergencyContact!, context);
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
