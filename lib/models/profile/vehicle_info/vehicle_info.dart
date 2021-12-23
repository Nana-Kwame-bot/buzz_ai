class VehicleInfo {
  final String? ownerName;
  final String? model;
  final String? year;
  final String? plateNumber;

  VehicleInfo({
    this.ownerName,
    this.model,
    this.year,
    this.plateNumber,
  });

  @override
  String toString() {
    return 'VehicleInfo(ownerName: $ownerName, model: $model, year: $year, plateNumber: $plateNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VehicleInfo &&
        other.ownerName == ownerName &&
        other.model == model &&
        other.year == year &&
        other.plateNumber == plateNumber;
  }

  @override
  int get hashCode {
    return ownerName.hashCode ^
        model.hashCode ^
        year.hashCode ^
        plateNumber.hashCode;
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
}
