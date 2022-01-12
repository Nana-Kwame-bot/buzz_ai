class VehicleInfo {
  final String? ownerName;
  final String? model;
  final String? year;
  final String? plateNumber;

//<editor-fold desc="Data Methods">

  const VehicleInfo({
    this.ownerName,
    this.model,
    this.year,
    this.plateNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VehicleInfo &&
          runtimeType == other.runtimeType &&
          ownerName == other.ownerName &&
          model == other.model &&
          year == other.year &&
          plateNumber == other.plateNumber);

  @override
  int get hashCode =>
      ownerName.hashCode ^
      model.hashCode ^
      year.hashCode ^
      plateNumber.hashCode;

  @override
  String toString() {
    return 'VehicleInfo{' +
        ' ownerName: $ownerName,' +
        ' model: $model,' +
        ' year: $year,' +
        ' plateNumber: $plateNumber,' +
        '}';
  }

  VehicleInfo copyWith({
    String? ownerName,
    String? model,
    String? year,
    String? plateNumber,
  }) {
    return VehicleInfo(
      ownerName: ownerName ?? this.ownerName,
      model: model ?? this.model,
      year: year ?? this.year,
      plateNumber: plateNumber ?? this.plateNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerName': ownerName ?? '',
      'model': model ?? '',
      'year': year ?? '',
      'plateNumber': plateNumber ?? '',
    };
  }

  factory VehicleInfo.fromMap(Map<String, dynamic> map) {
    return VehicleInfo(
      ownerName: map['ownerName'] ?? '',
      model: map['model'] ?? '',
      year: map['year'] ?? '',
      plateNumber: map['plateNumber'] ?? '',
    );
  }

//</editor-fold>
}
