// To parse this JSON data, do
//
//     final mask = maskFromJson(jsonString);

import 'dart:convert';

List<Mask> maskFromJson(String str) => List<Mask>.from(json.decode(str).map((x) => Mask.fromJson(x)));

String maskToJson(List<Mask> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mask {
    int msgTypeId;
    String title;
    String msgText;
    int showMsg;
    dynamic msgDate;
    int agentId;
    int? companyId;

    Mask({
        required this.msgTypeId,
        required this.title,
        required this.msgText,
        required this.showMsg,
        required this.msgDate,
        required this.agentId,
        required this.companyId,
    });

    factory Mask.fromJson(Map<String, dynamic> json) => Mask(
        msgTypeId: json["msgTypeId"],
        title: json["title"],
        msgText: json["msgText"],
        showMsg: json["showMsg"],
        msgDate: json["msgDate"],
        agentId: json["agentId"],
        companyId: json["companyId"],
    );

    Map<String, dynamic> toJson() => {
        "msgTypeId": msgTypeId,
        "title": title,
        "msgText": msgText,
        "showMsg": showMsg,
        "msgDate": msgDate,
        "agentId": agentId,
        "companyId": companyId,
    };
}
