import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Chat/chatapis.dart';
import 'package:flutter_auth/Agents/Screens/Chat/socketChat.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/components/body.dart';
import 'package:flutter_auth/Agents/Screens/Profile/profile_screen.dart';
//import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/components/menu_lateral.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import '../Chat/chatscreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 final StreamSocket streamSocket = StreamSocket(host: '192.168.1.3:3010');
  @override
  void initState() {    
    super.initState();
    //streamSocket.socket.connect();
    //ChatApis().dataLogin('8', 'agente',  'FRANKLIN');
    // streamSocket.socket.on('entrarChat_flutter', (data) {             
    //     //ChatApis().getDataUsuarios(data['Usuarios']);              
    // });
  }

  @override
  void dispose() {    
    super.dispose();
    //streamSocket.close();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: buildAppBar(context),
      body: SafeArea(child: Body()),
      drawer: MenuLateral(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
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
            
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChatScreen(
                id: '8',
                rol: 'agente',
                nombre: 'FRANKLIN',
              );
            }));
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
    );
  }
}
