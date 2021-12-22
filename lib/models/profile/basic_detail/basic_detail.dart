class BasicDetail {
  final String? imageURL;
  final String? fullname;
  final String? dateOfBirth;
  final int? weight;
  final int? age;
  final String? bloodGroup;
  final int? licenseNumber;

  BasicDetail({
    this.imageURL,
    this.fullname,
    this.dateOfBirth,
    this.weight,
    this.age,
    this.bloodGroup,
    this.licenseNumber,
  });

  @override
  String toString() {
    return 'BasicDetail(imageURL: $imageURL, fullname: $fullname, dateOfBirth: $dateOfBirth, weight: $weight, age: $age, bloodGroup: $bloodGroup, licenseNumber: $licenseNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BasicDetail &&
        other.imageURL == imageURL &&
        other.fullname == fullname &&
        other.dateOfBirth == dateOfBirth &&
        other.weight == weight &&
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
        age.hashCode ^
        bloodGroup.hashCode ^
        licenseNumber.hashCode;
  }

  BasicDetail copyWith({
    String? imageURL,
    String? fullname,
    String? dateOfBirth,
    int? weight,
    int? age,
    String? bloodGroup,
    int? licenseNumber,
  }) {
    return BasicDetail(
      imageURL: imageURL ?? this.imageURL,
      fullname: fullname ?? this.fullname,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      licenseNumber: licenseNumber ?? this.licenseNumber,
    );
  }
}
