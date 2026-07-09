import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';

import 'package:flutter_auth/Agents/Screens/Chat/chatapis.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/warning_dialog.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
// import 'package:flutter_auth/Agents/Screens/calls/WebRTCCallPage.dart';
import 'package:flutter_auth/Agents/models/tripAgent.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/helpers/base_client.dart';

import 'package:flutter_auth/helpers/res_apis.dart';

import 'package:flutter_auth/providers/chat.dart';
import 'package:flutter_auth/providers/device_info.dart';
// import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

import 'package:flutter_svg/svg.dart';

// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:record/record.dart';
// import 'package:record/record.dart';


import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';

import '../../../components/warning_dialog.dart';
import '../../../providers/JitsiCallPage.dart';
import '../../models/message_chat.dart';

import '../../models/network.dart';
import 'component/audio.dart';
import 'listchats.dart';
import 'socketChat.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final String nombre;
  final String id;
  final String rol;
  final String sala;
  final String driverId;
  const ChatScreen(
      {Key? key,
      required this.nombre,
      required this.id,
      required this.rol,
      required this.sala,
      required this.driverId})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // final _socketResponse = StreamController<dynamic>();
  // Stream<dynamic> get getResponse => _socketResponse.stream;
  IO.Socket? socket;
  final TextEditingController _messageInputController = TextEditingController();
  var usuario = {};
  var arrayStructure = [];
  String? sala;
  String? id;
  String? idDb;
  String? modid;
  String? nameDriver;
  bool? isLoading = false;
  ScrollController _scrollController = new ScrollController();
  final arrayTemp = [];
  final StreamSocket streamSocket = StreamSocket(host: 'wschat.smtdriver.com');
  // final StreamSocket streamSocket = StreamSocket(host: '192.168.0.9:3000');
  bool activateMic = false;
  late AudioPlayer _audioPlayer;
  late Record _audioRecord;
  List<String> _audioList = [];
  String filePathP = '';
  dynamic allowCallBtn;
  bool? permiso;
  String? msg;
  dynamic allow;
  bool _isCalling = false;

  Uuid uuid = Uuid();

  Map<String, dynamic> _getDateTimeParts() {
    final now = DateTime.now();
    return {
      'hora': '${now.hour}:${now.minute}', // Ajusta el formato según tu backend
      'dia': now.day,
      'mes': now.month,
      'ao': now.year,
    };
  }


   _sendMessage(String text) {
    if (streamSocket.socket.disconnected) {
      //print('Socket desconectado, intentando reconectar...');
      streamSocket.socket.connect();
    }

    final messageText = text.trim();
    if (messageText.isEmpty) return; 

    // 1. Generar ID temporal único para rastreo
    final tempId = DateTime.now().millisecondsSinceEpoch.toString(); 
    final now = DateTime.now();
    final formattedHour = DateFormat('hh:mm a').format(now);

    final pendingMessage = Message(
        id: widget.id, // <--- CLAVE: ID REAL del emisor (Tú) para la alineación
        idReceptor: widget.driverId,
        user: widget.nombre,
        mensaje: messageText,
        // ... (otros campos de fecha/tipo)
        dia: DateFormat('dd').format(now), // -> Ejemplo: "10"
        mes: DateFormat('MM').format(now), // -> Ejemplo: "12"
        ao: DateFormat('yy').format(now),  // -> Ejemplo: "25"
        hora: formattedHour,
        leido: false, 
        status: MessageStatus.sending, // PENDIENTE (RELOJ)
        tempId: tempId, // <--- ID TEMPORAL para actualización
    );

    Provider.of<ChatProvider>(context, listen: false).addNewMessage(pendingMessage);
  
    _messageInputController.clear();

    ChatApis().sendMessage(messageText, widget.sala.toString(), widget.nombre, widget.id,
        widget.driverId, nameDriver!, tempId); // <--- PASAR tempId AQUÍ

  }



  void _sendAudio(String audioPath) async {
    if (await File(audioPath).exists()) {
      ChatApis().sendAudio(audioPath, widget.sala, widget.nombre, widget.id, widget.driverId, nameDriver!);
      // Resto del código
    } else {
      //print('El archivo de audio no existe en la ruta especificada: $audioPath');
    }
  }



  desconectar(){
    streamSocket.socket.emit('salir');
    streamSocket.socket.disconnect();
    streamSocket.socket.close();
    streamSocket.socket.dispose();
    deleteAllTempAudioFiles();
  }

  @override
  void initState() {
    super.initState();
    fetchTripsButton();
    _audioPlayer = AudioPlayer();
    _audioRecord = Record();
    //Important: If your server is running on localhost and you are testing your app on Android then replace http://localhost:3000 with http://10.0.2.2:3000
    ChatApis().dataLogin(
        widget.id, widget.rol, widget.nombre, widget.sala, widget.driverId);
    streamSocket.socket.onDisconnect((_) {
      //print('Desconectado del chat. Intentando reconectar...');
    });

    datas();
    getMessagesDB();
    streamSocket.socket.onReconnect((_) {
      //print('Reconectado al chat.');
      _reconnectEvents();
    });
    //inicializador del botón de android para manejarlo manual
    BackButtonInterceptor.add(myInterceptor);
  }

  void _reconnectEvents() {
    

    streamSocket.socket.on('cargarM', (listM) {
      if (mounted) {
        Provider.of<ChatProvider>(context, listen: false).mensaje2.clear();
        listM.forEach((value) {
          Provider.of<ChatProvider>(context, listen: false)
              .addNewMessage(Message.fromJson(value));
        });
      }
    });

    streamSocket.socket.on('enviar-mensaje2', ((data) {
        print('Nuevo mensaje recibido: $data');
        print(mounted);
      if (mounted) {
        final incomingMessage = Message.fromJson(data is List ? data[0] : data);
            final currentAgentId = widget.id;       // ESTE eres TÚ (el Agente)
            final currentDriverId = widget.driverId;   // ESTA es la OTRA PERSONA (el Motorista)
            final senderId = incomingMessage.id;
            final receiverId = incomingMessage.idReceptor;
            final isFromCurrentDriverToAgent  = (senderId == widget.driverId&& receiverId == widget.id);
            final isFromCurrentAgentToDriver  = (senderId ==  widget.id && receiverId == widget.driverId);

            // CLAVE: El servidor nos devuelve el ID temporal que enviamos
           final receivedTempId = incomingMessage.tempId; 

            if (isFromCurrentDriverToAgent || isFromCurrentAgentToDriver) {
              if (isFromCurrentAgentToDriver && receivedTempId != null) {
                  // Ya está en la lista (lo agregaste en _sendMessage).
                  // ¡Simplemente actualizamos su estado!
                  
                  // Actualizar a MessageStatus.delivered/read (Doble check)
                  Provider.of<ChatProvider>(context, listen: false).updateMessageStatus(
                      receivedTempId, 
                      MessageStatus.delivered // Ya fue emitido y retransmitido
                  );
                  print('🟢 Mensaje propio actualizado (Echo). ID: $receivedTempId');

              } else if(isFromCurrentDriverToAgent){
                if (data is List) {
                    // Si es una lista, itera sobre cada elemento
                    data.forEach((element) {
                        Provider.of<ChatProvider>(context, listen: false).addNewMessage(Message.fromJson(element));
                    });
                } else {
                    // Si es un solo objeto, agrégalo directamente
                    Provider.of<ChatProvider>(context, listen: false).addNewMessage(Message.fromJson(data));
                }
                ChatApis().sendRead(widget.sala, widget.driverId, widget.id);
              }
            }else{
              print('Mensaje recibido para otra sala: ${incomingMessage.sala}, actual es: ${widget.sala}');
            }
      }
    }));
  }


  void getMessagesDB() async {

    Provider.of<ChatProvider>(context, listen: false).mensaje2.clear();
    var messages = await BaseClient().get(
        RestApis.messages +
            '/${widget.sala}' +
            "/${widget.id}" +
            "/${widget.driverId}",
        {"Content-Type": "application/json"});

    if (messages == null) return null;
    final data = jsonDecode(messages);

    setState(() {
      nameDriver = data["nombreM"];
    });
    data["listM"].forEach((element) {
      arrayStructure.add({
        "mensaje": element["Mensaje"],
        "sala": element["Sala"],
        "user": element["Nombre_emisor"],
        "id": element["id_emisor"],
        "hora": element["Hora"],
        "dia": element["Dia"],
        "mes": element["Mes"],
        "año": element["Año"],
        "tipo": element["Tipo"],
        "leido": element["Leido"]
      });

      if(element["Tipo"]=='AUDIO'){
        _audioList.add('audio');
      }
    });
    controllerLoading(true);
    arrayStructure.forEach((result) {
      if (mounted) {
        Provider.of<ChatProvider>(context, listen: false)
            .addNewMessage(Message.fromJson(result));
      }
    });
    ChatApis().sendRead(widget.sala, widget.driverId, widget.id);
    //print(arrayStructure);
  }

  void datas() {
    streamSocket.socket.on('enviar-mensaje2', ((data) {
        print('Nuevo mensaje recibido: $data');
        print(mounted);
      if (mounted) {
        final incomingMessage = Message.fromJson(data is List ? data[0] : data);
            final currentAgentId = widget.id;       // ESTE eres TÚ (el Agente)
            final currentDriverId = widget.driverId;   // ESTA es la OTRA PERSONA (el Motorista)
            final senderId = incomingMessage.id;
            final receiverId = incomingMessage.idReceptor;
            final isFromCurrentDriverToAgent  = (senderId == widget.driverId&& receiverId == widget.id);
            final isFromCurrentAgentToDriver  = (senderId ==  widget.id && receiverId == widget.driverId);

            // CLAVE: El servidor nos devuelve el ID temporal que enviamos
           final receivedTempId = incomingMessage.tempId; 

            if (isFromCurrentDriverToAgent || isFromCurrentAgentToDriver) {
              if (isFromCurrentAgentToDriver && receivedTempId != null) {
                  // Ya está en la lista (lo agregaste en _sendMessage).
                  // ¡Simplemente actualizamos su estado!
                  
                  // Actualizar a MessageStatus.delivered/read (Doble check)
                  Provider.of<ChatProvider>(context, listen: false).updateMessageStatus(
                      receivedTempId, 
                      MessageStatus.delivered // Ya fue emitido y retransmitido
                  );
                  print('🟢 Mensaje propio actualizado (Echo). ID: $receivedTempId');

              } else if(isFromCurrentDriverToAgent){
                if (data is List) {
                    // Si es una lista, itera sobre cada elemento
                    data.forEach((element) {
                        Provider.of<ChatProvider>(context, listen: false).addNewMessage(Message.fromJson(element));
                    });
                } else {
                    // Si es un solo objeto, agrégalo directamente
                    Provider.of<ChatProvider>(context, listen: false).addNewMessage(Message.fromJson(data));
                }
                ChatApis().sendRead(widget.sala, widget.driverId, widget.id);
              }
            }else{
              print('Mensaje recibido para otra sala: ${incomingMessage.sala}, actual es: ${widget.sala}');
            }
      }
    }));
    // Cuando se usa el evento 'cargarM', sí limpias para cargar la lista completa
    streamSocket.socket.on('cargarM', ((listM) {
      if (mounted) {
        Provider.of<ChatProvider>(context, listen: false).mensaje2.clear();
        listM.forEach((value) {
          Provider.of<ChatProvider>(context, listen: false)
              .addNewMessage(Message.fromJson(value));
        });
      }
    }));
    streamSocket.socket.on('detectarE', (data) => print(data));
    streamSocket.socket.on('entrarChat_flutter', (data) {

    });    

    controllerLoading(false);
  }

  void controllerLoading(bool? controller) {
    setState(() {
      isLoading = controller;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
    _audioRecord.dispose();
    _messageInputController.dispose();

    //creación del dispose para removerlo después del evento
    BackButtonInterceptor.remove(myInterceptor);
  }

  Future<TripsList> fetchTripsButton() async {
    http.Response response = await http.get(Uri.parse('$ip/api/trips/${prefs.nombreUsuario}'));
    if (response.statusCode == 200) {
      final trip = TripsList.fromJson(json.decode(response.body));
      for (var i = 0; i < trip.trips.length; i++) {
        setState(() {          
          trip.trips[i].allowCallBtn = allowCallBtn;          
        });
      }
    } else {
      print('Failed to load Data');
    }
    return fetchTripsButton();
  }

 Future<Map<String, dynamic>> validateTripCall(receiverId, receiverType) async {
  try {

    var responseString = await BaseClient().get('https://admin.smtdriver.com/validateCallAvailability/$receiverId/$receiverType',{"Content-Type": "application/json"});
    final data = jsonDecode(responseString);

    // Asumiendo que la API devuelve [{allow: 1, msg: "..."}]
    // Tu log muestra `[{allow: 1, msg: Se puede realizar la llamada}]`
    // Esto sugiere que `data` es una lista.
    if (data is List && data.isNotEmpty) {
      return {'allow': data[0]['allow'], 'msg': data[0]['msg']};
    } else {
      // Manejar caso donde la respuesta no es la esperada
      return {'allow': 0, 'msg': 'Respuesta inesperada del servidor.'};
    }
  } catch (e) {
    print("Error en validateTripCall: $e");
    return {'allow': 0, 'msg': 'Error de red o servidor al validar: $e'};
  }
}


  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //print("BACK BUTTON!"); // Do some stuff.
    streamSocket.socket.emit('salir');
    streamSocket.socket.disconnect();
    streamSocket.socket.close();
    streamSocket.socket.dispose();

    //print(streamSocket.socket.connected);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
        (Route<dynamic> route) => false);

    return true;
  }


   Future<bool> checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error checking permission: $e");
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {

     String fechaA = '';
    
    bool fecha(fechaBs){
      if(fechaA!=fechaBs){
        fechaA=fechaBs;
        return true;
      }
      else
        return false;
    }

    // ignore: non_constant_identifier_names
    String hoy_ayer(fechaBs){

      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);

      String day = date.day.toString();
      String month = date.month.toString();
      String year = date.year.toString();

      if(day.toString().length!=2){
        day='0'+day;
      }
      if(month.toString().length!=2){
        month='0'+month;
      }
      if(year.toString().length==4){
        year=year[2]+year[3];
      }

      String fecha = '$month/$day/$year';

      if(fecha==fechaBs){
        fechaA=fechaBs;
        return 'Hoy';
      }
      else
        return fechaBs;
    }

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(56),
                    child: AppBar(
                      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                        elevation: 0,
                        iconTheme: IconThemeData(size: 25),
                        automaticallyImplyLeading: false, 
                        actions: <Widget>[
                        //aquí está el icono de las notificaciones
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                                desconectar();
                                fetchProfile().then((value) {
                                Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
                                          pageBuilder: (_, __, ___) => ChatsList(
                                            id: '${value.agentId}',
                                            rol: 'agente',
                                            nombre: '${value.agentFullname}',
                                          ),
                                          transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                            return SlideTransition(
                                              position: Tween<Offset>(
                                                begin: Offset(1.0, 0.0),
                                                end: Offset.zero,
                                              ).animate(animation),
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                });
                              },
                            child: Container(
                              width: 45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryIconTheme.color!,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(
                                  "assets/icons/flecha_atras_oscuro.svg",
                                  color: Theme.of(context).primaryIconTheme.color!,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 10),

                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              

                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset(
                                  "assets/images/perfilmotorista.png",
                                ),
                              ),
                              SizedBox(width: 5),
                              nameDriver != null ? 
                                Flexible(
                                  child: Text(
                                    nameDriver!,
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18),
                                  ),
                                ) 
                              : Text(''),
                              SizedBox(width: 5),
                              InkWell(
                                  onTap: _isCalling ? null : () async {
                                  setState(() {
                                    _isCalling = true; // Mostrar indicador de carga
                                  });

                                  try {
                                    // AWAIT la llamada a validateTripCall y OBTEN el resultado directamente
                                    String? deviceId = await getDeviceId();
                                    final results = await Future.wait([
                                          ChatApis().registerCallerAndSendNotification(widget.sala, widget.id ,deviceId , "agent", widget.driverId, "driver", widget.id, "agent", "motorista", widget.nombre),
                                          ChatApis().getDeviceTargetId('motorista', widget.driverId),
                                        ]);

                                        var roomId = results[0];
                                        // var deviceIdTarget = results[1];

                                        if (roomId == null) {
                                          throw Exception("Error: No se obtuvo roomId o deviceIdTarget de la API.");
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => JitsiCallPage(roomId: roomId.toString(), name: widget.nombre),
                                          ),
                                        );
                                  } catch (e) {
                                    print("Error durante el proceso de llamada: $e");
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      text: "Error al iniciar la llamada: $e",
                                    );
                                  } finally {
                                    setState(() {
                                      _isCalling = false; // Ocultar indicador de carga
                                    });
                                  }
                                },
                                child: Icon(Icons.call,
                                  color: Theme.of(context).textTheme.titleMedium!.color,
                                ),
                              ),
                
              // Overlay de carga
                            if (_isCalling)
                              Container(
                                color: Colors.black.withOpacity(0.5),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            
                            ],
                          )
                        ),

                      ],
                    ),
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: isLoading == true
                          ? body(fecha, hoy_ayer, context)
                          : Center(child: CircularProgressIndicator()
                        ),
                      ),
                    ],
                  ),
                ),
        if (_isCalling)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Color del indicador
              ),
            ),
          ),
      ],
    );
  }

  // Coloca esta función dentro de la clase Stateful (donde está tu 'body' y '_sendMessage')

  Column body(bool fecha(dynamic fechaBs), String hoyayer(dynamic fechaBs), BuildContext context) {
    Size size = MediaQuery.of(context).size;
    

    return Column(
                children: [
                  Expanded(
                    child: Consumer<ChatProvider>(
                      builder: (context, provider, child) =>
                          SingleChildScrollView(
                        reverse: true,
                        child: ListView.separated(
                          shrinkWrap: true,
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            var message = provider.mensaje[index];                                                        

                            if(fecha('${message.mes}/${message.dia}/${message.ao}')==true ){
                              message.mostrarF=true;
                            }

                            return Wrap(
                              alignment:
                                  message.id == widget.id
                                      ? WrapAlignment.end
                                      : WrapAlignment.start,
                              children: [
                                if(message.mostrarF==true)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 35, bottom: 35, left: 8, right: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 1,
                                            color: Color.fromRGBO(158, 158, 158, 1),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(hoyayer('${message.mes}/${message.dia}/${message.ao}'), style: TextStyle(color: Color.fromRGBO(158, 158, 158, 1), fontSize: 17)),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
                                            height: 1,
                                            color: Color.fromRGBO(158, 158, 158, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
  
                                Container(
                                  width: size.width/2,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        topRight: message.id == widget.id?Radius.zero:Radius.circular(8.0),
                                        bottomLeft:  message.id == widget.id? Radius.circular(8.0):Radius.zero,
                                        bottomRight: Radius.circular(8.0),
                                      ),
                                    ),
                                    color: message.id == widget.id? Theme.of(context).focusColor: Theme.of(context).cardColor,
                                    child: Padding(padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (message.mensaje != null) ...{ 
                                            if (message.tipo == 'AUDIO')... {
                                              AudioContainer(
                                                audioName: message.mensaje!,
                                                colorIcono: message.id == widget.id ? 
                                                 Colors.white: Theme.of(context).primaryColorDark,
                                                idSala: int.parse(message.sala),
                                              )  
                                            }else...{
                                              if(message.mensaje!.contains('position'))...{
                                                TextButton(
                                                onPressed: () {
                                                  // Lógica para manejar la posición
                                                  // Puedes abrir un mapa, por ejemplo
                                                  // o ejecutar alguna acción relacionada con la posición.
                                                },
                                                child: Text('Posición enviada',style: TextStyle(
                                                      color: message.id == widget.id
                                                          ? Colors.white
                                                          : Theme.of(context).primaryColorDark,
                                                      fontSize: 16)),
                                              )
                                              }else...{
                                                Text(
                                              message.mensaje!,
                                              style: TextStyle(
                                                  color: message.id == widget.id
                                                  ? Colors.white
                                                  : Theme.of(context).primaryColorDark,
                                              fontSize: 17),
                                            ),
                                              }
                                            },
                                                                                        
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Expanded(child: SizedBox()),
                                                // Mostrar hora (blanca si es mío, oscura si es del receptor)
                                                Text(
                                                  message.hora,
                                                  style: TextStyle(
                                                      color: message.id == widget.id
                                                          ? Colors.white
                                                          : Theme.of(context).primaryColorDark,
                                                      fontSize: 10),
                                                ),
                                                const SizedBox(width: 5),
                                                // SISTEMA UNIFICADO DE ESTADOS (Solo para mis mensajes)
                                                if (message.id == widget.id)
                                                  Builder(
                                                    builder: (context) {
                                                      switch (message.status) {
                                                        case MessageStatus.sending:
                                                          return const Icon(
                                                            Icons.access_time, // RELOJ
                                                            size: 16,
                                                            color: Colors.grey,
                                                          );
                                                        case MessageStatus.sent:
                                                          return const Icon(
                                                            Icons.done, // CHECK SIMPLE
                                                            size: 16,
                                                            color: Colors.grey,
                                                          );
                                                        case MessageStatus.delivered:
                                                          return const Icon(
                                                            Icons.done_all, // DOBLE CHECK GRIS (Entregado)
                                                            size: 16,
                                                            color: Colors.grey,
                                                          );
                                                        case MessageStatus.read:
                                                          return const Icon(
                                                            Icons.done_all, // DOBLE CHECK AZUL (Leído)
                                                            size: 16,
                                                            color: Color.fromRGBO(0, 255, 255, 1),
                                                          );
                                                        default:
                                                          // RESPALDO: Por si el mensaje no tiene status, usa la lógica antigua
                                                          return Icon(
                                                            message.leido == true ? Icons.done_all : Icons.done,
                                                            size: 16,
                                                            color: message.leido == true
                                                                ? const Color.fromRGBO(0, 255, 255, 1)
                                                                : Colors.grey,
                                                          );
                                                      }
                                                    },
                                                  ),
                                              ],
                                            )
                                          },
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                          separatorBuilder: (_, index) => const SizedBox(
                            height: 5,
                          ),
                          itemCount: provider.mensaje.length,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      //color: Gradiant2,
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () {
                              _messageInputController.text = "¿Viene en camino?";
                              if (_messageInputController.text.trim().isNotEmpty) {
                                _sendMessage(_messageInputController.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(40, 93, 169, 1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Theme.of(context).disabledColor, width: 1.0),
                              ),
                              padding: const EdgeInsets.all(12.0),
                            ),
                            child: const Text(
                              "¿Viene en camino?",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                          SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () {
                              _messageInputController.text = "Estoy aquí";
                              if (_messageInputController.text.trim().isNotEmpty) {
                                _sendMessage(_messageInputController.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(40, 93, 169, 1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Theme.of(context).disabledColor, width: 1.0),
                              ),
                              padding: const EdgeInsets.all(12.0),
                            ),
                            child: const Text(
                              "Estoy aquí",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () {
                              _messageInputController.text = "Estoy buscándolo";
                              if (_messageInputController.text.trim().isNotEmpty) {
                                _sendMessage(_messageInputController.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(40, 93, 169, 1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Theme.of(context).disabledColor, width: 1.0),
                              ),
                              padding: const EdgeInsets.all(12.0),
                            ),
                            child: const Text(
                              "Estoy buscándolo",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                              SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () {
                              _messageInputController.text = "Lo estoy viendo";
                              if (_messageInputController.text.trim().isNotEmpty) {
                                _sendMessage(_messageInputController.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(40, 93, 169, 1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Theme.of(context).disabledColor, width: 1.0),
                              ),
                              padding: const EdgeInsets.all(12.0),
                            ),
                            child: const Text(
                              "Lo estoy viendo",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 15, bottom: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).cardTheme.color,
                                border: Border.all(color: Theme.of(context).disabledColor),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      enabled: !activateMic ? true : false,
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
                                      controller: _messageInputController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 10),
                                        hintText: !activateMic ? 'Mensaje' : 'Grabando audio...',
                                        hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).hintColor, fontSize: 15),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  
                                  IconButton(
                                    color: chatSecond,
                                    onPressed: () {
                                      if (activateMic) return;
                                      if (_messageInputController.text.trim().isNotEmpty) {
                                        _sendMessage(_messageInputController.text.trim());
                                      }
                                    },
                                    icon: Icon(Icons.send, color: Theme.of(context).primaryIconTheme.color),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(40, 93, 169, 1),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Obteniendo ubicación, por favor espere...'), duration: Duration(seconds: 2)),
                                  );
                                  permiso = await checkLocationPermission();
                                  if (!permiso!) {
                                    WarningSuccessDialog().show(
                                      context,
                                      title: "Usted negó el acceso a la ubicación. Esto es necesario para poder abordar agentes. Si no da acceso en configuraciones, no podrá abordar agentes.",
                                      tipo: 1,
                                      onOkay: () async {
                                        try {
                                          AppSettings.openAppSettings();
                                        } catch (error) {
                                          //print(error);
                                        }
                                      },
                                    ); 
                                    return;
                                  }
                                  try {
                                    // Intentar primero con la última posición conocida para que sea instantáneo
                                    Position? position = await Geolocator.getLastKnownPosition();
                                    // Si no hay última posición, pedir la actual con un límite de tiempo
                                    if (position == null) {
                                      position = await Geolocator.getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.medium,
                                        timeLimit: const Duration(seconds: 7)
                                      );
                                    }
                                    print("Ubicación obtenida: ${position.latitude}, ${position.longitude}");
                                    _sendMessage("position: {${position.latitude}, ${position.longitude}}");
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error obteniendo ubicación: $e')),
                                    );
                                  }
                                },
                                icon: Icon(Icons.location_pin, color: Colors.white) ,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(40, 93, 169, 1),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  bool permiso= await checkAudioPermission();
                          
                                  if(permiso){
                                    if(!activateMic){
                                      startRecording();
                                    }else{
                                      stopRecording();
                                    }
                                  }else{
                                    WarningDialog().show(
                                      context,
                                      title: 'No dio permiso del uso del microfono',
                                      onOkay: () {
                                        try{
                                          AppSettings.openAppSettings();
                                        }catch(error){
                                          //print(error);
                                        }
                                      },
                                    );
                                  }
                                },
                                icon: !activateMic ? Icon(Icons.mic, color: Colors.white) : Icon(Icons.mic_off, color: Colors.red),
                              ),
                            ),
                          )
                        ],
                      ),
                    )

                  ),
                ],
              );
  }

  Future<bool> checkAudioPermission() async {
    // Verificar si se tiene el permiso de grabación de audio
    var status = await Permission.microphone.status;
    
    if (status.isGranted) {
      // Permiso concedido
      return true;
    } else {
      // No se ha solicitado el permiso, solicitarlo al usuario
      return false;
    }
  }

  void startRecording() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      String filePath = '${cacheDir.path}/${this.widget.sala}_recording${_audioList.length + 1}.m4a';
      await _audioRecord.start(path: filePath);

      setState(() {
        filePathP = filePath;
        activateMic = true;
      });

      await Future.delayed(Duration(seconds: 60), () {
        if (activateMic) {
          stopRecording();
        }
      });

    } catch (e) {
      // Handle any error during recording
      //'Error al iniciar la grabación: $e');
    }
  }

void stopRecording() async {
  try {
    // 1. DETENER la grabación. Esto garantiza que el archivo se guarde 
    // y devuelve la ruta confirmada del archivo finalizado.
    String? recordedFilePath = await _audioRecord.stop();

    if (recordedFilePath != null) {
      // 2. PAUSA OBLIGATORIA: Esperar un momento para que el sistema operativo 
      // y el plugin cierren el archivo completamente. Esto soluciona el 
      // error de Content-Length.
      await Future.delayed(const Duration(milliseconds: 500)); 
      
      // 3. Verificar que el archivo existe y no está vacío
      File audioFile = File(recordedFilePath);
      if (await audioFile.exists() && await audioFile.length() > 0) {
        
        // 4. Enviar el archivo
        _sendAudio(recordedFilePath);
        print('Grabación enviada desde: $recordedFilePath');
        
        setState(() {
          // Ya no necesitas 'filePathP' aquí, pero actualizas el estado
          activateMic = false;
          _audioList.add('audio');
        });
      } else {
        // Manejo del error si se detuvo pero el archivo está dañado o vacío
        print('El archivo se detuvo, pero no se encontró o estaba vacío.');
      }
    } else {
       print('La grabación no pudo ser detenida o no devolvió una ruta válida.');
    }
  } catch (e) {
    print('Error al detener la grabación: $e');
  }
}

}

class AudioData {
  final String filePath;
  bool isPlaying = false;

  AudioData(this.filePath);
}