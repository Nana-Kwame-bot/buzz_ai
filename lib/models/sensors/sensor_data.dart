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
}
