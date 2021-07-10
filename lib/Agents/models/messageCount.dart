import 'dart:convert';

// To parse this JSON data, do
//
//     final dataAgent = dataAgentFromJson(jsonString);

MessageAccount messageAccountsFromJson(String str) => MessageAccount.fromJson(json.decode(str));

String messageAccountsToJson(MessageAccount data) => json.encode(data.toJson());

class MessageAccount {
    MessageAccount({
        this.ok,
        this.type,
        this.title,
        this.message
    });

    bool ok;
    String type;
    String title;
    String message;

    factory MessageAccount.fromJson(Map<String, dynamic> json) => MessageAccount(
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
    fromJson(decode) {}
}