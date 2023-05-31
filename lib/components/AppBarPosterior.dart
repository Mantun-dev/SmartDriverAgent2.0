import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import '../Agents/Screens/Profile/profile_screen.dart';
import '../Agents/models/network.dart';


class AppBarPosterior extends StatefulWidget {
  int? item;

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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      elevation: 10,
      iconTheme: IconThemeData(size: 25),
      automaticallyImplyLeading: false, // Ocultar el ícono del Drawer
      actions: <Widget>[
        Expanded(
          child: item==0?IconButton(
            icon: Icon(
              Icons.home_outlined,
              color: Color.fromRGBO(40, 93, 169, 1),
              size: 35,
            ),
            onPressed: null,
          ):IconButton(
            icon: Icon(
              Icons.home_outlined,
              color: Color.fromRGBO(158, 158, 158, 1),
              size: 35,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return HomeScreen();
                  })
                );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top:5, left: 20, right: 20),
          child: Stack(
            children: [
              IconButton(
                icon: item==2?Icon(
                  FontAwesomeIcons.bell,
                  color: Color.fromRGBO(40, 93, 169, 1),
                ):Icon(
                  FontAwesomeIcons.bell,
                  color: Color.fromRGBO(158, 158, 158, 1),
                ),
                onPressed: () {
                  setState(() {
                    item=2;
                  });
                },
              ),
              Container(
                width: 65,
                height: 35,
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 5),
                child: Container(
                  height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(color: Color(0xffc32c37), width: 1.5)),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Center(
                      child: Text(
                        '0',
                        style: TextStyle(fontSize: 10, color: Color(0xffc32c37), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
                  ],
                ),
        ),

        Padding(
          padding: const EdgeInsets.only(top:5, left: 20,),
          child: Stack(
            children: [
              IconButton(
                icon: item==3?Icon(
                  FlutterIcons.message1_ant,
                  color: Color.fromRGBO(40, 93, 169, 1),
                ):Icon(
                  FlutterIcons.message1_ant,
                  color: Color.fromRGBO(158, 158, 158, 1),
                ),
                onPressed: () {
                  setState(() {
                    item=3;
                  });
                },
              ),
              Container(
                width: 75,
                height: 35,
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 5),
                child: Container(
                  height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(color: Color(0xffc32c37), width: 1.5)),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Center(
                      child: Text(
                        counter!=null?'$counter':'0',
                        style: TextStyle(fontSize: 10, color: Color(0xffc32c37), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
                  ],
                ),
        ),

        Expanded(
          child: item==1?IconButton(
            icon: Icon(
              FontAwesomeIcons.userCircle,
              color: Color.fromRGBO(40, 93, 169, 1),
            ),
            onPressed: null,
          ):IconButton(
            icon: Icon(
              FontAwesomeIcons.userCircle,
              color: Color.fromRGBO(158, 158, 158, 1),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ProfilePage();
                  })
                );
            },
          ),
        ),
      ],
    );
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

}
