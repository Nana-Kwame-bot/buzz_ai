class EmergencyContact {
  String? name;
  String? relation;
  String? contactNumber;
  bool? contactAdded;

  EmergencyContact({
    this.name,
    this.relation,
    this.contactNumber,
    this.contactAdded,
  });

  @override
  String toString() {
    return 'EmergencyContact(name: $name, relation: $relation, contactNumber: $contactNumber, contactAdded: $contactAdded)';
  }

  EmergencyContact copyWith({
    String? name,
    String? relation,
    String? contactNumber,
    bool? contactAdded,
  }) {
    return EmergencyContact(
      name: name ?? this.name,
      relation: relation ?? this.relation,
      contactNumber: contactNumber ?? this.contactNumber,
      contactAdded: contactAdded ?? this.contactAdded,
    );
  }
}
