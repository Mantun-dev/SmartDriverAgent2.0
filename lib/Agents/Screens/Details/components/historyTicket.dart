import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/loader.dart';

import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/Screens/Signup/components/background.dart';
import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/Agents/models/ticketHistory.dart';
import 'package:flutter_auth/components/menu_lateral.dart';
import 'package:flutter_auth/constants.dart';



void main() {
  runApp(HistoryTicketScreen());
}

class HistoryTicketScreen extends StatefulWidget {
  //declaración instancia de plantilla y TripsList6 con sus variables
  final Plantilla plantilla;
  final TripsList6 item;
  const HistoryTicketScreen({Key key, this.plantilla, this.item}) : super(key: key);
  @override
  _DataTableExample createState() => _DataTableExample();
}

class _DataTableExample extends State<HistoryTicketScreen> {
  // variable con instancia 
  Future< TripsList6>item;

  @override  
  void initState() {  
    super.initState();  
    //asignación de variable al fetch desde ticket story en network
    item = fetchTicketStory();  
  }  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          drawer: MenuLateral(),
          appBar: AppBar(backgroundColor: kColorAppBar,elevation: 0,
            title: Center(child: Text('Información General')),
            iconTheme: IconThemeData(color: Colors.white),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HomeScreen();
                  }));
                },
              ),
              SizedBox(width: kDefaultPadding / 2)
            ],                      
          ),
          body: Background(
            child: ListView(children: <Widget>[
              SizedBox(height: 20.0),            
              Center(child: Text('Tickets pendientes',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: kCardColor2),)),
              _ticketPendant(),
              SizedBox(height: 20.0), 
              Center(child: Text('Tickets procesados',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: kCardColor2),)),
              _ticketProcess(),
              SizedBox(height: 50)
            ]),
          )
      ),
    );
  }

Widget _ticketPendant() {
  //construcción de future builder para mostrar data
  return FutureBuilder< TripsList6> (
    future: item,
    builder: (BuildContext context, abc) {
      if (abc.connectionState == ConnectionState.done) {
        //validación de arreglo vacio
        if (abc.data.trips[0].pendant.length == 0) {
          return Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),margin: EdgeInsets.symmetric(vertical: 15),
            child: Column(mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.bus_alert),
                  title: Text('Tickets', style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 20.0)),
                  subtitle: Text('No hay tickets pendientes', style: TextStyle(color: Colors.red,fontWeight: FontWeight.normal,fontSize: 15.0)),
                ),                      
              ],
            ),
          );
        } else {                
          return FutureBuilder< TripsList6> (
            future: item,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return ListView.builder(scrollDirection: Axis.vertical,shrinkWrap: true,physics: ClampingScrollPhysics(),itemCount: abc.data.trips[0].pendant.length,
                itemBuilder: (context, index){
                  //retorno de container y card con la data respectiva
                  return Container(width: 500.0,
                    child: Column(
                      children: [
                        Card(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),margin: EdgeInsets.all(15.0),elevation: 2,
                          child: Column(
                            children: <Widget>[
                              Padding(padding: const EdgeInsets.all(8.0),
                                child: ExpansionTile(backgroundColor: Colors.white,
                                  title: Column(crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      ListTile(contentPadding: EdgeInsets.fromLTRB(5, 5, 10, 0),
                                        title: Text('Asunto: '),
                                        subtitle: Text('${abc.data.trips[0].pendant[index].ticketIssue}',style: TextStyle(color: kTextColor)),
                                        leading: Icon(Icons.image_aspect_ratio,color: kColorAppBar),
                                      ),                                    
                                    ],
                                  ),
                                  trailing: SizedBox(),
                                  children: [
                                  //ingreso de data
                                  Container(
                                     margin: EdgeInsets.only(left: 15),
                                    child: Column(children: [
                                      ListTile(contentPadding: EdgeInsets.fromLTRB(5, 5, 10, 0),
                                        title: Text('No. Ticket: '),
                                        subtitle: Text('${abc.data.trips[0].pendant[index].ticketId}'),
                                        leading: Icon(Icons.confirmation_number,color: kColorAppBar),
                                      ),
                                      ListTile(contentPadding: EdgeInsets.fromLTRB(5, 5, 10, 0),
                                        title: Text('Fecha:'),
                                        subtitle: Text('${abc.data.trips[0].pendant[index].ticketDatetime}'),
                                        leading: Icon(Icons.timer,color: kColorAppBar),
                                      ),
                                      ListTile(contentPadding: EdgeInsets.fromLTRB(5, 5, 10, 0),
                                        title: Text('Mensaje: '),
                                        subtitle: Text('${abc.data.trips[0].pendant[index].ticketMessage}'),
                                        leading: Icon(Icons.location_pin,color: kColorAppBar),
                                      ),
                                    ],),
                                  ),
                                            
                                    SizedBox(height: 20.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ); 
                } 
              );
            },
          );          
        }
      } else {
        return ColorLoader3();
      }
    },
  ); 
}

Widget _ticketProcess() {
  //Future builder para la data
  return FutureBuilder< TripsList6> (
    future: item,
    builder: (BuildContext context, abc) {
      if (abc.connectionState == ConnectionState.done) {
        //validación de arreglo vacio
        if (abc.data.trips[1].closed.length == 0) {
          return Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),margin: EdgeInsets.symmetric(vertical: 15),
            child: Column(mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.bus_alert),
                  title: Text('Tickets', style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 20.0)),
                  subtitle: Text('No hay tickets en proceso', style: TextStyle(color: Colors.red,fontWeight: FontWeight.normal,fontSize: 15.0)),
                ),                      
              ],
            ),
          );
        } else {                
          return FutureBuilder< TripsList6> (
            future: item,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              //retorna el ListView builder para la data dinámica
              return ListView.builder(scrollDirection: Axis.vertical,shrinkWrap: true,physics: ClampingScrollPhysics(),itemCount: abc.data.trips[1].closed.length,
                itemBuilder: (context, index){
                  return Container(width: 500.0,
                    child: Column(
                      children: [
                        Card(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),margin: EdgeInsets.all(15.0),elevation: 2,
                          child: Column(
                            children: <Widget>[Padding(padding: const EdgeInsets.all(8.0),
                              child: ExpansionTile(backgroundColor: Colors.white,
                                title: Column(crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    ListTile(contentPadding: EdgeInsets.fromLTRB(5, 5, 10, 0),
                                        title: Text('Asunto: '),
                                        subtitle: Text('${abc.data.trips[1].closed[index].ticketIssue}',style: TextStyle(color: kTextColor)),
                                        leading: Icon(Icons.image_aspect_ratio,color: kColorAppBar),
                                      ),  

                                  ],
                                ),
                                trailing: SizedBox(),
                                children: [
                                  //ingreso de data
                                  Container(
                                     margin: EdgeInsets.only(left: 15),
                                    child: Column(children: [
                                      ListTile(contentPadding: EdgeInsets.fromLTRB(5, 5, 10, 0),
                                        title: Text('No. Ticket: '),
                                        subtitle: Text('${abc.data.trips[1].closed[index].ticketId}'),
                                        leading: Icon(Icons.confirmation_number,color: kColorAppBar),
                                      ),
                                      ListTile(contentPadding: EdgeInsets.fromLTRB(5, 5, 10, 0),
                                        title: Text('Fecha:'),
                                        subtitle: Text('${abc.data.trips[1].closed[index].ticketDatetime}'),
                                        leading: Icon(Icons.timer,color: kColorAppBar),
                                      ),
                                      ListTile(contentPadding: EdgeInsets.fromLTRB(5, 5, 10, 0),
                                        title: Text('Mensaje: '),
                                        subtitle: Text('${abc.data.trips[1].closed[index].ticketMessage}'),
                                        leading: Icon(Icons.location_pin,color: kColorAppBar),
                                      ),
                                      ListTile(contentPadding: EdgeInsets.fromLTRB(5, 5, 10, 0),
                                        title: Text('Respuesta por: ${abc.data.trips[1].closed[index].userName}'),
                                        subtitle: Text('${abc.data.trips[1].closed[index].replyMessage}'),
                                        leading: Icon(Icons.supervised_user_circle,color: kColorAppBar),
                                      ),
                                    ],),
                                  ),
                                  
                              
                                  SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ); 
                } 
              );
            },
          );          
        }
      } else {
        return ColorLoader3();
      }
    },
  ); 
}


}
