import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Chat/chatapis.dart';
//import 'package:flutter_auth/Agents/Screens/Chat/chatapis.dart';
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
  final StreamSocket streamSocket = StreamSocket(host: 'djc5t.localtonet.com');
  int? counter;
  @override
  void initState() {    
    super.initState();
    getCounterNotification();
    //streamSocket.socket.connect();
    //ChatApis().dataLogin('8', 'agente',  'FRANKLIN');
    // streamSocket.socket.on('entrarChat_flutter', (data) {             
    //     //ChatApis().getDataUsuarios(data['Usuarios']);              
    // });
  }

  void getCounterNotification()async{
    final getData = await ChatApis().notificationCounter();      
    setState(() {      
      counter = getData;
    });
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
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChatScreen(
                id: '8',
                rol: 'agente',
                nombre: 'FRANKLIN',
              );
            }));
          },
          child: Container( 
          padding: EdgeInsets.only(top: 16),       
          width: 30,
          height: 30,
          child: Stack(
            children: [
              Icon(
                Icons.telegram,
                size: 30,
                color: firstColor,
              ),
              Container(
                width: 35,
                height: 35,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 0),
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffc32c37),
                      border: Border.all(color: Colors.white, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Center(
                      child: Text(
                        counter!=null?'$counter':'0',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ),
                    ),
                  ],
                ),
              ),
        ),
        //aquí está el icono de las notificaciones
        // IconButton(
        //   icon: Stack(            
        //     children: [
        //     Icon(
        //       Icons.message,
        //       size: 35,
        //       color: firstColor,
        //     ),
        //     Positioned(
        //       top: 0.0,
        //       right: 0.0,
        //       width: 15,              
        //       child: 
        //       Container(
        //         padding: EdgeInsets.symmetric(horizontal: 3,vertical: 0),
        //         decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
        //         child: Text('1', style: TextStyle(color: Colors.white, fontSize: 16),),
        //       ))
        //   ],),                    
        //   onPressed: () {
            
            
        //   },
        // ),
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
