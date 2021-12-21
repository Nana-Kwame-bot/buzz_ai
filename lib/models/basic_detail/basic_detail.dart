import 'package:buzz_ai/models/gender/gender.dart';

class BasicDetail {
  final String imageURL;
  final String fullname;
  final String dateOfBirth;
  final int weight;
  final Gender gender;
  final int age;
  final String bloodGroup;
  final int licenseNumber;

  BasicDetail({
    required this.imageURL,
    required this.fullname,
    required this.dateOfBirth,
    required this.weight,
    required this.gender,
    required this.age,
    required this.bloodGroup,
    required this.licenseNumber,
  });

  @override
  String toString() {
    return 'BasicDetail(imageURL: $imageURL, fullname: $fullname, dateOfBirth: $dateOfBirth, weight: $weight, gender: $gender, age: $age, bloodGroup: $bloodGroup, licenseNumber: $licenseNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BasicDetail &&
        other.imageURL == imageURL &&
        other.fullname == fullname &&
        other.dateOfBirth == dateOfBirth &&
        other.weight == weight &&
        other.gender == gender &&
        other.age == age &&
        other.bloodGroup == bloodGroup &&
        other.licenseNumber == licenseNumber;
  }

  @override
  int get hashCode {
    return imageURL.hashCode ^
        fullname.hashCode ^
        dateOfBirth.hashCode ^
        weight.hashCode ^
        gender.hashCode ^
        age.hashCode ^
        bloodGroup.hashCode ^
        licenseNumber.hashCode;
  }
}
