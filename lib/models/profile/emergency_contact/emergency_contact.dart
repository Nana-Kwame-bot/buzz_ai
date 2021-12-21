class EmergencyContact {
  final String? name;
  final String? relation;
  final String? contactNumber;

  EmergencyContact({
    this.name,
    this.relation,
    this.contactNumber,
  });

  @override
  String toString() =>
      'EmergencyContact(name: $name, relation: $relation, contactNumber: $contactNumber)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmergencyContact &&
        other.name == name &&
        other.relation == relation &&
        other.contactNumber == contactNumber;
  }

  @override
  int get hashCode =>
      name.hashCode ^ relation.hashCode ^ contactNumber.hashCode;

  EmergencyContact copyWith({
    String? name,
    String? relation,
    String? contactNumber,
  }) {
    return EmergencyContact(
      name: name ?? this.name,
      relation: relation ?? this.relation,
      contactNumber: contactNumber ?? this.contactNumber,
    );
  }
}
