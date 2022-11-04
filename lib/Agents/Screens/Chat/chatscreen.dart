import 'dart:async';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_auth/Agents/Screens/Chat/chatapis.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/providers/chat.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:intl/intl.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';

import '../../models/message_chat.dart';
import '../HomeAgents/homeScreen_Agents.dart';
import '../Profile/profile_screen.dart';
import 'socketChat.dart';

class ChatScreen extends StatefulWidget {
  final String nombre;
  final String id;
  final String rol;
  const ChatScreen(
      {Key? key, required this.nombre, required this.id, required this.rol})
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
  String? sala;
  String? id;
  String? idDb;
  String? modid;
  String? nameDriver;
  ScrollController _scrollController = new ScrollController();
  final arrayTemp = [];
  final StreamSocket streamSocket = StreamSocket(host: '192.168.1.3:3010');
  
  _sendMessage() {
    ChatApis().sendMessage(_messageInputController.text.trim(), sala.toString(), widget.nombre, id.toString(), modid!, nameDriver!, idDb!);       
    ChatApis().rendV(modid!, sala!); 
    _messageInputController.clear();
  }

  @override
  void initState() {
    super.initState();
    //Important: If your server is running on localhost and you are testing your app on Android then replace http://localhost:3000 with http://10.0.2.2:3000
    
    //ChatApis().dataLogin(widget.id, widget.rol,  widget.nombre);

   //scroll();
    
    datas();
    //inicializador del botón de android para manejarlo manual
    BackButtonInterceptor.add(myInterceptor);
    
  }

void datas(){
    ChatApis().dataLogin(widget.id, widget.rol,  widget.nombre);    
    streamSocket.socket.on('detectarE', (data) => print(data));
    streamSocket.socket.on('entrarChat_flutter', (data) {     
      sala = data['Usuarios']['sala'];
      id = data['Usuarios']['id'];
      idDb = data['Usuarios']['_id'];
      modid = data['Usuarios']['mot_id'];
      nameDriver = data['targetN'];
        print('*****************************************************');            
        //print(data['listM']);
        Provider.of<ChatProvider>(context, listen: false).mensaje2.clear();
         data['listM'].forEach((value){
          print(value);
            if (mounted) {          
              Provider.of<ChatProvider>(context, listen: false).addNewMessage(Message.fromJson(value));
            } 
         });
      // for (var i = 0; i < data['listM'].length; i++) {   
      //   //ChatApis().getDataUsuarios(data['Usuarios']); 
      // }
    });

    streamSocket.socket.on('flutter-mensaje',((data) {
        if (mounted) {          
          Provider.of<ChatProvider>(context, listen: false).addNewMessage(Message.fromJson(data));
        }
      }),
    );
    
    streamSocket.socket.on('enviar-mensaje',((data) {
        if (mounted) {          
          Provider.of<ChatProvider>(context, listen: false).addNewMessage(Message.fromJson(data));
        }
      }),
    );
}


  @override
  void dispose() {
    super.dispose();
    _messageInputController.dispose();
    
    //creación del dispose para removerlo después del evento
    BackButtonInterceptor.remove(myInterceptor);
  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON!"); // Do some stuff.  
      streamSocket.socket.disconnect();  
      streamSocket.socket.close();  
      streamSocket.socket.dispose();
      
    print(streamSocket.socket.connected);  
    
    //Navigator.of(context).pop();
    Navigator.of(context).pop();

    return true;
  }


  

  void scroll()async{
    await Future.delayed(const Duration(milliseconds: 300));
      SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn);
      });
  }

  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          shadowColor: Colors.black87,
          elevation: 10,
          iconTheme: IconThemeData(color: secondColor, size: 35),
          actions: <Widget>[
            //aquí está el icono de las notificaciones
            IconButton(
              icon: Icon(
                Icons.message,
                size: 35,
                color: firstColor,
              ),
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return ProfilePage();
                // }
                // )
                // );
              },
            ),
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
        body: Column(
          children: [            
            Expanded(              
                child: Consumer<ChatProvider>(                  
                  builder: (context, provider, child) => ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {                      
                      final message = provider.mensaje[index];
                      print(provider.mensaje2.length);
                      return Wrap(
                        alignment: message.user == widget.nombre
                            ? WrapAlignment.end
                            : WrapAlignment.start,
                        children: [
                          Card(
                            color: message.user == widget.nombre
                                ? Theme.of(context).primaryColorLight
                                : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: message.user == widget.nombre
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  if(message.mensaje != null)...{
                                    Text(message.mensaje!),
                                  },
                                  // Text(
                                  //   DateFormat('hh:mm a').format(message.sentAt),
                                  //   style: Theme.of(context).textTheme.caption,
                                  // ),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageInputController,
                        decoration: const InputDecoration(
                          hintText: 'Type your message here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_messageInputController.text.trim().isNotEmpty) {
                          _sendMessage();
                        }
                      },
                      icon: const Icon(Icons.send),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
  }
}
