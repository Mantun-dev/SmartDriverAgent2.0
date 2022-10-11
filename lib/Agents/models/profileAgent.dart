// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile(
      {this.agentId,
      this.agentEmployeeId,
      this.agentUser,
      this.agentFullname,
      this.agentPhone,
      this.agentEmail,
      this.departmentName,
      this.townName,
      this.districtName,
      this.neighborhoodName,
      this.agentReferencePoint,
      this.agentComment,
      this.neighborhoodId,
      this.neighborhoodReferencePoint,
      this.mondayIn,
      this.mondayOut,
      this.tuesdayIn,
      this.tuesdayOut,
      this.wednesdayIn,
      this.wednesdayOut,
      this.thursdayIn,
      this.thursdayOut,
      this.fridayIn,
      this.fridayOut,
      this.saturdayIn,
      this.saturdayOut,
      this.sundayIn,
      this.sundayOut,
      this.scheduleId,
      this.countName});

  int? agentId;
  String? agentEmployeeId;
  String? agentUser;
  String? agentFullname;
  String? agentPhone;
  String? agentEmail;
  String? countName;
  String? departmentName;
  String? townName;
  String? districtName;
  String? neighborhoodName;
  String? agentReferencePoint;
  String? agentComment;
  int? neighborhoodId;
  String? neighborhoodReferencePoint;
  String? mondayIn;
  String? mondayOut;
  String? tuesdayIn;
  String? tuesdayOut;
  String? wednesdayIn;
  String? wednesdayOut;
  String? thursdayIn;
  String? thursdayOut;
  String? fridayIn;
  String? fridayOut;
  String? saturdayIn;
  String? saturdayOut;
  dynamic sundayIn;
  dynamic sundayOut;
  int? scheduleId;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      agentId: json["agentId"],
      agentEmployeeId: json["agentEmployeeId"],
      agentUser: json["agentUser"],
      agentFullname: json["agentFullname"],
      agentPhone: json["agentPhone"],
      agentEmail: json["agentEmail"],
      departmentName: json["departmentName"],
      townName: json["townName"],
      districtName: json["districtName"],
      neighborhoodName: json["neighborhoodName"],
      agentReferencePoint: json["agentReferencePoint"],
      agentComment: json["agentComment"],
      neighborhoodId: json["neighborhoodId"],
      neighborhoodReferencePoint: json["neighborhoodReferencePoint"],
      mondayIn: json["mondayIn"],
      mondayOut: json["mondayOut"],
      tuesdayIn: json["tuesdayIn"],
      tuesdayOut: json["tuesdayOut"],
      wednesdayIn: json["wednesdayIn"],
      wednesdayOut: json["wednesdayOut"],
      thursdayIn: json["thursdayIn"],
      thursdayOut: json["thursdayOut"],
      fridayIn: json["fridayIn"],
      fridayOut: json["fridayOut"],
      saturdayIn: json["saturdayIn"],
      saturdayOut: json["saturdayOut"],
      sundayIn: json["sundayIn"],
      sundayOut: json["sundayOut"],
      scheduleId: json["scheduleId"],
      countName: json["countName"]);

  Map<String, dynamic> toJson() => {
        "agentId": agentId,
        "agentEmployeeId": agentEmployeeId,
        "agentUser": agentUser,
        "agentFullname": agentFullname,
        "agentPhone": agentPhone,
        "agentEmail": agentEmail,
        "departmentName": departmentName,
        "townName": townName,
        "districtName": districtName,
        "neighborhoodName": neighborhoodName,
        "agentReferencePoint": agentReferencePoint,
        "agentComment": agentComment,
        "neighborhoodId": neighborhoodId,
        "neighborhoodReferencePoint": neighborhoodReferencePoint,
        "mondayIn": mondayIn,
        "mondayOut": mondayOut,
        "tuesdayIn": tuesdayIn,
        "tuesdayOut": tuesdayOut,
        "wednesdayIn": wednesdayIn,
        "wednesdayOut": wednesdayOut,
        "thursdayIn": thursdayIn,
        "thursdayOut": thursdayOut,
        "fridayIn": fridayIn,
        "fridayOut": fridayOut,
        "saturdayIn": saturdayIn,
        "saturdayOut": saturdayOut,
        "sundayIn": sundayIn,
        "sundayOut": sundayOut,
        "scheduleId": scheduleId,
        "countName": countName
      };
}
