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
                  title: Text('Agentes', style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 20.0)),
                  subtitle: Text('No hay agentes confirmados para este viaje', style: TextStyle(color: Colors.red,fontWeight: FontWeight.normal,fontSize: 15.0)),
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
                                      Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 25.0),
                                          Column(
                                            children: [
                                              Icon(Icons.image_aspect_ratio,color: Colors.deepPurple[500],size: 35,),
                                              Text(' Asunto: ',style: TextStyle(color: Colors.deepPurple[500], fontSize: 17)),
                                              Text('${abc.data.trips[0].pendant[index].ticketIssue}',style: TextStyle(color: kTextColor)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: SizedBox(),
                                  children: [
                                  //ingreso de data
                                    Padding(padding: const EdgeInsets.all(10.0),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Icon(Icons.confirmation_number,color: Colors.deepPurple[500], size: 35),
                                              Text('No. Ticket: ',style: TextStyle(color: Colors.deepPurple[500],fontSize: 17)),
                                              Text('${abc.data.trips[0].pendant[index].ticketId}'),
                                            ],
                                            ),
                                          Column(
                                            children: [
                                              Icon(Icons.timer,color: Colors.deepPurple[500],size: 35),
                                              Text('Fecha:',style: TextStyle(color: Colors.deepPurple[500],fontSize: 17)),
                                              Text('${abc.data.trips[0].pendant[index].ticketDatetime}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(padding: const EdgeInsets.all(8.0),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Icon(Icons.location_pin,color: Colors.deepPurple[500],size: 35),
                                              Text('Mensaje: ',style: TextStyle(color: Colors.deepPurple[500],fontSize: 17)),
                                              Text('${abc.data.trips[0].pendant[index].ticketMessage}'),
                                            ],
                                          ),
                                        ],
                                      ),
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
                  title: Text('Agentes', style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 20.0)),
                  subtitle: Text('No hay agentes confirmados para este viaje', style: TextStyle(color: Colors.red,fontWeight: FontWeight.normal,fontSize: 15.0)),
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
                                    Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 25.0),
                                        Column(
                                          children: [
                                            Icon(Icons.image_aspect_ratio,color: Colors.deepPurple[500],size: 35),
                                            Text(' Asunto: ',style: TextStyle(color: Colors.deepPurple[500], fontSize: 17)),
                                            Text('${abc.data.trips[1].closed[index].ticketIssue}',style: TextStyle(color: kTextColor),),
                                          ],
                                        ),                                        
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: SizedBox(),
                                children: [
                                  //ingreso de data
                                  Container(
                                    margin: EdgeInsets.only(right: 12),
                                    child: Padding(padding: const EdgeInsets.all(10.0),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Icon(Icons.confirmation_number,color: Colors.deepPurple[500], size: 35),
                                              Text('No. Ticket: ',style: TextStyle(color: Colors.deepPurple[500],fontSize: 17)),
                                              Text('${abc.data.trips[1].closed[index].ticketId}'),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Icon(Icons.timer,color: Colors.deepPurple[500],size: 35,),
                                              Text('Fecha:',style: TextStyle(color: Colors.deepPurple[500],fontSize: 17)),
                                              Text('${abc.data.trips[1].closed[index].ticketDatetime}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                      children: [
                                        Icon(Icons.message,color: Colors.deepPurple[500],size: 35,),
                                        Text('Mensaje: ',style: TextStyle(color: Colors.deepPurple[500],fontSize: 17)),
                                        Text('${abc.data.trips[1].closed[index].ticketMessage}'),
                                      ],
                                    ),
                                    ],
                                  ),
                                  Padding(padding: const EdgeInsets.all(8.0),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Icon(Icons.supervised_user_circle,color: Colors.deepPurple[500],size: 35,),
                                            Text('Respuesta por: ${abc.data.trips[1].closed[index].userName}',style: TextStyle(color: Colors.deepPurple[500],fontSize: 17)),
                                            Text('${abc.data.trips[1].closed[index].replyMessage}'),
                                          ],
                                        ),
                                      ],
                                    ),
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
