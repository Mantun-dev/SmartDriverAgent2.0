// To parse this JSON data, do
//
//     final ticketHistory = ticketHistoryFromJson(jsonString);

import 'dart:convert';

List<TicketHistory> ticketHistoryFromJson(String str) => List<TicketHistory>.from(json.decode(str).map((x) => TicketHistory.fromJson(x)));

String ticketHistoryToJson(List<TicketHistory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TicketHistory {
    TicketHistory({
        this.pendant,
        this.closed,
    });

    List<Pendant> pendant;
    List<Closed> closed;

    factory TicketHistory.fromJson(Map<String, dynamic> json) => TicketHistory(
        pendant: json["pendant"] == null ? null : List<Pendant>.from(json["pendant"].map((x) => Pendant.fromJson(x))),
        closed: json["closed"] == null ? null : List<Closed>.from(json["closed"].map((x) => Closed.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pendant": pendant == null ? null : List<dynamic>.from(pendant.map((x) => x.toJson())),
        "closed": closed == null ? null : List<dynamic>.from(closed.map((x) => x.toJson())),
    };
}

class Closed {
    Closed({
        this.ticketId,
        this.agentEmployeeId,
        this.agentFullname,
        this.ticketIssue,
        this.ticketMessage,
        this.ticketDatetime,
        this.agentId,
        this.replyId,
        this.replyMessage,
        this.userName,
        this.userFullname,
    });

    int ticketId;
    String agentEmployeeId;
    String agentFullname;
    String ticketIssue;
    String ticketMessage;
    String ticketDatetime;
    int agentId;
    int replyId;
    String replyMessage;
    String userName;
    String userFullname;

    factory Closed.fromJson(Map<String, dynamic> json) => Closed(
        ticketId: json["ticketId"],
        agentEmployeeId: json["agentEmployeeId"],
        agentFullname: json["agentFullname"],
        ticketIssue: json["ticketIssue"],
        ticketMessage: json["ticketMessage"],
        ticketDatetime: json["ticketDatetime"],
        agentId: json["agentId"],
        replyId: json["replyId"],
        replyMessage: json["replyMessage"],
        userName: json["userName"],
        userFullname: json["userFullname"],
    );

    Map<String, dynamic> toJson() => {
        "ticketId": ticketId,
        "agentEmployeeId": agentEmployeeId,
        "agentFullname": agentFullname,
        "ticketIssue": ticketIssue,
        "ticketMessage": ticketMessage,
        "ticketDatetime": ticketDatetime,
        "agentId": agentId,
        "replyId": replyId,
        "replyMessage": replyMessage,
        "userName": userName,
        "userFullname": userFullname,
    };
}

class Pendant {
    Pendant({
        this.ticketId,
        this.agentEmployeeId,
        this.agentFullname,
        this.ticketIssue,
        this.ticketMessage,
        this.ticketDatetime,
        this.agentId,
    });

    int ticketId;
    String agentEmployeeId;
    String agentFullname;
    String ticketIssue;
    String ticketMessage;
    String ticketDatetime;
    int agentId;

    factory Pendant.fromJson(Map<String, dynamic> json) => Pendant(
        ticketId: json["ticketId"],
        agentEmployeeId: json["agentEmployeeId"],
        agentFullname: json["agentFullname"],
        ticketIssue: json["ticketIssue"],
        ticketMessage: json["ticketMessage"],
        ticketDatetime: json["ticketDatetime"],
        agentId: json["agentId"],
    );

    Map<String, dynamic> toJson() => {
        "ticketId": ticketId,
        "agentEmployeeId": agentEmployeeId,
        "agentFullname": agentFullname,
        "ticketIssue": ticketIssue,
        "ticketMessage": ticketMessage,
        "ticketDatetime": ticketDatetime,
        "agentId": agentId,
    };
}


class TripsList6 {
  final List<TicketHistory> trips;

  TripsList6({
    this.trips,
  });

  factory TripsList6.fromJson(List<dynamic> parsedJson) {

    List<TicketHistory> trips = [];

    trips = parsedJson.map((i)=>TicketHistory.fromJson(i)).toList();
    return new TripsList6(
       trips: trips,
    );
  }
}