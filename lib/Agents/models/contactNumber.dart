import 'dart:convert';

// To parse this JSON data, do
//
//     final testContactResponse = testContactResponseFromJson(jsonString);

TestContactResponse testContactResponseFromJson(String str) =>
    TestContactResponse.fromJson(json.decode(str));

String testContactResponseToJson(TestContactResponse data) => json.encode(data.toJson());

class TestContactResponse {
  TestContactResponse({
    this.ok,
    this.type,
    this.message,
  });

  bool? ok;
  String? type;
  List<TestContact>? message;

  factory TestContactResponse.fromJson(Map<String, dynamic> json) => TestContactResponse(
        ok: json["ok"],
        type: json["type"],
        // Mapeamos la lista de JSON a una lista de objetos TestContact
        message: json["message"] == null
            ? []
            : List<TestContact>.from(json["message"]!.map((x) => TestContact.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "type": type,
        "message": message == null
            ? []
            : List<dynamic>.from(message!.map((x) => x.toJson())),
      };
}

class TestContact {
  TestContact({
    this.phoneNumber,
    this.contactDesc,
  });

  String? phoneNumber;
  String? contactDesc;

  factory TestContact.fromJson(Map<String, dynamic> json) => TestContact(
        phoneNumber: json["phoneNumber"],
        contactDesc: json["contactDesc"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "contactDesc": contactDesc,
      };
}