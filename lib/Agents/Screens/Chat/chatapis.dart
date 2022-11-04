
import 'dart:convert';

import 'package:flutter_auth/Agents/Screens/Chat/socketChat.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
//import 'dart:convert' show json;

class ChatApis {
  
  final StreamSocket streamSocket = StreamSocket(host: '192.168.1.3:3010');
  List info = [];    
  dynamic getDataUsuariosVar;

  void dataLogin(String id,String rol,String nombre)async { 
    streamSocket.socket.connect();    
    var dataU = await http.get(Uri.parse('http://192.168.1.3:8080/api/usuarios/$id'));  
    var dataU2 = await http.get(Uri.parse('http://192.168.1.3:8080/api/usuarios'));  
    var dataS = await http.get(Uri.parse('http://192.168.1.3:8080/api/salas'));  
    var dataM = await http.get(Uri.parse('http://192.168.1.3:8080/api/mensajes')); 
    final sendDataU = jsonDecode(dataU.body);
    final sendDataU2 = jsonDecode(dataU2.body);
    final sendDataS = jsonDecode(dataS.body);
    final sendDataM = jsonDecode(dataM.body);    
    Map data = {
      'send': {'nombre':nombre.toUpperCase(), 'rol': rol.toUpperCase(),'id': id},
      'send2': sendDataU,
      'send3': sendDataU2['usuarios'],
      'send4': sendDataS['salas'],
      'send5':sendDataM['mensajes']
    };
    String str = json.encode(data);
    streamSocket.socket.emit('login_F',str);
  }
  void sendMessage(String message, String sala, String nombre, String id, String motId, String nameDriver, String idDb)async{
    DateTime now = DateTime.now();
    String formattedHour = DateFormat('kk:mm:ss').format(now);
    var formatter = new DateFormat('dd');
    String dia = formatter.format(now);
    var formatter2 = new DateFormat('MM');
    String mes = formatter2.format(now);
    var formatter3 = new DateFormat('yy');
    String anio = formatter3.format(now);
    print(message);
    streamSocket.socket.emit('enviar-mensaje', {
      'mensaje': message,
      'sala': sala,
      'user': nombre,
      'id': id,
      'hora': formattedHour,
      'dia': dia,
      'mes': mes,
      'año': anio
    }); 
    Map sendMessage ={
      "id_emisor": idDb, 
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
      String str = json.encode(sendMessage);
    var ok =await http.post(Uri.parse('http://192.168.1.3:8080/api/mensajes'), 
        body: str, headers: {"Content-Type": "application/json" });
        print(ok.body);
  }

  void getDataUsuarios(dynamic getData){
    getDataUsuariosVar = getData;  
    //print(getDataUsuariosVar);     
  }
  void confirmOrCancel(String confirmOrCancel)async{
    streamSocket.socket.emit('peticion', confirmOrCancel);
    // var sala = getDataUsuariosVar['sala'];
    // var modId = getDataUsuariosVar['mot_id'];
    Map info = {
      'idU': '8',
      'Estado': confirmOrCancel
    };
    String str = json.encode(info);
    await http.put(Uri.parse("http://192.168.1.3:8080/api/salas/4"),headers: {"Content-Type": "application/json" },
      body: str
    );

    var response1 = await http.get(Uri.parse('http://192.168.1.3:8080/api/salas/Tripid/4')); 
    final sendData1 = jsonDecode(response1.body);
    var response2 = await http.get(Uri.parse('http://192.168.1.3:8080/api/salas/userId/0')); 
    final sendData2 = jsonDecode(response2.body);

    Map info2 = {
      'info1': sendData1['salas']['Agentes'],
      'info2':sendData2['salas']
    };
    String str2 = json.encode(info2);
    streamSocket.socket.emit('peticionI', str2);
  }

  void rendV(String modId, String sala)async{
    // var response1 = await http.get(Uri.parse('http://192.168.1.3:8080/api/salas/Tripid/$sala')); 
    // final sendData1 = jsonDecode(response1.body);
    // var response2 = await http.get(Uri.parse('http://192.168.1.3:8080/api/salas/userId/$modId')); 
    // final sendData2 = jsonDecode(response2.body);
    // dynamic listP = [];
    // //print(sendData1);
    // //print(sendData2);
    // // if (sendData1['errors']) {
    // //   listP = [];
    // // }
    // listP.add(sendData1['salas']['Agentes']);
    // // if (sendData2['errors']) {
    // //   sendData2['salas']=[];
    // // }
    // Map send = {
    //   'data1': sendData2['salas'],
    //   'data2':listP
    // };
    // String str2 = json.encode(send);
    // streamSocket.socket.emit('rendV', str2);
    
  }
}