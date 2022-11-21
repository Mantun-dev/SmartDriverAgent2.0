// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
    Message({
        this.user,
        this.sala,
        this.id,
        this.mensaje,
        this.hora,
        this.dia,
        this.mes,
        this.ao,
        this.tipo,
        this.leido,
        this.id2
    });

    String? user;
    dynamic sala;
    dynamic id;
    String? mensaje;
    dynamic hora;
    dynamic dia;
    dynamic mes;
    dynamic ao;
    String? tipo;
    bool? leido;
    dynamic id2;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        mensaje: json["mensaje"],
        sala: json["sala"],
        user: json["user"],
        id: json["id"],
        hora: json["hora"],
        dia: json["dia"],
        mes: json["mes"],
        ao: json["año"],
        tipo: json["tipo"],
        leido: json["leido"],
        id2: json["_id"]
    );

    Map<String, dynamic> toJson() => {
        "mensaje": mensaje,
        "sala": sala,
        "user": user,
        "id": id,
        "hora": hora,
        "dia": dia,
        "mes": mes,
        "año": ao,
        "tipo": tipo,
        "leido": leido,
        "_id": id2
    };
}
