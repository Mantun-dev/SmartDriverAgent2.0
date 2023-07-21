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
                              color: Theme.of(context).disabledColor,
                              width: 2
                            ),
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: SingleChildScrollView(child: body())
                        ),
                      )
                    ),
                    SafeArea(child: AppBarPosterior(item:3)),
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
        child: Column(
          children: [
            Text("No hay salas de chat actualmente",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 17)
            ),
            Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ],
        ),
      ) : 
      Center(
        child: Column(
          children: [
            Text(
              "No hay salas de chat actualmente",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 17)
            ),
            Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ],
        ),
      ):WillPopScope(
                    onWillPop: () async => false,
                    child: SimpleDialog(
                      elevation: 20,
                      backgroundColor: Theme.of(context).cardColor,
                      children: [
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                child: CircularProgressIndicator(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Cargando...', 
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                  ),
                              )
                            ],
                          ),
                        )
                      ] ,
                    ),
                  ),
    );
  }

  Widget contenido() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Theme.of(context).disabledColor)
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: Theme.of(context).textTheme.bodyMedium,
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
                        prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryIconTheme.color),
                        hintText: 'Buscar',
                        hintStyle: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 15, fontFamily: 'Roboto'
                          ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  IconButton(
                    icon: Icon(Icons.refresh),
                    color: Theme.of(context).primaryIconTheme.color,
                    onPressed: () {
                      refresh();
                    },
                  )
                ],
              )
            ),
    
            listaChats != null ?
            SingleChildScrollView(
              child: ListView.builder(
                itemCount: listaChats.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                
                  return GestureDetector(
                    onTap: () {
                      fetchProfile().then((value) {
                        Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
                                      pageBuilder: (_, __, ___) => ChatScreen(
                                        id: id!,
                                        rol: rol!,
                                        nombre: '${value.agentFullname}',
                                        sala: '${listaChats[index]['id']}',
                                        driverId: '${listaChats[index]['idM']}'
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
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 13),
                                ),
                                Text(
                                  '# de viaje: ${listaChats[index]['id']}',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 10),
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
                                          color: listaChats[index]['Leido'] == true?Theme.of(context).focusColor
                                            :Theme.of(context).splashColor,
                                        ),
                                      ),
                                      Text(
                                        ' Tu: ${listaChats[index]['UltimoM']}',
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),
                                      ),
                                    ],
                                  ):
                                  Text(
                                    '${listaChats[index]['UltimoM']}',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),
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
                                        color: Theme.of(context).focusColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${listaChats[index]['sinLeer']}',
                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 9),
                                      ),
                                    ),
                                  ),
            
                          Positioned(
                            right: 0,
                            child: Text(
                                    '${listaChats[index]['TiempoUltimoM']}',
                                    style: listaChats[index]['sinLeer'] != 0? 
                                      Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 12):
                                      Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12)
                                    ,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ):WillPopScope(
                    onWillPop: () async => false,
                    child: SimpleDialog(
                       elevation: 20,
                      backgroundColor: Theme.of(context).cardColor,
                      children: [
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                child: CircularProgressIndicator(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Cargando..', 
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                  ),
                              )
                            ],
                          ),
                        )
                      ] ,
                    ),
                  ),
    
          ],
        );
  }
}