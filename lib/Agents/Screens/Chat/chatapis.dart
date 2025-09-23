import 'dart:convert';
import 'dart:io';

import 'package:flutter_auth/Agents/Screens/Chat/socketChat.dart';
import 'package:flutter_auth/helpers/base_client.dart';
import 'package:flutter_auth/helpers/res_apis.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

//import 'dart:convert' show json;

class ChatApis {
  final StreamSocket streamSocket = StreamSocket(host: 'wschat.smtdriver.com');
  List info = [];
  //dynamic getDataUsuariosVar;
  final header = {"Content-Type": "application/json"};

  Future dataLogin(String id, String rol, String nombre, String sala, String motId) async {
    streamSocket.socket.connect();
    print(streamSocket.socket.connected);
    // var dataU = await BaseClient().get(
    //     RestApis.usuerWithId + '/$id', {"Content-Type": "application/json"});
    // var dataU2 = await BaseClient()
    //     .get(RestApis.userwithOutId, {"Content-Type": "application/json"});
    var dataS = await BaseClient().get(RestApis.rooms + '/Tripid' + '/$sala',
        {"Content-Type": "application/json"});
    var dataM = await BaseClient().get(
        RestApis.messages + '/$sala' + "/$id" + "/$motId",
        {"Content-Type": "application/json"});
    if (dataS == null || dataM == null)
      return null;
    // final sendDataU = jsonDecode(dataU);
    // final sendDataU2 = jsonDecode(dataU2);
    final sendDataS = jsonDecode(dataS);
    final sendDataM = jsonDecode(dataM);
    Map data = {
      'send': {
        'nombre': nombre.toUpperCase(),
        'rol': rol.toUpperCase(),
        'id': id,
        'sala': sala
      },
      'send2': sendDataS['salas'],
      'send3': sendDataM['listM'],
      // 'send4': ,
      // 'send5':
    };
    String str = json.encode(data);
    streamSocket.socket.emit('login_F2', str);
  }

  void sendMessage(String message, String sala, String nombre, String id,
      String motId, String nameDriver) async {
    DateTime now = DateTime.now();
    String formattedHour = DateFormat('hh:mm a').format(now);
    var formatter = new DateFormat('dd');
    String dia = formatter.format(now);
    var formatter2 = new DateFormat('MM');
    String mes = formatter2.format(now);
    var formatter3 = new DateFormat('yy');
    String anio = formatter3.format(now);
    Map sendMessage = {
      "id_emisor": id,
      "Nombre_emisor": nombre,
      "Mensaje": message,
      "Sala": sala,
      "id_receptor": motId,
      "Nombre_receptor": nameDriver,
      "Tipo": "MENSAJE",
      "Dia": dia,
      "Mes": mes,
      "Año": anio,
      "Hora": formattedHour
    };

    //print(sendMessage);
    await BaseClient().post(RestApis.messages, sendMessage, {"Content-Type": "application/json"});
    streamSocket.socket.emit('enviar-mensaje2', {
      'mensaje': message,
      'sala': sala,
      'user': nombre,
      'id': id,
      'hora': formattedHour,
      'dia': dia,
      'mes': mes,
      'año': anio,
      'leido': false
    });
    Map sendNotification = {
      "receiverId": motId,
      "receiverRole": "motorista",
      "textMessage": message,
      "hourMessage": formattedHour,
      "nameSender": nombre,
      "tripId": sala
    };
    //print(motId);
    await BaseClient().post(
        'https://admin.smtdriver.com/sendMessageNotification',
        sendNotification,
        {"Content-Type": "application/json"});
    //print('adsadasdsaaasddsad');
    //print(se);
  }

  Future<void> sendAudio(
    String audioPath, String sala, String nombre, String id,
    String motId, String nameDriver) async {
    try {
      DateTime now = DateTime.now();
      String formattedHour = DateFormat('hh:mm a').format(now);
      String dia = DateFormat('dd').format(now);
      String mes = DateFormat('MM').format(now);
      String anio = DateFormat('yy').format(now);

      if (await File(audioPath).exists()) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(RestApis.audios), // Reemplaza con la URL correcta
        );

        var audioFile = File(audioPath);
        if (!audioFile.existsSync()) {
          //print('Archivo de audio no encontrado en la ruta especificada.');
          return;
        }
        //print( audioFile.path.split('/').last);
        // Agregar el archivo de audio al campo de archivo en la solicitud
        request.files.add(
          http.MultipartFile(
            'audio', // Nombre del campo que se espera en el servidor
            audioFile.readAsBytes().asStream(),
            audioFile.lengthSync(),
            filename: audioFile.path.split('/').last, // Obtener el nombre del archivo
          ),
        );

        var response = await request.send();
          String responseBody = await response.stream.bytesToString();
          //print(responseBody);
          var resp = json.decode(responseBody);

        if (response.statusCode != 200) {
            //print(responseBody);
            return;
          }
          var audioName = resp['audioName'];

          Map<String, dynamic> sendMessage = {
            "id_emisor": id,
            "Nombre_emisor": nombre,
            "Sala": sala,
            "id_receptor": motId,
            "Nombre_receptor": nameDriver,
            "Tipo": "AUDIO",
            "Mensaje": audioName,
            "Dia": dia,
            "Mes": mes,
            "Año": anio,
            "Hora": formattedHour,
          };
          String sendDataM = json.encode(sendMessage);

          await http.post(
            Uri.parse(RestApis.messages),
            body: sendDataM,
            headers: {"Content-Type": "application/json"},
          );

          // Emitir el mensaje de audio a través del socket
          streamSocket.socket.emit('enviar-mensaje2', {
            'mensaje': audioName,
            'sala': sala,
            'user': nombre,
            'id': id,
            'hora': formattedHour,
            'dia': dia,
            'mes': mes,
            'año': anio,
            'leido': false,
            'tipo': 'AUDIO',
          });

          Map<String, dynamic> sendNotification = {
            "receiverId": motId,
            "receiverRole": "motorista",
            "textMessage": 'Mensaje de voz',
            "hourMessage": formattedHour,
            "nameSender": nombre,
            "tripId": sala
          };
          await BaseClient().post(
            'https://admin.smtdriver.com/sendMessageNotification',
            sendNotification,
            {"Content-Type": "application/json"},
          );
      } else {
        //print('Audio no encontrado');
        return;
      }
    } catch (error) {
      //print("Error sending audio: $error");
    }
  }

  Future<dynamic> registerCallerAndSendNotification(tripId, callerId, callerIdDevice, callerType, receiverId, receiverType, userId, userType, rol, nameSender)async{
    Map<String, dynamic> registerUser = {
      "tripId": tripId,
      "callerId": callerId,
      "callerIdDevice": callerIdDevice,
      "callerType": callerType,
      "receiverId": receiverId,
      "receiverType": receiverType
    };

    Map<String, dynamic> sendNotification = {      
      "callStatus": "answered",
      "tripId": tripId,
      "callerId": callerId,
      "callerType": callerType,
      "receiverId": receiverId,
      "receiverType": receiverType,
      "userId": userId,
      "userType": userType,
      "receptorId": receiverId,
      "rol": rol,
      "nameSender": nameSender
    };

    var roomIdResponse = await BaseClient().post('https://admin.smtdriver.com/registerCallerToTrip',registerUser,{"Content-Type": "application/json"},);    
    await BaseClient().post('https://admin.smtdriver.com/sendNotificationToCall',sendNotification,{"Content-Type": "application/json"},);
    final data = jsonDecode(roomIdResponse);
    final roomId = data['message'][0]['roomId'];
    print(roomId);
    return roomId;
  }

  Future<dynamic> getDeviceTargetId(rol, receiverId) async{
    Map<String, dynamic> data = {
      "rol": rol,
      "receptorId": receiverId
    };
    print(data);
    var roomIdResponse = await BaseClient().post('https://admin.smtdriver.com/sendDeviceIdToCall',data,{"Content-Type": "application/json"},);    
    final dataR = jsonDecode(roomIdResponse);
    final deviceId = dataR['device']['deviceId'];
    print(deviceId);
    return deviceId;
  }

  // void getDataUsuarios(dynamic getData){
  //   getDataUsuariosVar = getData;
  //   //print(getDataUsuariosVar);
  // }
  void confirmOrCancel(String confirmOrCancel) async {
    streamSocket.socket.emit('peticion', confirmOrCancel);
    // var sala = getDataUsuariosVar['sala'];
    // var modId = getDataUsuariosVar['mot_id'];
    Map info = {'idU': '8', 'Estado': confirmOrCancel};
    String str = json.encode(info);
    await http.put(Uri.parse(RestApis.rooms + "/12"),
        headers: {"Content-Type": "application/json"}, body: str);

    var response1 =
        await BaseClient().get(RestApis.rooms + '/Tripid/12', header);
    var response2 =
        await BaseClient().get(RestApis.rooms + '/userId/0', header);
    if (response1 == null || response2 == null) return null;
    final sendData1 = jsonDecode(response1);
    final sendData2 = jsonDecode(response2);

    Map info2 = {
      'info1': sendData1['salas']['Agentes'],
      'info2': sendData2['salas']
    };
    String str2 = json.encode(info2);
    streamSocket.socket.emit('peticionI', str2);
  }

  void sendRead(String? sala, String? driverId, String agentId) async {
    Map info = {'Leido': true};
    String str = json.encode(info);
    await http.put(
        Uri.parse(RestApis.messages + '/$sala' + '/$driverId' + '/$agentId'),
        headers: {"Content-Type": "application/json"},
        body: str);
  }

  void sendReadOnline(String dataSala, String dataId, String agentId) async {
    Map info = {'Leido': true};
    // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    // print(dataId);
    String str = json.encode(info);
    await http.put(
        Uri.parse(RestApis.messages + '/$dataSala' + '/$dataId' + '/$agentId'),
        headers: {"Content-Type": "application/json"},
        body: str);
    //print('kheeeee aaaaa pasooooo');
    //print(algo.body);
    var responseM = await BaseClient().get(
        RestApis.messages + '/$dataSala' + '/$dataId' + '/$agentId',
        {"Content-Type": "application/json"});
    //print(responseM);
    Map dat = {'mens': responseM};
    String str2 = json.encode(dat);
    streamSocket.socket.emit('updateM', str2);
  }

  Future<int?> notificationCounter(String tripId, String? agentId) async {
    var notification = await BaseClient().get(
        RestApis.messages + '/$tripId', {"Content-Type": "application/json"});
    if (notification != null) {
      
    
    final not1 = jsonDecode(notification != null ? notification : '0');
    int? sendInt = 0;
    if (not1 == 0 || not1 == null) {
      return 0;
    } else {
      not1['Agentes'].forEach((val) async {
        if (val['Id'].toString() == agentId!) {
          sendInt = val['sinLeer_Agente'];
        }
      });
      return sendInt;
    }
  }

  return 0;
  }
}