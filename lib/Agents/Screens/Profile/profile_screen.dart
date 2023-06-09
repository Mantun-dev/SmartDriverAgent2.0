import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/loader.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen_changes.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/Screens/Signup/components/background.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/network.dart';
//import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/Agents/models/profileAgent.dart';
//import 'package:flutter_auth/Agents/models/profileAgent.dart';
//import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/components/AppBarSuperior.dart';
import 'package:flutter_auth/components/backgroundB.dart';
import 'package:flutter_auth/components/solictud_cambio.dart';
import 'package:flutter_svg/svg.dart';
import '../../../components/AppBarPosterior.dart';
import '../../../constants.dart';

void main() {
  runApp(ProfilePage());
}

class ProfilePage extends StatefulWidget {
  //instancias de plantilla y perfil con sus variabless
  final Plantilla? plantilla;
  final Profile? item;
  final Profile? itemx;
  const ProfilePage({Key? key, this.plantilla, this.item, this.itemx})
      : super(key: key);
  @override
  _DataTableExample createState() => _DataTableExample();
}

class _DataTableExample extends State<ProfilePage> {
  //variables
  Future<Profile>? item;
  Future<DataAgent>? itemx;

  @override
  void initState() {
    super.initState();
    itemx = fetchRefres();
    //indexar variable a fetch
    item = fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BackgroundBody(
      child: Scaffold(
        backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(56),
                  child: AppBarSuperior(item: 1,)
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: body(),
                    ),
                    AppBarPosterior(item:1),
                  ],
                ),
              ),
    );
  }

  Padding body() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all( 
            color: Color.fromRGBO(238, 238, 238, 1),
            width: 2
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        child: ListView(children: <Widget>[
              SizedBox(height: 20.0),
              //future builder para Profile
              FutureBuilder<Profile>(
                future: item,
                builder: (BuildContext context, abc) {
                  if (abc.connectionState == ConnectionState.done) {
                    //ingreso de data
                    return SingleChildScrollView(
                      child: Container(
      
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Alinea los textos a la izquierda
                          children: [
                            if (prefs.companyId == "8") ...{
                              if (abc.data == null) ...{
                                Text('No. empleado: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Usuario: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Nombre: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Teléfono: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Email: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Dirección: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Acceso autorizado: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                              } else ...{
                                Text('No. empleado: ${abc.data!.agentUser}',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Usuario: ${abc.data!.agentUser}',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Nombre: ${abc.data!.agentFullname}',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Teléfono: ${abc.data!.agentPhone}',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Email: ${abc.data!.agentEmail}',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Dirección: ${abc.data!.agentReferencePoint}, ${abc.data!.neighborhoodName}, ${abc.data!.townName}',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                if (abc.data!.neighborhoodReferencePoint == null)
                                  ...{}
                                else ...{
                                  Text('Acceso autorizado: ${abc.data!.neighborhoodReferencePoint}',
                                      style: TextStyle(color: Colors.black, fontSize: 16)),
                                }
                              },
                            } else ...{
                              if (abc.data == null) ...{
                                Text('No. empleado: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Cuenta: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Usuario: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Nombre: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Teléfono: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Email: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Dirección: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                Text('Acceso autorizado: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                              } else ...{
                                Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/Numeral.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'No. empleado: ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${abc.data!.agentUser}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Color.fromRGBO(158, 158, 158, 1),
                                ),
                                SizedBox(height: 20),
                                if (abc.data!.countName == null)
                                  ...{
                                    Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/Numeral.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Cuenta: ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Color.fromRGBO(158, 158, 158, 1),
                                ),
                                SizedBox(height: 20),
                                  }
                                else ...{
                                  Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/Numeral.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Cuenta: ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${abc.data!.countName}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Color.fromRGBO(158, 158, 158, 1),
                                ),
                                SizedBox(height: 20),
                                },
                                Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/Numeral.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Usuario: ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${abc.data!.agentUser}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Color.fromRGBO(158, 158, 158, 1),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/Numeral.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Nombre: ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${abc.data!.agentFullname}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Color.fromRGBO(158, 158, 158, 1),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/Numeral.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Teléfono: ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${abc.data!.agentPhone}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Color.fromRGBO(158, 158, 158, 1),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/Numeral.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Email: ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${abc.data!.agentEmail}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Color.fromRGBO(158, 158, 158, 1),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/Numeral.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Dirección: ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${abc.data!.agentReferencePoint}, ${abc.data!.neighborhoodName}, ${abc.data!.townName}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Color.fromRGBO(158, 158, 158, 1),
                                ),
                                SizedBox(height: 20),
                                if (abc.data!.neighborhoodReferencePoint == null)
                                  ...{}
                                else ...{
                                  Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/Numeral.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Acceso autorizado: ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${abc.data!.neighborhoodReferencePoint}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Color.fromRGBO(158, 158, 158, 1),
                                ),
                                SizedBox(height: 20),
                                }
                              },
                            },
                          ],
                        )

                      ),
                    );
                  } else {
                    return ColorLoader3();
                  }
                },
              ),
              SizedBox(height: 30.0),
              Center(
                  child: Text(
                'Horario laboral',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: firstColor),
              )),
              //ingreso de data por el future builder horario
              FutureBuilder<Profile>(
                future: item,
                builder: (BuildContext context, abc) {
                  if (abc.connectionState == ConnectionState.done) {
                    //data
                    return SingleChildScrollView(
                      child: Container(
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
                          color: backgroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.all(15),
                          elevation: 10,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            width: 550,
                            height: 400,
                            child: Column(
                              children: [
                                if (prefs.companyId == "8") ...{
                                  DataTable(
                                    columns: [
                                      DataColumn(
                                          label: Text('Día',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Gradiant2))),
                                      DataColumn(
                                          label: Text('Salida',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Gradiant2))),
                                    ],
                                    rows: [
                                      if (abc.data == null) ...{
                                        DataRow(cells: [
                                          DataCell(Text('Lunes',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Martes',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Miercoles',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Jueves',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Viernes',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Sábado',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Domingo',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text(''))
                                        ]),
                                      } else ...{
                                        DataRow(cells: [
                                          DataCell(Text('Lunes',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.mondayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.mondayOut}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Martes',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.tuesdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.tuesdayOut}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Miercoles',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.wednesdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.wednesdayOut}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
      
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Jueves',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.thursdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.thursdayOut}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Viernes',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.fridayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.fridayOut}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Sábado',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.saturdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.saturdayOut}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Domingo',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.sundayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.sundayOut}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                      },
                                    ],
                                  ),
                                } else ...{
                                  DataTable(
                                    columns: [
                                      DataColumn(
                                          label: Text('Día',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Gradiant2))),
                                      DataColumn(
                                          label: Text('Entrada',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Gradiant2))),
                                      DataColumn(
                                          label: Text('Salida',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Gradiant2))),
                                    ],
                                    rows: [
                                      if (abc.data == null) ...{
                                        DataRow(cells: [
                                          DataCell(Text('Lunes',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text('')),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Martes',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text('')),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Miercoles',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text('')),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Jueves',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text('')),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Viernes',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text('')),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Sábado',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text('')),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Domingo',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text('')),
                                          DataCell(Text(''))
                                        ]),
                                      } else ...{
                                        DataRow(cells: [
                                          DataCell(Text('Lunes',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.mondayIn}' ==
                                                      'null') {
                                                    return Text('Día libre',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.mondayIn}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              })),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.mondayOut}' ==
                                                      'null') {
                                                    return Text(
                                                      'Día libre',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    );
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.mondayOut}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Martes',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.tuesdayIn}' ==
                                                      'null') {
                                                    return Text('Día libre',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.tuesdayIn}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              })),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.tuesdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.tuesdayOut}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Miercoles',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.wednesdayIn}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.wednesdayIn}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              })),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.wednesdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.wednesdayOut}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
      
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Jueves',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.thursdayIn}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.thursdayIn}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              })),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.thursdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.thursdayOut}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Viernes',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.fridayIn}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.fridayIn}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              })),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.fridayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.fridayOut}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Sábado',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.saturdayIn}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.saturdayIn}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              })),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.saturdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.saturdayOut}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Domingo',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.sundayIn}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.sundayIn}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              })),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.sundayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: TextStyle(
                                          color: Colors.white));
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.sundayOut}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white));
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                      },
                                    ],
                                  ),
                                },
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return ColorLoader3();
                  }
                },
              ),
              FutureBuilder<DataAgent>(
                  future: itemx,
                  builder: (context, abc) {
                    if (abc.connectionState == ConnectionState.done) {
                      if (abc.data!.companyId != 7) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: SolicitudCambio(
                            press: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailScreenChanges(plantilla: plantilla[3]);
                              }));
                            },
                          ),
                        );
                      } else {
                        Text('');
                      }
                    } else {
                      return Text("");
                    }
                    return Text("");
                  }),
              SizedBox(height: 50)
            ]),
      ),
    );
  }
}
