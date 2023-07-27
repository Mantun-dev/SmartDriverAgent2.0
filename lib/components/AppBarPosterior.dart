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
  int? totalNotificaciones;

  _AppBarPosterior({this.item});

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {

    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
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
                      color: Theme.of(context).focusColor,
                    ),
                  ),

                  Text(
                    "Inicio",
                    style: TextStyle(
                            color: Theme.of(context).focusColor, fontSize: 10, fontFamily: 'Roboto'
                          ),
                  )
              ],
            ),
          ):GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 200 ),
                    pageBuilder: (_, __, ___) => HomeScreen(),
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
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    Text(
                    "Inicio",
                    style: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 10, fontFamily: 'Roboto'
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
                    color: Theme.of(context).focusColor,
                  ),
                            ),
                            Text(
                    "Notificaciones",
                    style: TextStyle(
                            color: Theme.of(context).focusColor, fontSize: 10, fontFamily: 'Roboto'
                          ),
                  )
                ],
              ),
            ):GestureDetector(
            onTap: item==2?null:() {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 200 ),
                    pageBuilder: (_, __, ___) => NotificationPage(),
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
                      color: Theme.of(context).hintColor,
                    ),
                  ),

                  Text(
                    "Notificaciones",
                    style: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 10, fontFamily: 'Roboto'
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
                width: 20,
                height: 20,
                child: Container(
                  
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(color: Theme.of(context).hoverColor, width: 1.5)),
                  child: Center(
                    child:   Text(
                        counter!=null?'$totalNotificaciones':'0',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).hoverColor)
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
              padding: const EdgeInsets.only(top:10, right: 18),
              child: Column(
                children: [
                  Container(
                  width: 28,
                  height: 28,
                  child: SvgPicture.asset(
                    "assets/icons/chats.svg",
                    color: Theme.of(context).focusColor,
                  ),
                            ),
                            Text(
                    "Chats",
                    style: TextStyle(
                            color: Theme.of(context).focusColor, fontSize: 10, fontFamily: 'Roboto'
                          ),
                  )
                ],
              ),
            ):GestureDetector(
            onTap: item==3?null:() {
                setState(() {
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
                });
              },
            child: Padding(
              padding: const EdgeInsets.only(top:10, right: 18),
              child: Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    child: SvgPicture.asset(
                      "assets/icons/chats.svg",
                      color: Theme.of(context).hintColor,
                    ),
                  ),

                  Text(
                    "Chats",
                    style: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 10, fontFamily: 'Roboto'
                          ),
                  )
                ],
              ),
            ),
          ),
            Positioned(
              top: 5,
              left: 25,
              child: Container(
                width: 20,
                height: 20,
                child: Container(
                  
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(color: Theme.of(context).hoverColor, width: 1.5)),
                  child: Center(
                    child:  Text(
                    counter!=null?'$counter':'0',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).hoverColor)
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
                      color: Theme.of(context).focusColor
                    ),
                  ),

                  Text(
                    "Perfil",
                    style: TextStyle(
                            color: Theme.of(context).focusColor, fontSize: 10, fontFamily: 'Roboto'
                          ),
                  )
              ],
            ),
          ):GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 200 ),
                    pageBuilder: (_, __, ___) => ProfilePage(),
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
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    Text(
                    "Perfil",
                    style: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 10, fontFamily: 'Roboto'
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

    http.Response response2 = await http.get(Uri.parse('https://smtdriver.com/api/getAgentNotifications/${prefs.usuarioId}'));
    var resp2 = json.decode(response2.body);

    if(mounted){
      setState(() {
        counter= listaChats.length;
        if(resp2['ok']==true){
          totalNotificaciones = resp2['totalAgentNotifications'];
        }
      });
    }
  }

}
