import 'package:buzz_ai/models/profile/basic_detail/basic_detail.dart';
import 'package:buzz_ai/models/profile/contact_detail/contact_detail.dart';
import 'package:buzz_ai/models/profile/emergency_contact/emergency_contact.dart';
import 'package:buzz_ai/models/profile/gender/gender.dart';
import 'package:buzz_ai/models/profile/multiple_vehicle/multiple_vehicle.dart';
import 'package:buzz_ai/models/profile/vehicle_info/vehicle_info.dart';

class UserProfile {
  final BasicDetail? basicDetail;
  final ContactDetail? contactDetail;
  final EmergencyContact? emergencyContact;
  final Gender? gender;
  final MultipleVehicle? multipleVehicle;
  final VehicleInfo? vehicleInfo;

//<editor-fold desc="Data Methods">

  const UserProfile({
    this.basicDetail,
    this.contactDetail,
    this.emergencyContact,
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
          emergencyContact == other.emergencyContact &&
          gender == other.gender &&
          multipleVehicle == other.multipleVehicle &&
          vehicleInfo == other.vehicleInfo);

  @override
  int get hashCode =>
      basicDetail.hashCode ^
      contactDetail.hashCode ^
      emergencyContact.hashCode ^
      gender.hashCode ^
      multipleVehicle.hashCode ^
      vehicleInfo.hashCode;

  @override
  String toString() {
    return 'UserProfile{' +
        ' basicDetail: $basicDetail,' +
        ' contactDetail: $contactDetail,' +
        ' emergencyContact: $emergencyContact,' +
        ' gender: $gender,' +
        ' multipleVehicle: $multipleVehicle,' +
        ' vehicleInfo: $vehicleInfo,' +
        '}';
  }

  UserProfile copyWith({
    BasicDetail? basicDetail,
    ContactDetail? contactDetail,
    EmergencyContact? emergencyContact,
    Gender? gender,
    MultipleVehicle? multipleVehicle,
    VehicleInfo? vehicleInfo,
  }) {
    return UserProfile(
      basicDetail: basicDetail ?? this.basicDetail,
      contactDetail: contactDetail ?? this.contactDetail,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      gender: gender ?? this.gender,
      multipleVehicle: multipleVehicle ?? this.multipleVehicle,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'basicDetail': basicDetail?.toMap(),
      'contactDetail': contactDetail?.toMap(),
      'emergencyContact': emergencyContact?.toMap(),
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
      emergencyContact: EmergencyContact.fromMap(map['emergencyContact']),
      gender: Gender.values.byName(gender),
      multipleVehicle: MultipleVehicle.fromMap(map['multipleVehicle']),
      vehicleInfo: VehicleInfo.fromMap(map['vehicleInfo']),
    );
  }

//</editor-fold>
}
