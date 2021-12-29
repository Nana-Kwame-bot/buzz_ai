class ContactDetail {
  final String? address;
  final String? phoneNumber;

//<editor-fold desc="Data Methods">

  const ContactDetail({
    this.address,
    this.phoneNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContactDetail &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          phoneNumber == other.phoneNumber);

  @override
  int get hashCode => address.hashCode ^ phoneNumber.hashCode;

  @override
  String toString() {
    return 'ContactDetail{' +
        ' address: $address,' +
        ' phoneNumber: $phoneNumber,' +
        '}';
  }

  ContactDetail copyWith({
    String? address,
    String? phoneNumber,
  }) {
    return ContactDetail(
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }

  factory ContactDetail.fromMap(Map<String, dynamic> map) {
    return ContactDetail(
      address: map['address'] as String,
      phoneNumber: map['phoneNumber'] as String,
    );
  }

//</editor-fold>
}
