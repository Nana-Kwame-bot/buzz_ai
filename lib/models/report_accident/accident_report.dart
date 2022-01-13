import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class AccidentReport {
  late DateTime createdAt;
  late String imageURL;
  late String carPlateNumber;
  late int? peopleInjured;
  late List<double> coordinates;
  late Map location;
  String? reportID;

  AccidentReport({
    required this.createdAt,
    required this.imageURL,
    required this.carPlateNumber,
    required this.peopleInjured,
    required this.coordinates,
    required this.location,
  });

  Map<String, dynamic> toJSON() => {
        "createdAt": createdAt,
        "imageURL": imageURL,
        "carPlateNumber": carPlateNumber,
        "peopleInjured": peopleInjured,
        "coordinates": coordinates,
        "location": location,
      };

  AccidentReport fromJson(Map<String, dynamic> json) {
    return AccidentReport(
      createdAt: DateTime.parse(json["createdAt"]),
      imageURL: json["imageURL"],
      carPlateNumber: json["carPlateNumber"],
      peopleInjured: json["peopleInjured"],
      coordinates: json["coordinates"],
      location: json["location"],
    );
  }

  AccidentReport.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    createdAt = snapshot.data()["createdAt"].toDate();
    imageURL = snapshot.data()["imageURL"];
    carPlateNumber = snapshot.data()["carPlateNumber"];
    peopleInjured = snapshot.data()["peopleInjured"];
    coordinates = List<double>.from(snapshot.data()["coordinates"]);
    location = snapshot.data()["location"];
    reportID = snapshot.id;
  }

  @override
  String toString() {
    return 'AccidentReport(createdAt: $createdAt, imageURL: $imageURL, carPlateNumber: $carPlateNumber, peopleInjured: $peopleInjured, coordinates: $coordinates, location: $location, reportID: $reportID)';
  }
}
