// To parse this JSON data, do
//
//     final rating = ratingFromJson(jsonString);

import 'dart:convert';

Rating ratingFromJson(String str) => Rating.fromJson(json.decode(str));

String ratingToJson(Rating data) => json.encode(data.toJson());

class Rating {
    Rating({
        this.tripId,
        this.driverFullname
    });

    int tripId;
    String driverFullname;

    factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        tripId: json["tripId"],
        driverFullname: json["driverFullname"]
    );

    Map<String, dynamic> toJson() => {
        "tripId": tripId,
        "driverFullname": driverFullname
    };
}
