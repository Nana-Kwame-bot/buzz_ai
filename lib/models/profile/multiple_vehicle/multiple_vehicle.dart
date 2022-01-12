class MultipleVehicle {
  final String? ownerName;
  final String? model;
  final String? year;
  final String? plateNumber;
  final bool? added;

//<editor-fold desc="Data Methods">

  const MultipleVehicle({
    this.ownerName,
    this.model,
    this.year,
    this.plateNumber,
    this.added,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MultipleVehicle &&
          runtimeType == other.runtimeType &&
          ownerName == other.ownerName &&
          model == other.model &&
          year == other.year &&
          plateNumber == other.plateNumber &&
          added == other.added);

  @override
  int get hashCode =>
      ownerName.hashCode ^
      model.hashCode ^
      year.hashCode ^
      plateNumber.hashCode ^
      added.hashCode;

  @override
  String toString() {
    return 'MultipleVehicle{' +
        ' ownerName: $ownerName,' +
        ' model: $model,' +
        ' year: $year,' +
        ' plateNumber: $plateNumber,' +
        ' added: $added,' +
        '}';
  }

  MultipleVehicle copyWith({
    String? ownerName,
    String? model,
    String? year,
    String? plateNumber,
    bool? added,
  }) {
    return MultipleVehicle(
      ownerName: ownerName ?? this.ownerName,
      model: model ?? this.model,
      year: year ?? this.year,
      plateNumber: plateNumber ?? this.plateNumber,
      added: added ?? this.added,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerName': ownerName ?? '',
      'model': model ?? '',
      'year': year ?? '',
      'plateNumber': plateNumber ?? '',
      'added': added ?? '',
    };
  }

  factory MultipleVehicle.fromMap(Map<String, dynamic> map) {
    return MultipleVehicle(
      ownerName: map['ownerName'] ?? '',
      model: map['model'] ?? '',
      year: map['year'] ?? '',
      plateNumber: map['plateNumber'] ?? '',
      added: map['added'] ?? '',
    );
  }

//</editor-fold>
}
