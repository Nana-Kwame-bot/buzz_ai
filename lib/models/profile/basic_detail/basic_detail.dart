class BasicDetail {
  final String? imageURL;
  final String? fullName;
  final String? dateOfBirth;
  final int? weight;
  final int? age;
  final String? bloodGroup;
  final int? licenseNumber;

//<editor-fold desc="Data Methods">

  const BasicDetail({
    this.imageURL,
    this.fullName,
    this.dateOfBirth,
    this.weight,
    this.age,
    this.bloodGroup,
    this.licenseNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BasicDetail &&
          runtimeType == other.runtimeType &&
          imageURL == other.imageURL &&
          fullName == other.fullName &&
          dateOfBirth == other.dateOfBirth &&
          weight == other.weight &&
          age == other.age &&
          bloodGroup == other.bloodGroup &&
          licenseNumber == other.licenseNumber);

  @override
  int get hashCode =>
      imageURL.hashCode ^
      fullName.hashCode ^
      dateOfBirth.hashCode ^
      weight.hashCode ^
      age.hashCode ^
      bloodGroup.hashCode ^
      licenseNumber.hashCode;

  @override
  String toString() {
    return 'BasicDetail{' +
        ' imageURL: $imageURL,' +
        ' fullName: $fullName,' +
        ' dateOfBirth: $dateOfBirth,' +
        ' weight: $weight,' +
        ' age: $age,' +
        ' bloodGroup: $bloodGroup,' +
        ' licenseNumber: $licenseNumber,' +
        '}';
  }

  BasicDetail copyWith({
    String? imageURL,
    String? fullName,
    String? dateOfBirth,
    int? weight,
    int? age,
    String? bloodGroup,
    int? licenseNumber,
  }) {
    return BasicDetail(
      imageURL: imageURL ?? this.imageURL,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      licenseNumber: licenseNumber ?? this.licenseNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageURL': imageURL ?? '',
      'fullName': fullName ?? '',
      'dateOfBirth': dateOfBirth ?? '',
      'weight': weight ?? '',
      'age': age ?? '',
      'bloodGroup': bloodGroup ?? '',
      'licenseNumber': licenseNumber ?? '',
    };
  }

  factory BasicDetail.fromMap(Map<String, dynamic> map) {
    return BasicDetail(
      imageURL: map['imageURL'] ?? '',
      fullName: map['fullName'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      weight: map['weight'] ?? '',
      age: map['age'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
    );
  }

//</editor-fold>
}
