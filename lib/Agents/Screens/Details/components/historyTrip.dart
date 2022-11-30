import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/loader.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/models/historyTrips.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter_auth/Agents/models/network.dart';

class HistoryTripScreen extends StatefulWidget {
  //declaración de clase Story y su variable
  final Story? item;
  const HistoryTripScreen({Key? key, this.item}) : super(key: key);

  @override
  _HistoryTripScreenState createState() => _HistoryTripScreenState();
}

class _HistoryTripScreenState extends State<HistoryTripScreen> {
  //declaración de variables globales
  final prefs = new PreferenciasUsuario();
  Future<List<Story>>? item;
  final format = DateFormat("HH:mm");

  @override
  void initState() {
    super.initState();
    item = fetchTripsStory();
    //inicializador del botón de android para manejarlo manual
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    //creación del dispose para removerlo después del evento
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

//creación de función booleana para el evento del boton back android
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //print("BACK BUTTON!"); // Do some stuff.
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
        (Route<dynamic> route) => false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //future builder de Story trip
    return FutureBuilder<List<Story>>(
      future: item,
      builder: (BuildContext context, abc) {
        if (abc.connectionState == ConnectionState.done) {
          //validación arreglo vacio
          if (abc.data!.length == 0) {
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
                          title: Text('Agentes',
                              style: TextStyle(
                                  color: thirdColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0)),
                          subtitle: Text('No hay viajes realizados',
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
            //retorno de ListView builder
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                //tamaño del arreglo por parte del future builder
                itemCount: abc.data!.length,
                itemBuilder: (context, index) {
                  //retorno de card con datos ingresados
                  return Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          blurStyle: BlurStyle.normal,
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: -8,
                          offset: Offset(-15, -6)),
                      BoxShadow(
                          blurStyle: BlurStyle.normal,
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 30,
                          spreadRadius: -15,
                          offset: Offset(18, 5)),
                    ], borderRadius: BorderRadius.circular(15)),
                    child: Card(
                      color: backgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(1.0),
                      elevation: 2,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ExpansionTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5, 5, 10, 0),
                                    title: Text(
                                      'Fecha: ',
                                      style: TextStyle(
                                          color: secondColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      '${abc.data![index].fecha}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    leading: Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: SizedBox(),
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      if (abc.data![index].hora == null) ...{
                                        ListTile(
                                          contentPadding:
                                              EdgeInsets.fromLTRB(5, 5, 10, 0),
                                          title: Text('Hora de encuentro: '),
                                          subtitle: Text(''),
                                          leading: Icon(Icons.timer,
                                              color: kColorAppBar),
                                        ),
                                      } else ...{
                                        ListTile(
                                          contentPadding:
                                              EdgeInsets.fromLTRB(5, 5, 10, 0),
                                          title: Text('Hora de encuentro: '),
                                          subtitle:
                                              Text('${abc.data![index].hora}'),
                                          leading: Icon(Icons.timer,
                                              color: kColorAppBar),
                                        ),
                                      },
                                      ListTile(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(5, 5, 10, 0),
                                        title: Text('Motorista: '),
                                        subtitle: Text(
                                            '${abc.data![index].conductor}'),
                                        leading: Icon(Icons.card_travel,
                                            color: kColorAppBar),
                                      ),
                                      ListTile(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(5, 5, 10, 0),
                                        title: Text('Teléfono: '),
                                        subtitle: TextButton(
                                            onPressed: () => launchUrl(Uri.parse(
                                                'tel://${abc.data![index].telefono}')),
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 100),
                                                child: Text(
                                                    '${abc.data![index].telefono}',
                                                    style: TextStyle(
                                                        color: Colors.blue[500],
                                                        fontSize: 14)))),
                                        leading: Icon(Icons.phone,
                                            color: kColorAppBar),
                                      ),
                                      ListTile(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(5, 5, 10, 0),
                                        title: Text('Dirección: '),
                                        subtitle: Text(
                                            '${abc.data![index].direccion}'),
                                        leading: Icon(Icons.directions,
                                            color: kColorAppBar),
                                      ),
                                      ListTile(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(5, 5, 10, 0),
                                        title: Text('Estado: '),
                                        subtitle:
                                            Text('${abc.data![index].estado}'),
                                        leading: Icon(Icons.verified_user,
                                            color: kColorAppBar),
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
                  );
                });
          }
        } else {
          return ColorLoader3();
        }
      },
    );
  }
}
