import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/loader.dart';

import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/Screens/Signup/components/background.dart';
import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/Agents/models/ticketHistory.dart';
import 'package:flutter_auth/components/AppBarSuperior.dart';
import 'package:flutter_auth/constants.dart';

import '../../../../components/AppBarPosterior.dart';
import '../../../../components/backgroundB.dart';
import '../../../../components/menu_lateral.dart';

void main() {
  runApp(HistoryTicketScreen());
}

class HistoryTicketScreen extends StatefulWidget {
  //declaración instancia de plantilla y TripsList6 con sus variables
  final Plantilla? plantilla;
  final TripsList6? item;
  const HistoryTicketScreen({Key? key, this.plantilla, this.item})
      : super(key: key);
  @override
  _DataTableExample createState() => _DataTableExample();
}

class _DataTableExample extends State<HistoryTicketScreen> {
  // variable con instancia
  Future<TripsList6>? item;

  @override
  void initState() {
    super.initState();
    //asignación de variable al fetch desde ticket story en network
    item = fetchTicketStory();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundBody(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(56),
                    child: AppBarSuperior(item: 7,)
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: cuerpo(),
                      ),
                      AppBarPosterior(item:-1),
                    ],
                  ),
                ),
      ),
    );
  }

  ListView cuerpo() {
    return ListView(children: <Widget>[
          SizedBox(height: 20.0),
          Center(
              child: Text(
            'Tickets pendientes',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kCardColor2),
          )),
          _ticketPendant(),
          SizedBox(height: 20.0),
          Center(
              child: Text(
            'Tickets procesados',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kCardColor2),
          )),
          _ticketProcess(),
          SizedBox(height: 50)
        ]);
  }

  Widget _ticketPendant() {
    //construcción de future builder para mostrar data
    return FutureBuilder<TripsList6>(
      future: item,
      builder: (BuildContext context, abc) {
        if (abc.connectionState == ConnectionState.done) {
          //validación de arreglo vacio
          if (abc.data!.trips[0].pendant!.length == 0) {
            return Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurStyle: BlurStyle.normal,
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: -13,
                    offset: Offset(-15, -6)),
                BoxShadow(
                    blurStyle: BlurStyle.normal,
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 18,
                    spreadRadius: -15,
                    offset: Offset(18, 5)),
              ], borderRadius: BorderRadius.circular(15)),
              child: Card(
                elevation: 10,
                color: backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.bus_alert,
                        size: 50,
                        color: Colors.white,
                      ),
                      title: Text('Tickets',
                          style: TextStyle(
                              color: thirdColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0)),
                      subtitle: Text('No hay tickets pendientes',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0)),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return FutureBuilder<TripsList6>(
              future: item,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: abc.data!.trips[0].pendant!.length,
                    itemBuilder: (context, index) {
                      //retorno de container y card con la data respectiva
                      return Container(
                        width: 500.0,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              blurStyle: BlurStyle.normal,
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: -13,
                              offset: Offset(-15, -6)),
                          BoxShadow(
                              blurStyle: BlurStyle.normal,
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 18,
                              spreadRadius: -15,
                              offset: Offset(18, 5)),
                        ], borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Card(
                              color: backgroundColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.all(15.0),
                              elevation: 2,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ExpansionTile(
                                      backgroundColor: backgroundColor,
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          ListTile(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                5, 5, 10, 0),
                                            title: Text('Asunto: ',
                                                style: TextStyle(
                                                    color: secondColor,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            subtitle: Text(
                                                '${abc.data!.trips[0].pendant![index].ticketIssue}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15)),
                                            leading: Icon(
                                              Icons.image_aspect_ratio,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: SizedBox(),
                                      children: [
                                        //ingreso de data
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        5, 5, 10, 0),
                                                title: Text('No. Ticket: ',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                subtitle: Text(
                                                    '${abc.data!.trips[0].pendant![index].ticketId}',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                leading: Icon(
                                                    Icons.confirmation_number,
                                                    color: GradiantV1,
                                                    size: 35),
                                              ),
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        5, 5, 10, 0),
                                                title: Text('Fecha:',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                subtitle: Text(
                                                    '${abc.data!.trips[0].pendant![index].ticketDatetime}',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                leading: Icon(Icons.timer,
                                                    color: GradiantV1,
                                                    size: 35),
                                              ),
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        5, 5, 10, 0),
                                                title: Text('Mensaje: ',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                subtitle: Text(
                                                    '${abc.data!.trips[0].pendant![index].ticketMessage}',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                leading: Icon(
                                                    Icons.location_pin,
                                                    color: GradiantV1,
                                                    size: 35),
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
                    });
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
    return FutureBuilder<TripsList6>(
      future: item,
      builder: (BuildContext context, abc) {
        if (abc.connectionState == ConnectionState.done) {
          //validación de arreglo vacio
          if (abc.data!.trips[1].closed?.length == 0) {
            return Container(
              width: 500.0,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurStyle: BlurStyle.normal,
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: -13,
                    offset: Offset(-15, -6)),
                BoxShadow(
                    blurStyle: BlurStyle.normal,
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 18,
                    spreadRadius: -15,
                    offset: Offset(18, 5)),
              ], borderRadius: BorderRadius.circular(15)),
              child: Card(
                elevation: 10,
                color: backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.bus_alert,
                        size: 50,
                        color: Colors.white,
                      ),
                      title: Text('Tickets',
                          style: TextStyle(
                              color: thirdColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0)),
                      subtitle: Text('No hay tickets en proceso',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0)),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return FutureBuilder<TripsList6>(
              future: item,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                //retorna el ListView builder para la data dinámica
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: abc.data!.trips[1].closed?.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 500.0,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              blurStyle: BlurStyle.normal,
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: -13,
                              offset: Offset(-15, -6)),
                          BoxShadow(
                              blurStyle: BlurStyle.normal,
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 18,
                              spreadRadius: -15,
                              offset: Offset(18, 5)),
                        ], borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Card(
                              color: backgroundColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.all(15.0),
                              elevation: 2,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ExpansionTile(
                                      backgroundColor: backgroundColor,
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          ListTile(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                5, 5, 10, 0),
                                            title: Text('Asunto: ',
                                                style: TextStyle(
                                                    color: secondColor,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            subtitle: Text(
                                                '${abc.data?.trips[1].closed![index].ticketIssue}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15)),
                                            leading: Icon(
                                              Icons.image_aspect_ratio,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: SizedBox(),
                                      children: [
                                        //ingreso de data
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        5, 5, 10, 0),
                                                title: Text('No. Ticket: ',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                subtitle: Text(
                                                    '${abc.data!.trips[1].closed![index].ticketId}',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                leading: Icon(
                                                    Icons.confirmation_number,
                                                    color: GradiantV1,
                                                    size: 35),
                                              ),
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        5, 5, 10, 0),
                                                title: Text('Fecha:',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                subtitle: Text(
                                                    '${abc.data!.trips[1].closed![index].ticketDatetime}',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                leading: Icon(Icons.timer,
                                                    color: GradiantV1,
                                                    size: 35),
                                              ),
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        5, 5, 10, 0),
                                                title: Text('Mensaje: ',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                subtitle: Text(
                                                    '${abc.data!.trips[1].closed![index].ticketMessage}',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                leading: Icon(
                                                    Icons.location_pin,
                                                    color: GradiantV1,
                                                    size: 35),
                                              ),
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        5, 5, 10, 0),
                                                title: Text(
                                                    'Respuesta por: ${abc.data!.trips[1].closed![index].userName}',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                subtitle: Text(
                                                    '${abc.data!.trips[1].closed![index].replyMessage}',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                leading: Icon(
                                                    Icons
                                                        .supervised_user_circle,
                                                    color: GradiantV1,
                                                    size: 35),
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
                    });
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