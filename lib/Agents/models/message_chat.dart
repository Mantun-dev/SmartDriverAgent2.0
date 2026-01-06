
import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

enum MessageStatus { sending, sent, delivered, read }

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
        this.id2,
        this.idReceptor,
        this.mostrarF,
        this.tempId,
        this.status = MessageStatus.sending,
    });

    String? user;
    dynamic sala;
    dynamic id;
    String? mensaje;
    dynamic hora;
    dynamic dia;
    dynamic mes;
    dynamic idReceptor;
    dynamic ao;
    String? tipo;
    bool? leido;
    dynamic id2;
    bool? mostrarF; // Nuevo campo mostrarF
    dynamic tempId;
    MessageStatus status;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        mensaje: json["mensaje"],
        sala: json["sala"],
        user: json["user"],
        id: json["id"],
        idReceptor: json["idReceptor"],
        hora: json["hora"],
        dia: json["dia"],
        mes: json["mes"],
        ao: json["año"],
        tipo: json["tipo"],
        leido: json["leido"],
        id2: json["_id"],
        mostrarF: json["mostrarF"], // Agregar el campo mostrarF al constructor
        tempId: json["tempId"],
        status: json["leido"] == true ? MessageStatus.read : MessageStatus.sent,
    );

    Map<String, dynamic> toJson() => {
        "mensaje": mensaje,
        "sala": sala,
        "user": user,
        "id": id,
        "idReceptor": idReceptor,
        "hora": hora,
        "dia": dia,
        "mes": mes,
        "año": ao,
        "tipo": tipo,
        "leido": leido,
        "_id": id2,
        "tempId": tempId,
        "mostrarF": mostrarF, // Agregar el campo mostrarF al método toJson
    };

    
      Message copyWith({
          String? user,
          dynamic sala,
          dynamic id,
          String? mensaje,
          // 🛑 ¡AÑADIR TODOS ESTOS CAMPOS COMO PARÁMETROS AQUÍ! 🛑
          dynamic hora,
          dynamic dia,
          dynamic mes,
          dynamic idReceptor,
          dynamic ao,
          // --------------------------------------------------------
          String? tipo,
          bool? leido,
          dynamic id2,
          bool? mostrarF,
          dynamic tempId,
          MessageStatus? status, // Permite actualizar solo el status
      }) {
          return Message(
              user: user ?? this.user,
              sala: sala ?? this.sala,
              id: id ?? this.id,
              mensaje: mensaje ?? this.mensaje,
              
              // 🛑 Propagar los valores 🛑
              hora: hora ?? this.hora, 
              dia: dia ?? this.dia,
              mes: mes ?? this.mes,
              idReceptor: idReceptor ?? this.idReceptor,
              ao: ao ?? this.ao,
              // -----------------------
              
              tipo: tipo ?? this.tipo,
              leido: leido ?? this.leido,
              id2: id2 ?? this.id2,
              mostrarF: mostrarF ?? this.mostrarF,
              tempId: tempId ?? this.tempId,
              status: status ?? this.status, // Actualización clave
          );
      }
}
