import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_auth/Agents/Screens/Chat/chatapis.dart';
import 'package:flutter_auth/Agents/Screens/Chat/listchats.dart';
//import 'package:flutter_auth/Agents/Screens/Chat/chatapis.dart';

import 'package:flutter_auth/Agents/Screens/HomeAgents/components/body.dart';
import 'package:flutter_auth/Agents/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Agents/Screens/Profile/profile_screen.dart';
import 'package:flutter_auth/Agents/models/network.dart';
//import 'package:flutter_auth/Agents/models/profileAgent.dart';
//import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/components/menu_lateral.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

class HomeScreen extends StatefulWidget {
    
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {  
  //final StreamSocket streamSocket = StreamSocket(host: 'djc5t.localtonet.com');
  String? tripIdTologin;
  int? counter;
  String? driverId;
  String? agentId;
  @override
  void initState() {    
    super.initState(); 
    WidgetsBinding.instance.addObserver(this);
    fetchTrips().then((value){
      if (value.trips.isNotEmpty) {         
        for (var i = 0; i < value.trips.length; i++) {                  
            tripIdTologin =  value.trips[i].tripId.toString(); 
            driverId = value.trips[i].driverId.toString();            
            fetchProfile().then((val){      
              getCounterNotification(value.trips[i].tripId.toString(), val.agentId.toString());
   
            });
        }
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          this.closeSession();
        });
      }
    });
  }
    void didChangeAppLifecycleState(AppLifecycleState state) {
    // setState(() {
    // });
    if (AppLifecycleState.resumed == state) {
      if(mounted){
        //print('hola');
        closeSession();
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>DetailScreen(plantilla: plantilla[0])),(Route<dynamic> route) => false);
      }
    }
  }

  closeSession() async {
    fetchRefres().then((value) {
      if (value.disabled == 1 ) {
        fetchDeleteSession();
        prefs.remove();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
            (Route<dynamic> route) => false);
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: "Lo sentimos",
              text: "Usuario deshabilitado",
            );
      }
    });
  }

  void getCounterNotification(String? tripId, String? agentId)async{
    
    http.Response response = await http.get(Uri.parse('https://apichat.smtdriver.com/api/salas/agenteId/$agentId'));
    final resp = json.decode(response.body);

    if (resp['salas'].isNotEmpty) {      
      if (mounted) {
        setState(() {      
          counter = resp['salas'].length;
        });  
      }
    }else{
      counter = 0;
    }
  }

  @override
  void dispose() {    
    super.dispose();
    WidgetsBinding.instance.addObserver(this);
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
            fetchProfile().then((value) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChatsList(
                  id: '${value.agentId}',
                  rol: 'agente',
                  nombre: '${value.agentFullname}',
                );
              }));
            });
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
