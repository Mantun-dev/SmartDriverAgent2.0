import 'dart:convert';

import 'package:back_button_interceptor/back_button_interceptor.dart';
//import 'package:flutter/material.dart';

import 'package:flutter_auth/Agents/Screens/Chat/chatapis.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/helpers/base_client.dart';
import 'package:flutter_auth/helpers/res_apis.dart';
import 'package:flutter_auth/providers/chat.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';

import '../../models/message_chat.dart';

import '../Profile/profile_screen.dart';
import 'socketChat.dart';

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

  _sendMessage(String text) {
    //print(widget.id);
    //DateTime now = DateTime.now();
    // String formattedHour = DateFormat('hh:mm a').format(now);
    // var formatter = new DateFormat('dd');
    // String dia = formatter.format(now);
    // var formatter2 = new DateFormat('MM');
    // String mes = formatter2.format(now);
    // var formatter3 = new DateFormat('yy');
    // String anio = formatter3.format(now);
    // Provider.of<ChatProvider>(context, listen: false)
    //     .addNewMessage(Message.fromJson({
    //   'mensaje': _messageInputController.text.trim(),
    //   'sala': sala.toString(),
    //   'user': widget.nombre.toUpperCase(),
    //   'id': id.toString(),
    //   'hora': formattedHour,
    //   'dia': dia,
    //   'mes': mes,
    //   'año': anio,
    //   'leido': false
    // }));
    ChatApis().sendMessage(text, widget.sala, widget.nombre, widget.id,
        widget.driverId, nameDriver!);
    //ChatApis().rendV(modid!, sala!);
    _messageInputController.clear();
  }

  @override
  void initState() {
    super.initState();
    //Important: If your server is running on localhost and you are testing your app on Android then replace http://localhost:3000 with http://10.0.2.2:3000
    ChatApis().dataLogin(
        widget.id, widget.rol, widget.nombre, widget.sala, widget.driverId);

    datas();
    getMessagesDB();
    //inicializador del botón de android para manejarlo manual
    BackButtonInterceptor.add(myInterceptor);
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
    streamSocket.socket.on('detectarE', (data) => print(data));
    streamSocket.socket.on('entrarChat_flutter', (data) {
      // if (mounted) {
      //   setState(() {
      //     ChatApis().sendRead(data, widget.sala, widget.driverId, widget.id);
      //   });
      // }
    });

    streamSocket.socket.on(
      'cargarM',
      ((listM) {
        //print('*************cargarM');
        //print(listM);
        if (mounted) {
          Provider.of<ChatProvider>(context, listen: false).mensaje2.clear();
          listM.forEach((value) {
            print(value);
            Provider.of<ChatProvider>(context, listen: false)
                .addNewMessage(Message.fromJson(value));
          });
        }
      }),
    );

    streamSocket.socket.on(
      'enviar-mensaje2',
      ((data) {
        //print('******************enviarMensaje');
        print(data);
        if (mounted) {
          Provider.of<ChatProvider>(context, listen: false)
              .addNewMessage(Message.fromJson(data));
          ChatApis().sendRead(widget.sala, widget.driverId, widget.id);
        }
      }),
    );

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
    _messageInputController.dispose();

    //creación del dispose para removerlo después del evento
    BackButtonInterceptor.remove(myInterceptor);
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

  // Color _iconsColor(BuildContext context) {
  //   final theme = NeumorphicTheme.of(context);
  //   if (theme!.isUsingDark) {
  //     return theme.current!.accentColor;
  //   } else {
  //     return Color(0);
  //   }
  // }

  Color _textColor(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.black;
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

    return Scaffold(
      backgroundColor: backgroundColor2,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        shadowColor: Colors.black87,
        elevation: 10,
        title: nameDriver != null ? Text(nameDriver!) : Text(''),
        iconTheme: IconThemeData(color: secondColor, size: 35),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: secondColor,
          onPressed: () {
            streamSocket.socket.emit('salir');
            streamSocket.socket.disconnect();
            streamSocket.socket.close();
            streamSocket.socket.dispose();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen()),
                (Route<dynamic> route) => false);
          },
        ),
        actions: <Widget>[
          //aquí está el icono de las notificaciones
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/user.svg",
              width: 100,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProfilePage();
              }));
            },
          ),

          SizedBox(width: kDefaultPadding / 2)
        ],
      ),
      body: streamSocket.socket.connected
          ? isLoading == true
              ? Column(
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
                              final message = provider.mensaje[index];
                              //print(message.user);
                              //print(widget.nombre);
                              return Wrap(
                                alignment:
                                    message.user == widget.nombre.toUpperCase()
                                        ? WrapAlignment.end
                                        : WrapAlignment.start,
                                children: [
                                  Center(
                                    child: fecha('${message.mes}/${message.dia}/${message.ao}')==true 
                                    ?Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Card(
                                        color: Color.fromARGB(255, 101, 87, 170),
                                        child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(hoy_ayer('${message.mes}/${message.dia}/${message.ao}'), style: TextStyle(color: Colors.white, fontSize: 17)),
                                        ),
                                      ),
                                    ) : null,
                                  ),
                                  Card(
                                    color: message.user ==
                                            widget.nombre.toUpperCase()
                                        ? chatSecond
                                        : chatFirst,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: message.user ==
                                                widget.nombre.toUpperCase()
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          if (message.mensaje != null) ...{
                                            Text(
                                              message.mensaje!,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (message.user ==
                                                    widget.nombre.toUpperCase())
                                                  Text(
                                                    message.hora,
                                                    style: TextStyle(
                                                        color: chatFirst,
                                                        fontSize: 12),
                                                  ),
                                                if (message.user !=
                                                    widget.nombre.toUpperCase())
                                                  Text(
                                                    message.hora,
                                                    style: TextStyle(
                                                        color: Colors.grey[400],
                                                        fontSize: 12),
                                                  ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                if (message.user ==
                                                    widget.nombre.toUpperCase())
                                                  Icon(
                                                    message.leido == true
                                                        ? Icons.done_all
                                                        : Icons.done,
                                                    size: 15,
                                                    color: message.leido == true
                                                        ? firstColor
                                                        : Colors.grey,
                                                  )
                                              ],
                                            ),
                                          },
                                        ],
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
                            NeumorphicButton(
                                margin: EdgeInsets.only(top: 0),
                                onPressed: () {
                                  _messageInputController.text =
                                      "Viene en camino?";
                                  if (_messageInputController.text
                                      .trim()
                                      .isNotEmpty) {
                                    _sendMessage(_messageInputController.text);
                                  }
                                },
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(8)),
                                  //border: NeumorphicBorder()
                                ),
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "Viene en camino?",
                                  style: TextStyle(color: _textColor(context)),
                                )),
                            SizedBox(width: 5),
                            NeumorphicButton(
                                margin: EdgeInsets.only(top: 0),
                                onPressed: () {
                                  _messageInputController.text = "Estoy aquí";
                                  if (_messageInputController.text
                                      .trim()
                                      .isNotEmpty) {
                                    _sendMessage(_messageInputController.text);
                                  }
                                },
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(8)),
                                  //border: NeumorphicBorder()
                                ),
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "Estoy aquí",
                                  style: TextStyle(color: _textColor(context)),
                                )),
                            SizedBox(width: 5),
                            NeumorphicButton(
                                margin: EdgeInsets.only(top: 0),
                                onPressed: () {
                                  _messageInputController.text =
                                      "Estoy buscandole";
                                  if (_messageInputController.text
                                      .trim()
                                      .isNotEmpty) {
                                    _sendMessage(_messageInputController.text);
                                  }
                                },
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(8)),
                                  //border: NeumorphicBorder()
                                ),
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "Estoy buscandole",
                                  style: TextStyle(color: _textColor(context)),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: chatFirst,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: SafeArea(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: backgroundColor2,
                                ),
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: _messageInputController,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(color: Colors.white),
                                    contentPadding: EdgeInsets.only(left: 10),
                                    hintText: 'Escriba su mensaje aquí...',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              color: chatSecond,
                              onPressed: () {
                                if (_messageInputController.text
                                    .trim()
                                    .isNotEmpty) {
                                  _sendMessage(
                                      _messageInputController.text.trim());
                                }
                              },
                              icon: const Icon(Icons.send),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator())
          : Center(
              child: Text("No hay una sala de chat actualmente",
                  style: TextStyle(color: Colors.white, fontSize: 17))),
    );
  }
}