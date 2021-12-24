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
}
