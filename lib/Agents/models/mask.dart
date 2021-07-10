// To parse this JSON data, do
//
//     final mask = maskFromJson(jsonString);

import 'dart:convert';

Mask maskFromJson(String str) => Mask.fromJson(json.decode(str));

String maskToJson(Mask data) => json.encode(data.toJson());

class Mask {
    Mask({
        this.viewed,
    });

    bool viewed;

    factory Mask.fromJson(Map<String, dynamic> json) => Mask(
        viewed: json["viewed"],
    );

    Map<String, dynamic> toJson() => {
        "viewed": viewed,
    };
}
