class FirstEmergencyContact {
  final String? name;
  final String? relation;
  final String? contactNumber;
  final bool? contactAdded;

//<editor-fold desc="Data Methods">

  const FirstEmergencyContact({
    this.name,
    this.relation,
    this.contactNumber,
    this.contactAdded,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FirstEmergencyContact &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          relation == other.relation &&
          contactNumber == other.contactNumber &&
          contactAdded == other.contactAdded);

  @override
  int get hashCode =>
      name.hashCode ^
      relation.hashCode ^
      contactNumber.hashCode ^
      contactAdded.hashCode;

  @override
  String toString() {
    return 'EmergencyContact{' +
        ' name: $name,' +
        ' relation: $relation,' +
        ' contactNumber: $contactNumber,' +
        ' contactAdded: $contactAdded,' +
        '}';
  }

  FirstEmergencyContact copyWith({
    String? name,
    String? relation,
    String? contactNumber,
    bool? contactAdded,
  }) {
    return FirstEmergencyContact(
      name: name ?? this.name,
      relation: relation ?? this.relation,
      contactNumber: contactNumber ?? this.contactNumber,
      contactAdded: contactAdded ?? this.contactAdded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name ?? '',
      'relation': relation ?? '',
      'contactNumber': contactNumber ?? '',
      'contactAdded': contactAdded ?? '',
    };
  }

  factory FirstEmergencyContact.fromMap(Map<String, dynamic> map) {
    return FirstEmergencyContact(
      name: map['name'] ?? '',
      relation: map['relation'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      contactAdded: map['contactAdded'] ?? '',
    );
  }

//</editor-fold>
}
