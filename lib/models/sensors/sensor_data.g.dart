// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SensorModelAdapter extends TypeAdapter<SensorModel> {
  @override
  final int typeId = 1;

  @override
  SensorModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SensorModel(
      at: fields[0] as String,
      accelerometerData: (fields[1] as List)
          .map((dynamic e) => (e as List).cast<double>())
          .toList(),
      gyroscopeData: (fields[2] as List)
          .map((dynamic e) => (e as List).cast<double>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, SensorModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.at)
      ..writeByte(1)
      ..write(obj.accelerometerData)
      ..writeByte(2)
      ..write(obj.gyroscopeData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
