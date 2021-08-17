// To parse this JSON data, do
//
//     final trips = tripsFromJson(jsonString);

import 'dart:convert';

List<Trips> tripsFromJson(String str) => List<Trips>.from(json.decode(str).map((x) => Trips.fromJson(x)));

String tripsToJson(List<Trips> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Trips {
    Trips({
        this.fecha,
        this.horaEntrada,
        this.horaConductor,
        this.direccion,
        this.neighborhoodReferencePoint,
        this.conductor,
        this.telefono,
        this.condition,
        this.tripId,
        this.commentDriver
    });

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
        commentDriver: json["commentDriver"]
    );

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
        "commentDriver": commentDriver
    };
}

class TripsList {
  final List<Trips> trips;

  TripsList({
    this.trips,
  });

  factory TripsList.fromJson(List<dynamic> parsedJson) {

    List<Trips> trips = [];

    trips = parsedJson.map((i)=>Trips.fromJson(i)).toList();
    return new TripsList(
       trips: trips,
    );
  }

}
