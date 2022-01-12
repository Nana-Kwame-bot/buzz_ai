class Address {
  final String street;
  final String subLocality;
  final String locality;
  final String postalCode;
  final String country;

//<editor-fold desc="Data Methods">

  const Address({
    required this.street,
    required this.subLocality,
    required this.locality,
    required this.postalCode,
    required this.country,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Address &&
          runtimeType == other.runtimeType &&
          street == other.street &&
          subLocality == other.subLocality &&
          locality == other.locality &&
          postalCode == other.postalCode &&
          country == other.country);

  @override
  int get hashCode =>
      street.hashCode ^
      subLocality.hashCode ^
      locality.hashCode ^
      postalCode.hashCode ^
      country.hashCode;

  @override
  String toString() {
    return 'Address{' +
        ' street: $street,' +
        ' subLocality: $subLocality,' +
        ' locality: $locality,' +
        ' postalCode: $postalCode,' +
        ' country: $country,' +
        '}';
  }

  Address copyWith({
    String? street,
    String? subLocality,
    String? locality,
    String? postalCode,
    String? country,
  }) {
    return Address(
      street: street ?? this.street,
      subLocality: subLocality ?? this.subLocality,
      locality: locality ?? this.locality,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'subLocality': subLocality,
      'locality': locality,
      'postalCode': postalCode,
      'country': country,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'] as String,
      subLocality: map['subLocality'] as String,
      locality: map['locality'] as String,
      postalCode: map['postalCode'] as String,
      country: map['country'] as String,
    );
  }

//</editor-fold>
}
