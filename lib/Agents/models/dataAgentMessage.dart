import 'dart:convert';

// To parse this JSON data, do
//
//     final dataAgent = dataAgentFromJson(jsonString);

DataAgents dataAgentsFromJson(String str) => DataAgents.fromJson(json.decode(str));

String dataAgentsToJson(DataAgents data) => json.encode(data.toJson());

class DataAgents {
    DataAgents({
        this.ok,
        this.message
    });

    bool ok;
    String message;

    factory DataAgents.fromJson(Map<String, dynamic> json) => DataAgents(
        ok: json["ok"],
        message: json["message"],        
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": message,
    };
    fromJson(decode) {}
}

class Agent {
    Agent({
        this.agentId,
        this.agentEmployeeId,
        this.agentFullname,
        this.agentPhone,
        this.agentEmail,
        this.agentStatus,
        this.agentReferencePoint,
        this.agentComment,
        this.companyId,
        this.neighborhoodId,
        this.agentUser,
        this.countId,
    });

    int agentId;
    String agentEmployeeId;
    String agentFullname;
    String agentPhone;
    String agentEmail;
    bool agentStatus;
    String agentReferencePoint;
    String agentComment;
    int companyId;
    int neighborhoodId;
    String agentUser;
    int countId;

    factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        agentId: json["agentId"],
        agentEmployeeId: json["agentEmployeeId"],
        agentFullname: json["agentFullname"],
        agentPhone: json["agentPhone"],
        agentEmail: json["agentEmail"],
        agentStatus: json["agentStatus"],
        agentReferencePoint: json["agentReferencePoint"],
        agentComment: json["agentComment"],
        companyId: json["companyId"],
        neighborhoodId: json["neighborhoodId"],
        agentUser: json["agentUser"],
        countId: json["countId"],
    );

    Map<String, dynamic> toJson() => {
        "agentId": agentId,
        "agentEmployeeId": agentEmployeeId,
        "agentFullname": agentFullname,
        "agentPhone": agentPhone,
        "agentEmail": agentEmail,
        "agentStatus": agentStatus,
        "agentReferencePoint": agentReferencePoint,
        "agentComment": agentComment,
        "companyId": companyId,
        "neighborhoodId": neighborhoodId,
        "agentUser": agentUser,
        "countId": countId,
    };
}
