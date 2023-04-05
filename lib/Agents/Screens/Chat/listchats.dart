import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

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

import '../../models/network.dart';
import '../Profile/profile_screen.dart';
import 'chatscreen.dart';
import 'socketChat.dart';

class ChatsList extends StatefulWidget {
  final String nombre;
  final String id;
  final String rol;

  const ChatsList(
    {
      Key? key,
      required this.nombre,
      required this.id,
      required this.rol
    }
  ): super(key: key);

  @override
  State<ChatsList> createState() => _ChatsListState(id,nombre,rol);
}

class _ChatsListState extends State<ChatsList> {
  var listaChats;
  var listaChats2;
  var listaB;
  String ?id;
  String ?nombre;
  String ?rol;
  
  _ChatsListState(String idA, String nombreA, String rolA){
    id= idA;
    nombre = nombreA;
    rol = rolA;
  }


  void getData() async{
    http.Response response = await http.get(Uri.parse('https://apichat.smtdriver.com/api/salas/agenteId/$id'));
    var resp = json.decode(response.body);

    listaChats = resp['salas'] as List<dynamic>;

    listaChats2 = listaChats;

    setState(() { });

  }

  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text(
          "Salas",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: secondColor),
        ),
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen()),
                (Route<dynamic> route) => false);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              getData();
            },
          )
        ],
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                onChanged:(value) {
                  listaChats=listaChats2;
                  setState(() {

                    if(value.isNotEmpty){
                    listaB = listaChats.where((salas) => salas['NombreM'].toString().toLowerCase().contains(value.toLowerCase())).toList();
                    listaChats = listaB;
                  }
                        
                  });
                },
                decoration: InputDecoration(
                  hintText: "Buscar...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),

            listaChats != null ?
            ListView.builder(
              itemCount: listaChats.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {

                return Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          blurStyle: BlurStyle.normal,
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: -13,
                          offset: Offset(-15, -6)),
                      BoxShadow(
                          blurStyle: BlurStyle.normal,
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 18,
                          spreadRadius: -15,
                          offset: Offset(18, 5)
                      ),
                    ],
                   borderRadius: BorderRadius.circular(15)),
                    child: Card(
                      elevation: 10,
                      color: backgroundColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(listaChats[index]['NombreM'],
                              style: TextStyle(
                                color: firstColor
                              ),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Viaje: ${listaChats[index]['id']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text('Mensajes sin leer: ${listaChats[index]['sinLeer']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          fetchProfile().then((value) {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                                              return ChatScreen(
                                                id: id!,
                                                rol: rol!,
                                                nombre: '${value.agentFullname}',
                                                sala: '${listaChats[index]['id']}',
                                                driverId: '${listaChats[index]['idM']}'
                                              );
                                            }));
                                          });
                                        }, 
                                        icon: Icon(Icons.message),
                                        color: thirdColor,
                                        iconSize: 25,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ):Text(''),

          ],
        ),
      ),
    );
  }
}