class EmergencyContact {
  final String? name;
  final String? relation;
  final String? contactNumber;
  final bool? contactAdded;

//<editor-fold desc="Data Methods">

   const EmergencyContact({
    this.name,
    this.relation,
    this.contactNumber,
    this.contactAdded,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmergencyContact &&
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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'relation': relation,
      'contactNumber': contactNumber,
      'contactAdded': contactAdded,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      name: map['name'] as String,
      relation: map['relation'] as String,
      contactNumber: map['contactNumber'] as String,
      contactAdded: map['contactAdded'] as bool,
    );
  }

//</editor-fold>
}
