class ContactDetail {
  final String address;
  final String phoneNumber;

  ContactDetail({
    required this.address,
    required this.phoneNumber,
  });

  @override
  String toString() =>
      'ContactDetail(address: $address, phoneNumber: $phoneNumber)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactDetail &&
        other.address == address &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode => address.hashCode ^ phoneNumber.hashCode;
}
