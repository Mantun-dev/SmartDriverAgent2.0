import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import '../Agents/Screens/Chat/listchats.dart';
import '../Agents/Screens/Notifications/notification.dart';
import '../Agents/Screens/Profile/profile_screen.dart';
import '../Agents/models/network.dart';


class AppBarPosterior extends StatefulWidget {
  final int? item;

  AppBarPosterior({this.item});

  @override
  _AppBarPosterior createState() => _AppBarPosterior(item: item);
}

class _AppBarPosterior extends State<AppBarPosterior> {
  int? item;
  int? counter;
  String? tripIdTologin;
  String? driverId;

  _AppBarPosterior({this.item});

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {

    return AppBar(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      elevation: 10,
      iconTheme: IconThemeData(size: 25),
      automaticallyImplyLeading: false, // Ocultar el ícono del Drawer
      actions: <Widget>[
        Expanded(
          child: item==0?Padding(
            padding: const EdgeInsets.only(top:10),
            child: Column(
              children: [
                Container(
                    width: 30,
                    height: 30,
                    child: SvgPicture.asset(
                      "assets/icons/inicio.svg",
                      color: Color.fromRGBO(40, 93, 169, 1),
                    ),
                  ),

                  Text(
                    "Perfil",
                    style: TextStyle(
                      color: Color.fromRGBO(40, 93, 169, 1),
                      fontSize: 9
                    ),
                  )
              ],
            ),
          ):GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return HomeScreen();
                  })
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top:10),
                child: Column(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      child: SvgPicture.asset(
                        "assets/icons/inicio.svg",
                        color: Color.fromRGBO(158, 158, 158, 1),
                      ),
                    ),
                    Text(
                    "Inicio",
                    style: TextStyle(
                      color: Color.fromRGBO(158, 158, 158, 1),
                      fontSize: 9
                    ),
                  )
                  ],
                ),
              ),
            ),
        ),

        Stack(
          children: [
            item==2?Padding(
              padding: const EdgeInsets.only(top:10),
              child: Column(
                children: [
                  Container(
                  width: 28,
                  height: 28,
                  child: SvgPicture.asset(
                    "assets/icons/notificacion.svg",
                    color: Color.fromRGBO(40, 93, 169, 1),
                  ),
                            ),
                            Text(
                    "Notificaciones",
                    style: TextStyle(
                      color: Color.fromRGBO(40, 93, 169, 1),
                      fontSize: 9
                    ),
                  )
                ],
              ),
            ):GestureDetector(
            onTap: item==2?null:() {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NotificationPage();
                  })
                );
            },
            child: Padding(
              padding: const EdgeInsets.only(top:10),
              child: Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    child: SvgPicture.asset(
                      "assets/icons/notificacion.svg",
                      color: Color.fromRGBO(158, 158, 158, 1),
                    ),
                  ),

                  Text(
                    "Notificaciones",
                    style: TextStyle(
                      color: Color.fromRGBO(158, 158, 158, 1),
                      fontSize: 9
                    ),
                  )
                ],
              ),
            ),
          ),
            Positioned(
              top: 5,
              right: 8,
              child: Container(
                width: 15,
                height: 20,
                child: Container(
                  
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(color: Color(0xffc32c37), width: 1.5)),
                  child: Center(
                    child:   Text(
                        '0',
                        style: TextStyle(fontSize: 10, color: Color(0xffc32c37), fontWeight: FontWeight.bold),
                      ),
                  ),
                ),
              ),
            ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(right: 25, left: 25),
            child: SizedBox(),
          ),

        Stack(
          children: [
            item==3?Padding(
              padding: const EdgeInsets.only(top:10, right: 10),
              child: Column(
                children: [
                  Container(
                  width: 28,
                  height: 28,
                  child: SvgPicture.asset(
                    "assets/icons/chats.svg",
                    color: Color.fromRGBO(40, 93, 169, 1),
                  ),
                            ),
                            Text(
                    "Chats",
                    style: TextStyle(
                      color: Color.fromRGBO(40, 93, 169, 1),
                      fontSize: 9
                    ),
                  )
                ],
              ),
            ):GestureDetector(
            onTap: item==3?null:() {
                setState(() {
                  fetchProfile().then((value) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ChatsList(
                        id: '${value.agentId}',
                        rol: 'agente',
                        nombre: '${value.agentFullname}',
                      );
                    }));
                  });
                });
              },
            child: Padding(
              padding: const EdgeInsets.only(top:10, right: 10),
              child: Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    child: SvgPicture.asset(
                      "assets/icons/chats.svg",
                      color: Color.fromRGBO(158, 158, 158, 1),
                    ),
                  ),

                  Text(
                    "Chats",
                    style: TextStyle(
                      color: Color.fromRGBO(158, 158, 158, 1),
                      fontSize: 9
                    ),
                  )
                ],
              ),
            ),
          ),
            Positioned(
              top: 5,
              right: 0,
              child: Container(
                width: 15,
                height: 20,
                child: Container(
                  
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(color: Color(0xffc32c37), width: 1.5)),
                  child: Center(
                    child:  Text(
                    counter!=null?'$counter':'0',
                    style: TextStyle(fontSize: 10, color: Color(0xffc32c37), fontWeight: FontWeight.bold),
                  ),
                  ),
                ),
              ),
            ),
                ],
              ),

        Expanded(
          child: item==1?Padding(
            padding: const EdgeInsets.only(top:10),
            child: Column(
              children: [
                Container(
                    width: 30,
                    height: 30,
                    child: SvgPicture.asset(
                      "assets/icons/usuario2.svg",
                      color: Color.fromRGBO(40, 93, 169, 1),
                    ),
                  ),

                  Text(
                    "Perfil",
                    style: TextStyle(
                      color: Color.fromRGBO(40, 93, 169, 1),
                      fontSize: 9
                    ),
                  )
              ],
            ),
          ):GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ProfilePage();
                  })
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top:10),
                child: Column(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      child: SvgPicture.asset(
                        "assets/icons/usuario2.svg",
                        color: Color.fromRGBO(158, 158, 158, 1),
                      ),
                    ),
                    Text(
                    "Perfil",
                    style: TextStyle(
                      color: Color.fromRGBO(158, 158, 158, 1),
                      fontSize: 9
                    ),
                  )
                  ],
                ),
              ),
            ),
        ),
      ],
    );
  }

  void getData() async{
    http.Response response = await http.get(Uri.parse('https://apichat.smtdriver.com/api/salas/agenteId/${prefs.usuarioId}'));
    var resp = json.decode(response.body);

    var listaChats = resp['salas'] as List<dynamic>;

    if(mounted){
      setState(() {counter= listaChats.length;});
    }
  }

}
