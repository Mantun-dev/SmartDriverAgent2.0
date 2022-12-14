// ignore_for_file: unnecessary_null_comparison, import_of_legacy_library_into_null_safe

//import 'dart:ui';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_auth/Agents/Screens/Chat/chatapis.dart';
import 'package:flutter_auth/Agents/Screens/Chat/socketChat.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/loader.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/mask.dart';
import 'package:flutter_auth/Agents/models/messageCount.dart';
import 'package:flutter_auth/Agents/models/messageTrips.dart';
import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/Agents/models/rating.dart';
import 'package:flutter_auth/Agents/models/tripAgent.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:quickalert/quickalert.dart';
//import 'package:sweetalert/sweetalert.dart';
import 'package:url_launcher/url_launcher.dart';

class NextTripScreen extends StatefulWidget {
  //creación de instancias de clases de Json con sus variables
  final TripsList? item;
  final Plantilla? plantilla;
  final DataAgent? itemx;
  const NextTripScreen({Key? key, this.item, this.plantilla, this.itemx})
      : super(key: key);

  @override
  _NextTripScreenState createState() => _NextTripScreenState();
}

class _NextTripScreenState extends State<NextTripScreen>
    with WidgetsBindingObserver {
  //variables globales para cada función
  late Future<TripsList> item;
  late Future<DataAgent> itemx;
  final prefs = new PreferenciasUsuario();
  //variable para comentario
  String comment = ' ';

  //variables para las condiciones
  String condition = 'Confirmed';
  String conditionC = 'Canceled';

  TextEditingController message = new TextEditingController();

  //variables para rating
  late double rating1;
  late double rating2;
  late double rating3;
  String ip = "https://smtdriver.com";
  final tripId = 0;
  final StreamSocket streamSocket = StreamSocket(host: '192.168.1.3:3010');
  @override
  void initState() {
    super.initState();
    item = fetchTrips();
    itemx = fetchRefres();
    //función callback para mostrar automáticamente el mensaje de alerta de rating
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          this._showRatingAlert();
        });
      }
    });
    WidgetsBinding.instance.addObserver(this);
    message = new TextEditingController();

    //variable rating inicializadas
    rating1 = 0;
    rating2 = 0;
    rating3 = 0;

    //inicializador del botón de android para manejarlo manual
    BackButtonInterceptor.add(myInterceptor);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    // setState(() {
    // });
    if (AppLifecycleState.resumed == state) {
      fetchTripsButton();
    }
  }

//fetch Tips
  // ignore: missing_return
  Future<TripsList> fetchTripsButton() async {
    http.Response response =
        await http.get(Uri.parse('$ip/api/trips/${prefs.nombreUsuario}'));

    if (response.statusCode == 200) {
      final trip = TripsList.fromJson(json.decode(response.body));
      for (var i = 0; i < trip.trips.length; i++) {
        if (trip.trips[i].btnCancelTrip == false ||
            trip.trips[i].btnCancelTrip == true) {
          //print(trip.trips[i].btnCancelTrip);
          if (mounted) {
            Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailScreen(plantilla: plantilla[0])))
                .then((_) => DetailScreen(plantilla: plantilla[0]));
          }
        }
      }
    } else {
      throw Exception('Failed to load Data');
    }
    return fetchTripsButton();
  }

  @override
  void dispose() {
    //creación del dispose para removerlo después del evento
    BackButtonInterceptor.remove(myInterceptor);
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

//creación de función booleana para el evento del boton back android
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //print("BACK BUTTON!"); // Do some stuff.
    //Navigator.of(context).pop();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
        (Route<dynamic> route) => false);

    return true;
  }

//función para confirmar trip
  Future<dynamic> fetchConfirm(
      String agentUser, String tripId, String condition, String comment) async {
    //<List<Map<String, dynamic>>>
    prefs.tripId = tripId;
    Map data = {
      'agentUser': agentUser,
      'tripId': tripId,
      'condition': condition,
      'comment': comment,
    };
    //api confirm trip
    http.Response response =
        await http.post(Uri.parse('$ip/api/confirmTrip'), body: data);
    final resp = Message.fromJson(json.decode(response.body));
    http.Response responses = await http
        .get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final resps = DataAgent.fromJson(json.decode(responses.body));
    //alertas y redirecciones
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => DetailScreen(plantilla: plantilla[0])))
          .then((_) => DetailScreen(plantilla: plantilla[0]));
      QuickAlert.show(
        context: context,
          title: "Enviado",
          text: resp.message,
          type: QuickAlertType.success);
      final algo =
          await http.get(Uri.parse('$ip/api/getMaskReminder/${resps.agentId}'));
      //print(algo.body);
      showAlertDialog();
      Navigator.pop(context);
    } else if (response.statusCode == 500) {
      QuickAlert.show(
        context: context,
          title: "Alerta",
          text: resp.message,
          type: QuickAlertType.error);
    }
    return Message.fromJson(json.decode(response.body));
  }

  //función para cancel trip
  Future<dynamic> fetchCancel(String agentUser, String tripId,
      String conditionC, String message) async {
    //<List<Map<String, dynamic>>>
    Map data = {
      'agentUser': agentUser,
      'tripId': tripId,
      'condition': conditionC,
      'comment': message
    };
    //api cancel trip
    http.Response response =
        await http.post(Uri.parse('$ip/api/confirmTrip'), body: data);
    final resp = Message.fromJson(json.decode(response.body));

    //redirección y alertas
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => DetailScreen(plantilla: plantilla[0])))
          .then((_) => DetailScreen(plantilla: plantilla[0]));
          QuickAlert.show(
        context: context,
          title: "Cancelación éxitosa",
          text: "El motorista será notificado que usted no hará uso del transporte",
          type: QuickAlertType.success);
    } else if (response.statusCode == 500) {
      QuickAlert.show(
        context: context,
          title: "Alerta",
          text: resp.message,
          type: QuickAlertType.error);
    }
    return Message.fromJson(json.decode(response.body));
  }

  //función para skipear calificación
  Future<dynamic> fetchSkipRating(String agentId, String tripId, int rating1,
      int rating2, int rating3, String comment) async {
    //<List<Map<String, dynamic>>>
    Map data = {
      'agentId': agentId,
      'tripId': tripId,
      'rating1': rating1.toString(),
      'rating2': rating2.toString(),
      'rating3': rating3.toString(),
      'comment': comment,
    };
    //api rating
    http.Response response =
        await http.post(Uri.parse('$ip/api/ratingTrip'), body: data);
    final resp = MessageAccount.fromJson(json.decode(response.body));
    //alertas
    if (response.statusCode == 200 && resp.ok == true) {
      
      QuickAlert.show(
        context: context,
          title: resp.title,
          text: resp.message,
          type: QuickAlertType.success);
    } else if (response.statusCode == 200 && resp.ok != true) {
      QuickAlert.show(
        context: context,
          title: resp.title,
          text: resp.message,
          type: QuickAlertType.error);
    }
    return MessageAccount.fromJson(json.decode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<TripsList>(
              future: item,
              builder: (context, abc) {
                if (abc.connectionState == ConnectionState.done) {
                  //validación si el arreglo viene vacío
                  if (abc.data?.trips.length == 0) {
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
                              title: Text('Próximo viaje',
                                  style: TextStyle(
                                      color: thirdColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0)),
                              subtitle: Text('No tiene viajes asignados',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15.0)),
                            ),
                          ],
                        ),
                      ),
                    );
                    //validación si el arreglo contiene información
                  } else {
                    if (abc.connectionState == ConnectionState.done) {
                          //desplegar data dinámica con LisView builder
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                          itemCount: abc.data?.trips.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    blurStyle: BlurStyle.normal,
                                    color: Colors.white.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: Offset(-5, 12)),
                                BoxShadow(
                                    blurStyle: BlurStyle.normal,
                                    color: Colors.black.withOpacity(1),
                                    blurRadius: 18,
                                    spreadRadius: -15,
                                    offset: Offset(18, 5)),
                              ], borderRadius: BorderRadius.circular(15)),
                              child: Card(
                                color: backgroundColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: EdgeInsets.symmetric(vertical: 0),
                                elevation: 10,
                                child: Column(
                                  children: [
                                  ListTile(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5, 5, 10, 0),
                                    title: Text('Fecha: ', style: TextStyle(color: Colors.white),),
                                    subtitle:
                                        Text('${abc.data?.trips[index].fecha}', style: TextStyle(color: Colors.white),),
                                    leading: Icon(Icons.calendar_today,
                                        color: GradiantV1, size: 35),
                                  ),
                                  ListTile(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5, 5, 10, 0),
                                    title: Text('Hora: ', style: TextStyle(color: Colors.white),),
                                    subtitle: Text(
                                        '${abc.data?.trips[index].horaEntrada}', style: TextStyle(color: Colors.white,),),
                                    leading: Icon(Icons.timer, color: GradiantV1, size: 35),
                                  ),
                                  ListTile(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5, 5, 10, 0),
                                    title: Text('Motorista: ', style: TextStyle(color: Colors.white)),
                                    subtitle:
                                        Text('${abc.data?.trips[index].conductor}', style: TextStyle(color: Colors.white)),
                                    leading: Icon(Icons.card_travel,
                                      color: GradiantV1, size: 35),
                                  ),
                                  ListTile(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5, 5, 10, 0),
                                    title: Text('Teléfono: ', style: TextStyle(color: Colors.white)),
                                    subtitle: TextButton(
                                        onPressed: () => launchUrl(Uri.parse(
                                            'tel://${abc.data?.trips[index].telefono}')),
                                        child: Container(
                                            margin: EdgeInsets.only(right: 185),
                                            child: Text(
                                                '${abc.data?.trips[index].telefono}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14)))),
                                    leading: Icon(Icons.phone, color: GradiantV1, size: 35),
                                  ),
                                  ListTile(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5, 5, 10, 0),
                                    title: Text('Dirección: ', style: TextStyle(color: Colors.white)),
                                    subtitle:
                                        Text('${abc.data?.trips[index].direccion}', style: TextStyle(color: Colors.white)),
                                    leading:
                                        Icon(Icons.directions, color: GradiantV1, size: 35),
                                  ),
                                  if (abc.data?.trips[index].neighborhoodReferencePoint != null)...{
                                    ListTile(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(5, 5, 10, 0),
                                      title: Text('Acceso autorizado: ', style: TextStyle(color: Colors.white)),
                                      subtitle: Text(
                                          '${abc.data?.trips[index].neighborhoodReferencePoint}', style: TextStyle(color: Colors.white)),
                                      leading: Icon(Icons.bus_alert, color: GradiantV1, size: 35),
                                    ),},                               
                                  SizedBox(height: 20),
                                  //validación de mostrar si la condición está empty mostrar texto de necesita confirmación
                                  if ('${abc.data?.trips[index].condition}' =='empty') ...{
                                    ListTile(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(5, 5, 10, 0),
                                      title: Text('Hora de encuentro: ', style: TextStyle(color: Colors.white),),
                                      subtitle: Text(
                                          'Necesita confirmación para poder asignarle una hora de encuentro',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15.0)),
                                      leading:
                                          Icon(Icons.timer, color: GradiantV1, size: 35),
                                    ),
                                    SizedBox(height: 10,),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(                                    
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        backgroundColor: secondColor,
                                      ),
                                      onPressed: () {
                                        showGeneralDialog(
                                            barrierColor:
                                                Colors.black.withOpacity(0.5),
                                            transitionBuilder:
                                                (context, a1, a2, widget) {
                                              final curvedValue = Curves
                                                      .easeInOutBack
                                                      .transform(a1.value) -
                                                  1.0;
                                              return Transform(
                                                transform:
                                                    Matrix4.translationValues(0.0,
                                                        curvedValue * 200, 0.0),
                                                child: Opacity(
                                                  opacity: a1.value,
                                                  child: AlertDialog(
                                                    backgroundColor: backgroundColor,
                                                    shape: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                16.0)),
                                                    title: Center(
                                                        child:
                                                            Text('Confirmación', style: TextStyle(color: Colors.white))),
                                                    content: Text(
                                                        '¿Hará uso del transporte designado?',
                                                        textAlign:
                                                            TextAlign.center, style: TextStyle(color: Colors.white)),
                                                    actions: [
                                                      Container(
                                                          child: Center(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: [
                                                            
                                                            TextButton(
                                                              style: TextButton.styleFrom(
                                                                  foregroundColor:
                                                                      Colors.black,
                                                                  backgroundColor:
                                                                      firstColor),
                                                              onPressed: () => {
                                                                ChatApis().confirmOrCancel('CONFIRMADO'),                                                            
                                                                //función fetch confirm
                                                                fetchConfirm(
                                                                    prefs
                                                                        .nombreUsuario,
                                                                    '${abc.data?.trips[index].tripId}',
                                                                    condition,
                                                                    comment),
                                                              },
                                                              child: Text('Si'),
                                                            ),
                                                            
                                                            TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                      foregroundColor:
                                                                          Colors
                                                                              .black,
                                                                      backgroundColor:
                                                                          GradiantV_1),
                                                              child: Text('No'),
                                                              onPressed: () => {
                                                                Navigator.pop(
                                                                    context),
                                                                showGeneralDialog(
                                                                    barrierColor: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.5),
                                                                    transitionBuilder:
                                                                        (context,
                                                                            a1,
                                                                            a2,
                                                                            widget) {
                                                                      return Transform
                                                                          .scale(
                                                                        scale: a1
                                                                            .value,
                                                                        child:
                                                                            Opacity(
                                                                          opacity: a1
                                                                              .value,
                                                                          child:
                                                                              AlertDialog(
                                                                                backgroundColor: backgroundColor,
                                                                            shape: OutlineInputBorder(
                                                                                borderRadius:
                                                                                    BorderRadius.circular(16.0)),
                                                                            title: Center(
                                                                                child:
                                                                                    Text('¿Razón por la cual no hará uso del transporte?', textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
                                                                            content: TextField(
                                                                                controller:
                                                                                    message,
                                                                                decoration:
                                                                                    InputDecoration(labelText: 'Escriba aquí', labelStyle: TextStyle(color: Colors.white))),
                                                                            actions: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                children: [
                                                                                  
                                                                                  TextButton(
                                                                                    style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 20), foregroundColor: Colors.white, backgroundColor: firstColor),
                                                                                    onPressed: () => {
                                                                                      ChatApis().confirmOrCancel('RECHAZADO'),
                                                                                      
                                                                                      //función fetch cancel
                                                                                      fetchCancel(prefs.nombreUsuario, '${abc.data?.trips[index].tripId}', conditionC, message.text),
                                                                                      Navigator.pop(context),
                                                                                    },
                                                                                    child: Text('Enviar', style: TextStyle(color: Colors.black)),
                                                                                  ),
                                                                                  
                                                                                  TextButton(
                                                                                    style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 20), foregroundColor: Colors.white, backgroundColor: GradiantV_1),
                                                                                    onPressed: () => {
                                                                                      Navigator.pop(context),
                                                                                    },
                                                                                    child: Text('Cerrar', style: TextStyle(color: Colors.black)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    transitionDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                200),
                                                                    barrierDismissible:
                                                                        true,
                                                                    barrierLabel:
                                                                        '',
                                                                    context:
                                                                        context,
                                                                    pageBuilder: (context,
                                                                        animation1,
                                                                        animation2) {
                                                                      return widget;
                                                                    }),
                                                              },
                                                            ),
                                                            
                                                            TextButton(
                                                              style: TextButton.styleFrom(
                                                                  foregroundColor:
                                                                      Colors.black,
                                                                  backgroundColor:
                                                                      Gradiant2),
                                                              onPressed: () => {
                                                                Navigator.pop(
                                                                    context),
                                                              },
                                                              child: Text('Cerrar'),
                                                            ),
                                                            
                                                          ],
                                                        ),
                                                      ))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            transitionDuration:
                                                Duration(milliseconds: 200),
                                            barrierDismissible: true,
                                            barrierLabel: '',
                                            context: context,
                                            pageBuilder:
                                                (context, animation1, animation2) {
                                              return widget;
                                            });
                                      },
                                      child: Text(
                                          'Presione para confirmar o cancelar',
                                          style: TextStyle(color: backgroundColor2, fontSize: 16)),
                                    ),
                                    SizedBox(height: 20),
                                    //validación de condition in canceled
                                  }, 
                                  if ('${abc.data?.trips[index].condition}' == 'Canceled') ...{
                                    if ('${abc.data?.trips[index].commentDriver}' == 'No confirmó') ...{
                                      ListTile(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(5, 5, 10, 0),
                                        title: Text('Viaje cancelado: ' , style: TextStyle(color: Colors.white)),
                                        subtitle: Text('No confirmó a tiempo',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15.0)),
                                        leading:
                                            Icon(Icons.timer, color: GradiantV1, size: 35),
                                      ),
                                    } else ...{
                                      ListTile(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(5, 5, 10, 0),
                                        title: Text('Viaje cancelado: ' , style: TextStyle(color: Colors.white)),
                                        subtitle: Text(
                                            'Se ha notificado al motorista que usted no necesitará el transporte',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15.0)),
                                        leading:
                                            Icon(Icons.timer, color: GradiantV1, size: 35),
                                      ),
                                    },
                                    SizedBox(height: 20),
                                    //validación de horaConductor in empty
                                  } else if ('${abc.data?.trips[index].horaConductor}' ==
                                      'empty') ...{
                                    ListTile(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(5, 5, 10, 0),
                                      title: Text('Hora de encuentro: ', style: TextStyle(color: Colors.white)),
                                      subtitle: Text(
                                          'Viaje confirmado, espere a que el motorista asigne la hora a la que pasará por usted',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15.0)),
                                      leading:
                                          Icon(Icons.timer, color: GradiantV1, size: 35),
                                    ),
                                    SizedBox(height: 20),
                                    //validación que aparezca la hora
                                  } else ...{
                                    ListTile(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(5, 5, 10, 0),
                                      title: Text('Hora de encuentro: ', style: TextStyle(color: Colors.white),),
                                      subtitle: Text(
                                          '${abc.data?.trips[index].horaConductor}',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 25.0)),
                                      leading:
                                          Icon(Icons.timer, color: GradiantV1, size: 35),
                                    ),
                                  },
                                  if ('${abc.data?.trips[index].condition}' ==
                                      'Confirmed') ...{
                                    if (abc.data?.trips[index].companyId == 1 ||
                                        abc.data?.trips[index].companyId == 7 ||
                                        abc.data?.trips[index].companyId == 3 ||
                                        abc.data?.trips[index].companyId == 5 ||
                                        abc.data?.trips[index].companyId == 9 ||
                                        abc.data?.trips[index].companyId == 11 ||
                                        abc.data?.trips[index].companyId == 12) ...{
                                      if (abc.data?.trips[index].btnCancelTrip ==
                                          true) ...{
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors.red),
                                          child: Text('Cancelar viaje'),
                                          onPressed: () => {
                                            showGeneralDialog(
                                                barrierColor:
                                                    Colors.black.withOpacity(0.5),
                                                transitionBuilder:
                                                    (context, a1, a2, widget) {
                                                  return Transform.scale(
                                                    scale: a1.value,
                                                    child: Opacity(
                                                      opacity: a1.value,
                                                      child: AlertDialog(
                                                        shape: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0)),
                                                        title: Center(
                                                            child: Text(
                                                                '¿Razón por la cual no hará uso del transporte?',
                                                                textAlign: TextAlign
                                                                    .center)),
                                                        content: TextField(
                                                            controller: message,
                                                            decoration: InputDecoration(
                                                                labelText:
                                                                    'Escriba aquí')),
                                                        actions: [
                                                          Row(
                                                            children: [
                                                              SizedBox(width: 60.0),
                                                              TextButton(
                                                                style: TextButton.styleFrom(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                20),
                                                                    foregroundColor:
                                                                        Colors
                                                                            .white,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .blueAccent),
                                                                onPressed: () => {
                                                                  //función fetch cancel
                                                                  fetchCancel(
                                                                      prefs
                                                                          .nombreUsuario,
                                                                      '${abc.data?.trips[index].tripId}',
                                                                      conditionC,
                                                                      message.text),
                                                                  Navigator.pop(
                                                                      context),
                                                                },
                                                                child:
                                                                    Text('Enviar'),
                                                              ),
                                                              SizedBox(width: 10.0),
                                                              TextButton(
                                                                style: TextButton.styleFrom(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                20),
                                                                    foregroundColor:
                                                                        Colors
                                                                            .white,
                                                                    backgroundColor:
                                                                        Colors.red),
                                                                onPressed: () => {
                                                                  Navigator.pop(
                                                                      context),
                                                                },
                                                                child:
                                                                    Text('Cerrar'),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                transitionDuration:
                                                    Duration(milliseconds: 200),
                                                barrierDismissible: true,
                                                barrierLabel: '',
                                                context: context,
                                                pageBuilder: (context, animation1,
                                                    animation2) {
                                                  return widget;
                                                }),
                                          },
                                        ),
                                      } else ...{
                                        ListTile(
                                          contentPadding:
                                              EdgeInsets.fromLTRB(5, 5, 10, 0),
                                          title: Text('Viaje', style: TextStyle(color: Colors.white)),
                                          subtitle: Text(
                                              'Su tiempo para cancelar el viaje ha expirado',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15.0)),
                                          leading: Icon(Icons.timer, color: GradiantV1, size: 35),
                                        ),
                                      }
                                    }
                                  } else
                                    ...{},
                                ]),
                              ),
                            );
                          });               
                  
                    }else{
                    return CircularProgressIndicator();
                  }
                  
                  }
                } else {
                  return ColorLoader3();
                }
                //return SizedBox();
              },
            ),
      ],
    );
  }

//mostra y validaciones de para alert mask
  _showMaskAlert() async {
    http.Response responses = await http
        .get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final resp = DataAgent.fromJson(json.decode(responses.body));
    http.Response response =
        await http.get(Uri.parse('$ip/api/getMaskReminder/${resp.agentId}'));
    final resp1 = Mask.fromJson(json.decode(response.body));
    //validacion si fué visto la alerta
    //print(resp1.viewed);
    if (resp1.viewed != null) {
      await http
          .get(Uri.parse('$ip/api/markAsViewedMaskReminder/${resp.agentId}'));
    }
  }

//creación de alerta de mask
  showAlertDialog() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Container(
                width: 400,
                height: 410,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/image.png',
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 15),
                    Text(
                      '¡Recuerda!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Text(
                        'Para abordar la unidad debes usar mascarilla y careta, así nos protegemos todos 😊',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green),
                      onPressed: () => {
                        Navigator.pop(context),
                        _showMaskAlert(),
                      },
                      child: Text('Entendido'),
                    ),
                  ],
                ),
              ),
            ));
  }

//función para el valor de rating 1
  void onChanged1(double value) async {
    setState(() {
      rating1 = value;
    });
  }

//función para el valor de rating 2
  void onChanged2(double value) async {
    setState(() {
      rating2 = value;
    });
  }

//función para el valor de rating 3
  void onChanged3(double value) async {
    setState(() {
      rating3 = value;
    });
  }

  //mostrar y validación rating
  void _showRatingAlert() async {
    http.Response responses = await http
        .get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final resp = DataAgent.fromJson(json.decode(responses.body));
    http.Response response =
        await http.get(Uri.parse('$ip/api/ratingTrip/${resp.agentId}'));
    if (response.body.isNotEmpty) {
      final resp1 = Rating.fromJson(json.decode(response.body));
      //validación para mostrar alerta
      if (resp1.tripId != 0) {
        showAlertDialogRating();
      }
    }
  }

//creación de alerta
  showAlertDialogRating() async {
    //llamado de apis directamente
    http.Response responses = await http
        .get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final resp = DataAgent.fromJson(json.decode(responses.body));
    http.Response response =
        await http.get(Uri.parse('$ip/api/ratingTrip/${resp.agentId}'));
    final resp1 = Rating.fromJson(json.decode(response.body));
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                backgroundColor: backgroundColor,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Center(
                    child: Text(
                        '😄 ¿Cómo calificaría su último viaje con\n${resp1.driverFullname}? 😁 ', style: TextStyle(color: Colors.white),)),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: 300,
                    width: 500,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        //creación reacciones para conducción
                        Divider(),
                        SizedBox(height: 10.0),
                        Text('Conducción', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 5.0),
                        RatingBar.builder(
                          initialRating: 0,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return Icon(Icons.sentiment_very_dissatisfied,
                                    color: Colors.red);
                              case 1:
                                return Icon(Icons.sentiment_dissatisfied,
                                    color: Colors.redAccent);
                              case 2:
                                return Icon(Icons.sentiment_neutral,
                                    color: Colors.amber);
                              case 3:
                                return Icon(Icons.sentiment_satisfied,
                                    color: Colors.lightGreen);
                              case 4:
                                return Icon(Icons.sentiment_very_satisfied,
                                    color: Colors.green);
                            }
                            return SizedBox();
                          },
                          onRatingUpdate: (rating1) {
                            onChanged1(rating1);
                          },
                        ),
                        Divider(),
                        SizedBox(height: 10.0),
                        //creación reacciones para amabilidad
                        Text('Amabilidad del motorista', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 5.0),
                        RatingBar.builder(
                          initialRating: 0,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return Icon(Icons.sentiment_very_dissatisfied,
                                    color: Colors.red);
                              case 1:
                                return Icon(Icons.sentiment_dissatisfied,
                                    color: Colors.redAccent);
                              case 2:
                                return Icon(Icons.sentiment_neutral,
                                    color: Colors.amber);
                              case 3:
                                return Icon(
                                  Icons.sentiment_satisfied,
                                  color: Colors.lightGreen,
                                );
                              case 4:
                                return Icon(Icons.sentiment_very_satisfied,
                                    color: Colors.green);
                            }
                            return SizedBox();
                          },
                          onRatingUpdate: (rating2) {
                            onChanged2(rating2);
                          },
                        ),
                        Divider(),
                        SizedBox(height: 10.0),
                        //creación reacciones para condiciones
                        Text('Condiciones del vehículo', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 5.0),
                        RatingBar.builder(
                          initialRating: 0,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return Icon(Icons.sentiment_very_dissatisfied,
                                    color: Colors.red);
                              case 1:
                                return Icon(Icons.sentiment_dissatisfied,
                                    color: Colors.redAccent);
                              case 2:
                                return Icon(Icons.sentiment_neutral,
                                    color: Colors.amber);
                              case 3:
                                return Icon(Icons.sentiment_satisfied,
                                    color: Colors.lightGreen);
                              case 4:
                                return Icon(Icons.sentiment_very_satisfied,
                                    color: Colors.green);
                            }
                            return SizedBox();
                          },
                          onRatingUpdate: (rating3) {
                            onChanged3(rating3);
                          },
                        ),
                      ]),
                    ),
                  );
                }),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      
                      ButtonTheme(
                          minWidth: 60.0,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: secondColor),
                            onPressed: () => {
                              //fetch skip Rating
                              fetchSkipRating(
                                  resp.agentId.toString(),
                                  resp1.tripId.toString(),
                                  rating1.toInt(),
                                  rating2.toInt(),
                                  rating3.toInt(),
                                  message.text),
                              Navigator.pop(context),
                            },
                            child: Text('Omitir'),
                          )),
                      
                      ButtonTheme(
                          minWidth: 60.0,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: kgray),
                            onPressed: () => {
                              Navigator.pop(context),
                            },
                            child: Text('Ahora no'),
                          )),
                      
                      ButtonTheme(
                        minWidth: 60.0,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: GradiantV1),
                          onPressed: () => {
                            Navigator.pop(context),
                            showGeneralDialog(
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionBuilder: (context, a1, a2, widget) {
                                  return Transform.scale(
                                    scale: a1.value,
                                    child: Opacity(
                                      opacity: a1.value,
                                      child: AlertDialog(
                                        backgroundColor: backgroundColor,
                                        shape: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0)),
                                        title: Center(
                                            child: Text(
                                                'Estamos evaluando a nuestros \nmotoristas, para esto es \nmuy importante su comentario.',
                                                textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
                                        content: TextField(
                                            controller: message,
                                            decoration: InputDecoration(
                                                labelText: 'Escriba aquí'),
                                                style: TextStyle(color: Colors.white),
                                                ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 40),
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        GradiantV1),
                                                onPressed: () => {
                                                  //fetch skip rating
                                                  fetchSkipRating(
                                                      resp.agentId.toString(),
                                                      resp1.tripId.toString(),
                                                      rating1.toInt(),
                                                      rating2.toInt(),
                                                      rating3.toInt(),
                                                      message.text),
                                                  Navigator.pop(context),
                                                },
                                                child: Text('Enviar'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 200),
                                barrierDismissible: false,
                                barrierLabel: '',
                                context: context,
                                pageBuilder: (context, animation1, animation2) {
                                  return widget;
                                }),
                          },
                          child: Text('Enviar'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 15.0),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return widget;
        });
  }

//////////////////////////////////////////////////// Funciones //////////////////////////////////////////
}
