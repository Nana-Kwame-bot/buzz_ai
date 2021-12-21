class EmergencyContact {
  final String name;
  final String relation;
  final String contactNumber;

  EmergencyContact({
    required this.name,
    required this.relation,
    required this.contactNumber,
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
}
