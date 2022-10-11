// To parse this JSON data, do
//
//     final dataToken = dataTokenFromJson(jsonString);

import 'dart:convert';

DataToken dataTokenFromJson(String str) => DataToken.fromJson(json.decode(str));

String dataTokenToJson(DataToken data) => json.encode(data.toJson());

class DataToken {
  DataToken({
    required this.ok,
    required this.data,
  });

  bool ok;
  List<Datum> data;

  factory DataToken.fromJson(Map<String, dynamic> json) => DataToken(
        ok: json["ok"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.token,
    required this.agentId,
    required this.device,
    required this.created,
    required this.deviceId,
  });

  String token;
  int agentId;
  String device;
  DateTime created;
  String deviceId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        token: json["token"],
        agentId: json["agentId"],
        device: json["device"],
        created: DateTime.parse(json["created"]),
        deviceId: json["deviceId"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "agentId": agentId,
        "device": device,
        "created": created.toIso8601String(),
        "deviceId": deviceId,
      };
}
