import 'dart:convert';

import 'package:hive_flutter/adapters.dart';

part 'sensor_data.g.dart';

// If you are modifying this file then please run:
// flutter pub run build_runner build
// before building the project.

@HiveType(typeId: 1)
class SensorModel {
  @HiveField(0)
  final String at;
  @HiveField(1)
  final List<List<double>> accelerometerData;
  @HiveField(2)
  final List<List<double>> gyroscopeData;

  SensorModel({
    required this.at,
    required this.accelerometerData,
    required this.gyroscopeData,
  });

  Map<String, dynamic> toMap() {
    return {
      'at': at,
      'accelerometerData': accelerometerData,
      'gyroscopeData': gyroscopeData,
    };
  }

  factory SensorModel.fromMap(Map<String, dynamic> map) {
    return SensorModel(
      at: map['at'] ?? '',
      accelerometerData: List<List<double>>.from(
          map['accelerometerData']?.map((x) => List<double>.from(x))),
      gyroscopeData: List<List<double>>.from(
          map['gyroscopeData']?.map((x) => List<double>.from(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory SensorModel.fromJson(String source) =>
      SensorModel.fromMap(json.decode(source));
}
