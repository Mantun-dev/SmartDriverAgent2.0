
import 'dart:convert';

import 'package:flutter_auth/Agents/Screens/Chat/socketChat.dart';
import 'package:http/http.dart' as http;
//import 'dart:convert' show json;

class ChatApis {
  
  final StreamSocket streamSocket = StreamSocket(host: '192.168.1.3:3010');
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

  void saveMessages(dynamic body)async{     
      Map data = {
        'id_emisor': body['id_emisor'],
      'Nombre_emisor': body['Nombre_emisor'],
      'Mensaje': body['Mensaje'],
      'Sala': body['Sala'],
      'id_receptor':body['id_receptor'],
      'Nombre_receptor': body['Nombre_receptor'],
      'Tipo': body['Tipo'],
      'Dia': body['Dia'],
      'Mes': body['Mes'],
      'Año': body['Año'],
      'Hora': body['Hora']

      };
      print('********************************************');
      String str = json.encode(data);
      print(str);
      var response = await http.post(Uri.parse('http://192.168.1.3:8080/api/mensajes'), 
      body: str, headers: {"Content-Type": "application/json" });
      print(response.body);
  }
  void getDataUsuarios(dynamic getData){
    getDataUsuariosVar = getData;  
    print(getDataUsuariosVar);     
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
}