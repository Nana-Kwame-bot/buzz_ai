import 'package:buzz_ai/models/profile/basic_detail/basic_detail.dart';
import 'package:buzz_ai/models/profile/contact_detail/contact_detail.dart';
import 'package:buzz_ai/models/profile/emergency_contact/fifth_emergency_contact.dart';
import 'package:buzz_ai/models/profile/emergency_contact/first_emergency_contact.dart';
import 'package:buzz_ai/models/profile/emergency_contact/fourth_emergency_contact.dart';
import 'package:buzz_ai/models/profile/emergency_contact/second_emergency_contact.dart';
import 'package:buzz_ai/models/profile/emergency_contact/third_emergency_contact.dart';
import 'package:buzz_ai/models/profile/gender/gender.dart';
import 'package:buzz_ai/models/profile/multiple_vehicle/multiple_vehicle.dart';
import 'package:buzz_ai/models/profile/vehicle_info/vehicle_info.dart';

class UserProfile {
  final BasicDetail? basicDetail;
  final ContactDetail? contactDetail;
  final FirstEmergencyContact? firstEmergencyContact;
  final SecondEmergencyContact? secondEmergencyContact;
  final ThirdEmergencyContact? thirdEmergencyContact;
  final FourthEmergencyContact? fourthEmergencyContact;
  final FifthEmergencyContact? fifthEmergencyContact;
  final Gender? gender;
  final MultipleVehicle? multipleVehicle;
  final VehicleInfo? vehicleInfo;

//<editor-fold desc="Data Methods">

  const UserProfile({
    this.basicDetail,
    this.contactDetail,
    this.firstEmergencyContact,
    this.secondEmergencyContact,
    this.thirdEmergencyContact,
    this.fourthEmergencyContact,
    this.fifthEmergencyContact,
    this.gender,
    this.multipleVehicle,
    this.vehicleInfo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          runtimeType == other.runtimeType &&
          basicDetail == other.basicDetail &&
          contactDetail == other.contactDetail &&
          firstEmergencyContact == other.firstEmergencyContact &&
          secondEmergencyContact == other.secondEmergencyContact &&
          thirdEmergencyContact == other.thirdEmergencyContact &&
          fourthEmergencyContact == other.fourthEmergencyContact &&
          fifthEmergencyContact == other.fifthEmergencyContact &&
          gender == other.gender &&
          multipleVehicle == other.multipleVehicle &&
          vehicleInfo == other.vehicleInfo);

  @override
  int get hashCode =>
      basicDetail.hashCode ^
      contactDetail.hashCode ^
      firstEmergencyContact.hashCode ^
      secondEmergencyContact.hashCode ^
      thirdEmergencyContact.hashCode ^
      fourthEmergencyContact.hashCode ^
      fifthEmergencyContact.hashCode ^
      gender.hashCode ^
      multipleVehicle.hashCode ^
      vehicleInfo.hashCode;

  @override
  String toString() {
    return 'UserProfile{' +
        ' basicDetail: $basicDetail,' +
        ' contactDetail: $contactDetail,' +
        ' emergencyContact: $firstEmergencyContact,' +
        ' emergencyContact: $secondEmergencyContact,' +
        ' emergencyContact: $thirdEmergencyContact,' +
        ' emergencyContact: $fourthEmergencyContact,' +
        ' emergencyContact: $fifthEmergencyContact,' +
        ' gender: $gender,' +
        ' multipleVehicle: $multipleVehicle,' +
        ' vehicleInfo: $vehicleInfo,' +
        '}';
  }

  UserProfile copyWith({
    BasicDetail? basicDetail,
    ContactDetail? contactDetail,
    FirstEmergencyContact? firstEmergencyContact,
    SecondEmergencyContact? secondEmergencyContact,
    ThirdEmergencyContact? thirdEmergencyContact,
    FourthEmergencyContact? fourthEmergencyContact,
    FifthEmergencyContact? fifthEmergencyContact,
    Gender? gender,
    MultipleVehicle? multipleVehicle,
    VehicleInfo? vehicleInfo,
  }) {
    return UserProfile(
      basicDetail: basicDetail ?? this.basicDetail,
      contactDetail: contactDetail ?? this.contactDetail,
      firstEmergencyContact:
          firstEmergencyContact ?? this.firstEmergencyContact,
      secondEmergencyContact:
          secondEmergencyContact ?? this.secondEmergencyContact,
      thirdEmergencyContact:
          thirdEmergencyContact ?? this.thirdEmergencyContact,
      fourthEmergencyContact:
          fourthEmergencyContact ?? this.fourthEmergencyContact,
      fifthEmergencyContact:
          fifthEmergencyContact ?? this.fifthEmergencyContact,
      gender: gender ?? this.gender,
      multipleVehicle: multipleVehicle ?? this.multipleVehicle,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'basicDetail': basicDetail?.toMap(),
      'contactDetail': contactDetail?.toMap(),
      'firstEmergencyContact': firstEmergencyContact?.toMap(),
      'secondEmergencyContact': secondEmergencyContact?.toMap(),
      'thirdEmergencyContact': thirdEmergencyContact?.toMap(),
      'fourthEmergencyContact': fourthEmergencyContact?.toMap(),
      'fifthEmergencyContact': fifthEmergencyContact?.toMap(),
      'gender': gender.toString(),
      'multipleVehicle': multipleVehicle?.toMap(),
      'vehicleInfo': vehicleInfo?.toMap(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    final genderString = map['gender'] as String;
    var gender = genderString.substring(
      genderString.lastIndexOf(".") + 1,
      genderString.length,
    );
    return UserProfile(
      basicDetail: BasicDetail.fromMap(map['basicDetail']),
      contactDetail: ContactDetail.fromMap(map['contactDetail']),
      firstEmergencyContact:
          FirstEmergencyContact.fromMap(map['firstEmergencyContact']),
      secondEmergencyContact:
          SecondEmergencyContact.fromMap(map['secondEmergencyContact']),
      thirdEmergencyContact:
          ThirdEmergencyContact.fromMap(map['thirdEmergencyContact']),
      fourthEmergencyContact:
          FourthEmergencyContact.fromMap(map['fourthEmergencyContact']),
      fifthEmergencyContact:
          FifthEmergencyContact.fromMap(map['fifthEmergencyContact']),
      gender: Gender.values.byName(gender),
      multipleVehicle: MultipleVehicle.fromMap(map['multipleVehicle']),
      vehicleInfo: VehicleInfo.fromMap(map['vehicleInfo']),
    );
  }

//</editor-fold>
}
