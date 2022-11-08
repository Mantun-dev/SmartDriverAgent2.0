
import 'dart:convert';

import 'package:flutter_auth/Agents/Screens/Chat/socketChat.dart';
import 'package:flutter_auth/helpers/base_client.dart';
import 'package:flutter_auth/helpers/res_apis.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


//import 'dart:convert' show json;

class ChatApis {
  
  final StreamSocket streamSocket = StreamSocket(host: '192.168.1.4:3010');
  List info = [];    
  dynamic getDataUsuariosVar;  
  final header = {"Content-Type": "application/json" };

  Future dataLogin(String id,String rol,String nombre)async { 
    print(id+rol+nombre);      
    streamSocket.socket.connect();    
    var dataU  =  await  BaseClient().get(RestApis.usuerWithId+ '/$id', {"Content-Type": "application/json" });     
    var dataU2 =  await  BaseClient().get(RestApis.userwithOutId,      {"Content-Type": "application/json" });    
    var dataS  =  await  BaseClient().get(RestApis.rooms,              {"Content-Type": "application/json" });    
    var dataM  =  await  BaseClient().get(RestApis.messages,           {"Content-Type": "application/json" });   
    if (dataU == null|| dataU2 == null || dataS == null|| dataM == null) return null; 
    final sendDataU = jsonDecode(dataU);
    final sendDataU2 = jsonDecode(dataU2);
    final sendDataS = jsonDecode(dataS);    
    final sendDataM = jsonDecode(dataM);  
    Map data = {'send': {'nombre':nombre.toUpperCase(), 'rol': rol.toUpperCase(),'id': id},'send2': sendDataU,'send3': sendDataU2['usuarios'],'send4': sendDataS['salas'],'send5':sendDataM['mensajes']};
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
    streamSocket.socket.emit('enviar-mensaje', {'mensaje': message,'sala': sala,'user': nombre,'id': id,'hora': formattedHour,'dia': dia,'mes': mes,'año': anio}); 
    Map sendMessage ={"id_emisor": idDb, "Nombre_emisor": nombre, "Mensaje": message, "Sala": sala, "id_receptor": motId, "Nombre_receptor": nameDriver, "Tipo": "MENSAJE", "Dia": dia, "Mes": mes, "Año": anio, "Hora": formattedHour};
 
    var ok =await BaseClient().post(RestApis.messages, sendMessage, {"Content-Type": "application/json" });   
    if (ok == null) return null;
    print(ok);
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
    await http.put(Uri.parse(RestApis.rooms+"/12"),headers: {"Content-Type": "application/json" },body: str);

    var response1 = await BaseClient().get(RestApis.rooms+'/Tripid/12', header);      
    var response2 = await BaseClient().get(RestApis.rooms+'/userId/0', header);   
    if (response1 == null || response2 == null) return null;
    final sendData1 = jsonDecode(response1);
    final sendData2 = jsonDecode(response2);

    Map info2 = {'info1': sendData1['salas']['Agentes'],'info2':sendData2['salas']};
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