
import 'dart:convert';

import 'package:flutter_auth/Agents/Screens/Chat/socketChat.dart';
import 'package:flutter_auth/helpers/base_client.dart';
import 'package:flutter_auth/helpers/res_apis.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


//import 'dart:convert' show json;

class ChatApis {
  
  final StreamSocket streamSocket = StreamSocket(host: 'zuey4.localtonet.com');
  List info = [];    
  //dynamic getDataUsuariosVar;  
  final header = {"Content-Type": "application/json" };

  Future dataLogin(String id,String rol,String nombre)async { 
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
    print(streamSocket.socket.connected);
    streamSocket.socket.emit('login_F',str);    
  }
  void sendMessage(String message, String sala, String nombre, String id, String motId, String nameDriver, String idDb)async{
    DateTime now = DateTime.now();
    String formattedHour = DateFormat('hh:mm a').format(now);
    var formatter = new DateFormat('dd');
    String dia = formatter.format(now);
    var formatter2 = new DateFormat('MM');
    String mes = formatter2.format(now);
    var formatter3 = new DateFormat('yy');
    String anio = formatter3.format(now);

    streamSocket.socket.emit('enviar-mensaje', {'mensaje': message,'sala': sala,'user': nombre,'id': id,'hora': formattedHour,'dia': dia,'mes': mes,'año': anio, 'leido':false}); 
    Map sendMessage ={"id_emisor": idDb, "Nombre_emisor": nombre, "Mensaje": message, "Sala": sala, "id_receptor": motId, "Nombre_receptor": nameDriver, "Tipo": "MENSAJE", "Dia": dia, "Mes": mes, "Año": anio, "Hora": formattedHour};
    var ok =await BaseClient().post(RestApis.messages, sendMessage, {"Content-Type": "application/json" });   
    if (ok == null) return null;
  }

  // void getDataUsuarios(dynamic getData){
  //   getDataUsuariosVar = getData;  
  //   //print(getDataUsuariosVar);     
  // }
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

  void sendRead(dynamic data)async{    
      data["listM"].forEach((asm)async{

        if (asm['leido'] == false && asm['tipo'] == 'MENSAJE' && asm['id'] == 0) {          
          Map info = {
            'Leido': true
          };
          String str = json.encode(info);
          await http.put(Uri.parse(RestApis.messages+'/12'+'/0'),headers: {"Content-Type": "application/json" },body: str);
        }
      });

      var responseM = await BaseClient().get(RestApis.messages+'/12'+'/0'+'/8', {"Content-Type": "application/json" });  
      Map dat = {
        'mens': responseM
      };
      String str2 = json.encode(dat);
      streamSocket.socket.emit('updateM',str2);

  }

    void sendReadOnline(String dataSala,String dataId )async{    
      
      Map info = {
        'Leido': true
      };
      String str = json.encode(info);
      await http.put(Uri.parse(RestApis.messages+'/$dataSala'+'/$dataId'),headers: {"Content-Type": "application/json" },body: str);
      //print('kheeeee aaaaa pasooooo');
      //print(algo.body);
      var responseM = await BaseClient().get(RestApis.messages+'/$dataSala'+'/$dataId'+'/8', {"Content-Type": "application/json" });  
      //print(responseM);
      Map dat = {
        'mens': responseM
      };
      String str2 = json.encode(dat);
      streamSocket.socket.emit('updateM',str2);

  }

  
  Future<int> notificationCounter()async{
    var notification = await BaseClient().get(RestApis.messages+'/12', {"Content-Type": "application/json" }); 

   final not1 = jsonDecode(notification !=null?notification:'0');
    int? sendInt;
    if (not1 == 0) {      
      
      return 0;
    }else{
      not1['Agentes'].forEach((val)async{
        if (val['Id'] == 8){
          sendInt = val['sinLeer_Agente'];
        }
      });
      return sendInt!;
    }
  }

}