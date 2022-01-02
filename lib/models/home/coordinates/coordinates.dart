class Coordinates {
  final double sourceLongitude;
  final double sourceLatitude;
  final double destinationLongitude;
  final double destinationLatitude;

//<editor-fold desc="Data Methods">

  const Coordinates({
    required this.sourceLongitude,
    required this.sourceLatitude,
    required this.destinationLongitude,
    required this.destinationLatitude,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Coordinates &&
          runtimeType == other.runtimeType &&
          sourceLongitude == other.sourceLongitude &&
          sourceLatitude == other.sourceLatitude &&
          destinationLongitude == other.destinationLongitude &&
          destinationLatitude == other.destinationLatitude);

  @override
  int get hashCode =>
      sourceLongitude.hashCode ^
      sourceLatitude.hashCode ^
      destinationLongitude.hashCode ^
      destinationLatitude.hashCode;

  @override
  String toString() {
    return 'Coordinates{' +
        ' sourceLongitude: $sourceLongitude,' +
        ' sourceLatitude: $sourceLatitude,' +
        ' destinationLongitude: $destinationLongitude,' +
        ' destinationLatitude: $destinationLatitude,' +
        '}';
  }

  Coordinates copyWith({
    double? sourceLongitude,
    double? sourceLatitude,
    double? destinationLongitude,
    double? destinationLatitude,
  }) {
    return Coordinates(
      sourceLongitude: sourceLongitude ?? this.sourceLongitude,
      sourceLatitude: sourceLatitude ?? this.sourceLatitude,
      destinationLongitude: destinationLongitude ?? this.destinationLongitude,
      destinationLatitude: destinationLatitude ?? this.destinationLatitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sourceLongitude': sourceLongitude,
      'sourceLatitude': sourceLatitude,
      'destinationLongitude': destinationLongitude,
      'destinationLatitude': destinationLatitude,
    };
  }

  factory Coordinates.fromMap(Map<String, dynamic> map) {
    return Coordinates(
      sourceLongitude: map['sourceLongitude'] as double,
      sourceLatitude: map['sourceLatitude'] as double,
      destinationLongitude: map['destinationLongitude'] as double,
      destinationLatitude: map['destinationLatitude'] as double,
    );
  }

//</editor-fold>
}
