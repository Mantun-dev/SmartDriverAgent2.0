// To parse this JSON data, do
//
//     final trips = tripsFromJson(jsonString);

import 'dart:convert';

List<Trips> tripsFromJson(String str) =>
    List<Trips>.from(json.decode(str).map((x) => Trips.fromJson(x)));

String tripsToJson(List<Trips> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Trips {
  Trips(
      {required this.fecha,
      required this.horaEntrada,
      required this.horaConductor,
      required this.direccion,
      required this.neighborhoodReferencePoint,
      required this.conductor,
      required this.telefono,
      required this.condition,
      required this.tripId,
      required this.commentDriver,
      required this.companyId,
      required this.btnCancelTrip});

  String fecha;
  String horaEntrada;
  String horaConductor;
  String direccion;
  String neighborhoodReferencePoint;
  String conductor;
  String telefono;
  String condition;
  int tripId;
  String commentDriver;
  int companyId;
  dynamic btnCancelTrip;

  factory Trips.fromJson(Map<String, dynamic> json) => Trips(
      fecha: json["Fecha"],
      horaEntrada: json["horaEntrada"],
      horaConductor: json["horaConductor"],
      direccion: json["Direccion"],
      neighborhoodReferencePoint: json["neighborhoodReferencePoint"],
      conductor: json["Conductor"],
      telefono: json["Telefono"],
      condition: json["condition"],
      tripId: json["tripId"],
      commentDriver: json["commentDriver"],
      companyId: json["companyId"],
      btnCancelTrip: json["btnCancelTrip"]);

  Map<String, dynamic> toJson() => {
        "Fecha": fecha,
        "horaEntrada": horaEntrada,
        "horaConductor": horaConductor,
        "Direccion": direccion,
        "neighborhoodReferencePoint": neighborhoodReferencePoint,
        "Conductor": conductor,
        "Telefono": telefono,
        "condition": condition,
        "tripId": tripId,
        "commentDriver": commentDriver,
        "companyId": companyId,
        "btnCancelTrip": btnCancelTrip
      };
}

class TripsList {
  final List<Trips> trips;

  TripsList({
    required this.trips,
  });

  factory TripsList.fromJson(List<dynamic> parsedJson) {
    List<Trips> trips = [];

    trips = parsedJson.map((i) => Trips.fromJson(i)).toList();
    return new TripsList(
      trips: trips,
    );
  }
}
