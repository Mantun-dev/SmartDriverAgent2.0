import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import 'package:flutter_auth/constants.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../../components/AppBarPosterior.dart';
import '../../../components/AppBarSuperior.dart';
import '../../../components/backgroundB.dart';
import '../../models/network.dart';
import 'chatscreen.dart';

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

    if(mounted){
      setState(() { });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    
    return BackgroundBody(
      child: Scaffold(
        backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(56),
                  child: AppBarSuperior(item: 6)
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: listaChats != null ? listaChats2.length>0 ? body() :Align(
                        alignment: Alignment.center,
                            child: Text("No hay salas de chat actualmente",
                                style: TextStyle(color: Colors.white, fontSize: 17)
                              )
                          ) : Align(
                        alignment: Alignment.center,
                            child: Text("No hay salas de chat actualmente",
                                style: TextStyle(color: Colors.white, fontSize: 17)
                              )
                          ),
                    ),
                    AppBarPosterior(item:3),
                  ],
                ),
              ),
    );
  }

  SingleChildScrollView body() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Material(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(241, 239, 239, 1),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Color.fromRGBO(241, 239, 239, 1))
                ),
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
                    prefixIcon: Icon(Icons.search, color: Color.fromRGBO(40, 93, 169, 1),),
                    hintText: 'Buscar',
                    hintStyle: TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
                    border: InputBorder.none,
                  ),
                ),
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
    );
  }
}