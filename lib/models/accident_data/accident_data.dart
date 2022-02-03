import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';

class AccidentData {
  final double longitude;
  final double latitude;
  final DateTime timeCreated;
  final Placemark placemark;
  final String crashStatus;
  final List<double> last30sG;
  final String audioURL;
  final double gForce;

  AccidentData({
    required this.longitude,
    required this.latitude,
    required this.timeCreated,
    required this.placemark,
    required this.crashStatus,
    required this.last30sG,
    required this.audioURL,
    required this.gForce,
  });

  AccidentData copyWith({
    double? longitude,
    double? latitude,
    DateTime? timeCreated,
    Placemark? placemark,
    String? crashStatus,
    List<double>? last30sG,
    String? audioURL,
    double? gForce,
  }) {
    return AccidentData(
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      timeCreated: timeCreated ?? this.timeCreated,
      placemark: placemark ?? this.placemark,
      crashStatus: crashStatus ?? this.crashStatus,
      last30sG: last30sG ?? this.last30sG,
      audioURL: audioURL ?? this.audioURL,
      gForce: gForce ?? this.gForce,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'longitude': longitude,
      'latitude': latitude,
      'timeCreated': timeCreated.millisecondsSinceEpoch,
      'placemark': placemark.toJson(),
      'crashStatus': crashStatus,
      'last30sG': last30sG,
      'audioURL': audioURL,
      'gForce': gForce,
    };
  }

  factory AccidentData.fromMap(Map<String, dynamic> map) {
    return AccidentData(
      longitude: map['longitude']?.toDouble() ?? 0.0,
      latitude: map['latitude']?.toDouble() ?? 0.0,
      timeCreated: DateTime.fromMillisecondsSinceEpoch(map['timeCreated']),
      placemark: Placemark.fromMap(map['placemark']),
      crashStatus: map['crashStatus'] ?? '',
      last30sG: List<double>.from(map['last30sG']),
      audioURL: map['audioURL'] ?? '',
      gForce: map['gForce']?.toDouble() ?? 0.0,
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory AccidentData.fromJson(String source) {
    return AccidentData.fromMap(json.decode(source));
  }

  @override
  String toString() {
    return 'AccidentData(longitude: $longitude, latitude: $latitude,'
        ' timeCreated: $timeCreated, placemark: $placemark,'
        ' crashStatus: $crashStatus, last30sG: $last30sG,'
        ' audioURL: $audioURL, gForce: $gForce)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AccidentData &&
        other.longitude == longitude &&
        other.latitude == latitude &&
        other.timeCreated == timeCreated &&
        other.placemark == placemark &&
        other.crashStatus == crashStatus &&
        listEquals(other.last30sG, last30sG) &&
        other.audioURL == audioURL &&
        other.gForce == gForce;
  }

  @override
  int get hashCode {
    return longitude.hashCode ^
        latitude.hashCode ^
        timeCreated.hashCode ^
        placemark.hashCode ^
        crashStatus.hashCode ^
        last30sG.hashCode ^
        audioURL.hashCode ^
        gForce.hashCode;
  }
}
