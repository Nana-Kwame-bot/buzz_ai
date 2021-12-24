class EmergencyContact {
  String? name;
  String? relation;
  String? contactNumber;

  EmergencyContact({
    this.name,
    this.relation,
    this.contactNumber,
  });

  @override
  String toString() =>
      'EmergencyContact(name: $name, relation: $relation, contactNumber: $contactNumber)';

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
