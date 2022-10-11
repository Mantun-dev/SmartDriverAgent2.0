// To parse this JSON data, do
//
//     final counts = countsFromJson(jsonString);

import 'dart:convert';

Counts countsFromJson(String str) => Counts.fromJson(json.decode(str));

String countsToJson(Counts data) => json.encode(data.toJson());

class Counts {
  Counts({
    this.ok,
    this.counts,
  });

  bool? ok;
  List<Count>? counts;

  factory Counts.fromJson(Map<String, dynamic> json) => Counts(
        ok: json["ok"],
        counts: List<Count>.from(json["counts"].map((x) => Count.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "counts": List<dynamic>.from(counts!.map((x) => x.toJson())),
      };
}

class Count {
  Count({
    this.countId,
    this.countName,
    this.companyId,
  });

  int? countId;
  String? countName;
  int? companyId;

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        countId: json["countId"],
        countName: json["countName"],
        companyId: json["companyId"],
      );

  Map<String, dynamic> toJson() => {
        "countId": countId,
        "countName": countName,
        "companyId": companyId,
      };
}

class CountList {
  final List<Count> trips;

  CountList({
    required this.trips,
  });

  factory CountList.fromJson(List<dynamic> parsedJson) {
    List<Count>? trips = [];

    trips = parsedJson.map((i) => Count.fromJson(i)).toList();
    return new CountList(
      trips: trips,
    );
  }
}
