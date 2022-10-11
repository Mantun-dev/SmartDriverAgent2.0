// To parse this JSON data, do
//
//     final register = registerFromJson(jsonString);

import 'dart:convert';

Register registerFromJson(String str) => Register.fromJson(json.decode(str));

String registerToJson(Register data) => json.encode(data.toJson());

class Register {
  Register({
    this.ok,
    this.type,
    this.title,
    this.message,
  });

  bool? ok;
  String? type;
  String? title;
  String? message;

  factory Register.fromJson(Map<String, dynamic> json) => Register(
        ok: json["ok"],
        type: json["type"],
        title: json["title"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "type": type,
        "title": title,
        "message": message,
      };
}
