// To parse this JSON data, do
//
//     final counts = countsFromJson(jsonString);

import 'dart:convert';

List<Story> storyFromJson(String str) =>
    List<Story>.from(json.decode(str).map((x) => Story.fromJson(x)));

String storyToJson(List<Story> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Story {
  Story({
    this.fecha,
    this.horaEntrada,
    this.hora,
    this.estado,
    this.conductor,
    this.telefono,
    this.abordo,
    this.tripId,
    this.direccion,
  });

  String? fecha;
  String? horaEntrada;
  String? hora;
  String? estado;
  String? conductor;
  String? telefono;
  bool? abordo;
  int? tripId;
  String? direccion;

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        fecha: json["Fecha"],
        horaEntrada: json["horaEntrada"],
        hora: json["Hora"],
        estado: json["Estado"],
        conductor: json["Conductor"],
        telefono: json["Telefono"],
        abordo: json["Abordo"],
        tripId: json["tripId"],
        direccion: json["Direccion"],
      );

  Map<String, dynamic> toJson() => {
        "Fecha": fecha,
        "horaEntrada": horaEntrada,
        "Hora": hora,
        "Estado": estado,
        "Conductor": conductor,
        "Telefono": telefono,
        "Abordo": abordo,
        "tripId": tripId,
        "Direccion": direccion,
      };
}
