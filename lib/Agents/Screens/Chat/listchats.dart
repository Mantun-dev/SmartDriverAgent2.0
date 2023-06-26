import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../../components/AppBarPosterior.dart';
import '../../../components/AppBarSuperior.dart';
import '../../../components/backgroundB.dart';

import '../../../components/progress_indicator.dart';
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

  bool cargarP = false;
  
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
      cargarP=true;
      setState(() { });
    }
  }

  void refresh() async{
    
    LoadingIndicatorDialog().show(context);
    http.Response response = await http.get(Uri.parse('https://apichat.smtdriver.com/api/salas/agenteId/$id'));
    var resp = json.decode(response.body);

    listaChats = resp['salas'] as List<dynamic>;

    listaChats2 = listaChats;

    if(mounted){
      LoadingIndicatorDialog().dismiss();
      cargarP=true;
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
    Size size = MediaQuery.of(context).size;
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
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            border: Border.all( 
                              color: Color.fromRGBO(238, 238, 238, 1),
                              width: 2
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: SingleChildScrollView(child: body())
                        ),
                      )
                    ),
                    AppBarPosterior(item:3),
                  ],
                ),
              ),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: cargarP!=false?
      listaChats != null ? listaChats2.length>0 ? contenido() :
      Center(
        child: Text("No hay salas de chat actualmente",
        style: TextStyle(
          color: Colors.black, 
          fontSize: 17)
        ),
      ) : 
      Center(
        child: Text(
          "No hay salas de chat actualmente",
          style: TextStyle(
            color: Colors.black, 
            fontSize: 17
          )
        ),
      ):Column(
        children: [
          Text(
          "Cargando...",
          style: TextStyle(
            color: Colors.black, 
            fontSize: 17
          )
        ),
          SizedBox(height: 10),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget contenido() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(241, 239, 239, 1),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Color.fromRGBO(241, 239, 239, 1))
              ),
              child: Row(
                children: [
                  Expanded(
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

                  IconButton(
                    icon: Icon(Icons.refresh),
                    color: Color.fromRGBO(40, 93, 169, 1),
                    onPressed: () {
                      refresh();
                    },
                  )
                ],
              )
            ),
    
            listaChats != null ?
            ListView.builder(
              itemCount: listaChats.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
    
                return GestureDetector(
                  onTap: () {
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
                  child: Padding(
                    padding: const EdgeInsets.only(top:20),
                    child: Stack(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            "assets/images/perfilmotorista.png",
                          ),
                        ),
                  
                        Positioned(
                          left: 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listaChats[index]['NombreM'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '# de viaje: ${listaChats[index]['id']}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color.fromRGBO(40, 93, 169, 1),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Positioned(
                          left: 60,
                          bottom: 5,
                          child: listaChats[index]['esAgente'] == true ?
                                Row(
                                  children: [
                                    Container(
                                      width: 15,
                                      height: 15,
                                      child: SvgPicture.asset(
                                        "assets/icons/ignorado.svg",
                                        color: listaChats[index]['Leido'] == true?Color.fromRGBO(40, 93, 169, 1)
                                          :Color.fromRGBO(158, 158, 158, 1),
                                      ),
                                    ),
                                    Text(
                                      ' Tu: ${listaChats[index]['UltimoM']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ):
                                Text(
                                  '${listaChats[index]['UltimoM']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                              if (listaChats[index]['sinLeer'] != 0)
                                Positioned(
                                  right: 0,
                                  bottom: 5,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(40, 93, 169, 1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${listaChats[index]['sinLeer']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                ),

                        Positioned(
                          right: 0,
                          child: Text(
                                  '${listaChats[index]['TiempoUltimoM']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: listaChats[index]['sinLeer'] != 0?Color.fromRGBO(40, 93, 169, 1)
                                          :Color.fromRGBO(158, 158, 158, 1),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ):Column(
            children: [
              Text(
              "Cargando...",
              style: TextStyle(
                color: Colors.black, 
                fontSize: 17
              )
            ),
              SizedBox(height: 10),
              CircularProgressIndicator(),
            ],
          ),
    
          ],
        );
  }
}