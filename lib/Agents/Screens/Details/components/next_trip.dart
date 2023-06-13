import 'package:back_button_interceptor/back_button_interceptor.dart';
//import 'package:carousel_slider/carousel_slider.dart';
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
//import 'package:flutter_auth/Agents/models/rating.dart';
import 'package:flutter_auth/Agents/models/tripAgent.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:quickalert/quickalert.dart';
//import 'package:sweetalert/sweetalert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/progress_indicator.dart';

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
  late double rating4;
  late double rating5;
  late double rating6;

  TextEditingController comentario1 = new TextEditingController();
  TextEditingController comentario2 = new TextEditingController();
  TextEditingController comentario3 = new TextEditingController();
  TextEditingController comentario4 = new TextEditingController();
  TextEditingController comentario5 = new TextEditingController();
  TextEditingController comentario6 = new TextEditingController();

  String rating11 = "1";
  String rating22 = "2";
  String rating33 = "3";
  String rating44 = "4";
  String rating55 = "5";
  String rating66 = "6";

  bool viajesProceso=true;

  late Future<List<dynamic>> item2;
  int totalSolicitudes = 0;
  int totalViajes = 0;

  String ip = "https://smtdriver.com";
  final tripId = 0;
  final StreamSocket streamSocket = StreamSocket(host: '192.168.1.3:3010');
  @override
  void initState() {
    super.initState();
    item = fetchTrips();
    itemx = fetchRefres();
    item2=getSolicitudes();
    obtenerLongitud();
    //función callback para mostrar automáticamente el mensaje de alerta de rating
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // if (mounted) {
      //   setState(() {
      //   });
      // }
          this._showRatingAlert();
    });
    WidgetsBinding.instance.addObserver(this);
    message = new TextEditingController();

    //variable rating inicializadas
    rating1 = 0;
    rating2 = 0;
    rating3 = 0;
    rating4 = 0;
    rating5 = 0;
    rating6 = 0;

    //inicializador del botón de android para manejarlo manual
    BackButtonInterceptor.add(myInterceptor);
  }

  Future<List<dynamic>> getSolicitudes() async {
    Map data = {
      "agentId": prefs.usuarioId.toString()
    };

    http.Response response = await http.post(Uri.parse('https://admin.smtdriver.com/transportationRequests'), body: data);

    var dataR = json.decode(response.body);

    if (dataR["ok"] == true) {
      setState(() {
        totalSolicitudes = dataR["requests"].length;
      });
      return dataR["requests"]; // Retornar la lista de la propiedad "data"
    } else {
      return []; // Retorna una lista vacía
    }
  }

  void obtenerLongitud() async {
    TripsList tripsList = await item;
    setState(() {
      totalViajes = tripsList.trips.length;
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    // setState(() {
    // });
    if (AppLifecycleState.resumed == state) {
      if(mounted){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>DetailScreen(plantilla: plantilla[0])),(Route<dynamic> route) => false);
      }
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
      print('Failed to load Data');
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
          text: 'Su viaje ha sido confirmado',
          type: QuickAlertType.success);
      final algo =
          await http.get(Uri.parse('$ip/api/getMaskReminder/${resps.agentId}'));

      Map data2 = {"idU": resps.agentId.toString(), "Estado": 'CONFIRMADO'};
      String sendData2 = json.encode(data2);
      await http.put(Uri.parse('https://apichat.smtdriver.com/api/salas/$tripId'), body: sendData2, headers: {"Content-Type": "application/json"});

      //print(algoe.body);
      //showAlertDialog();
    } else if (response.statusCode == 500) {
      QuickAlert.show(
        context: context,
        title: "Alerta",
        text: resp.message,
        type: QuickAlertType.error
      );
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

    http.Response responses = await http
        .get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final resps = DataAgent.fromJson(json.decode(responses.body));

    Map data2 = {"idU": resps.agentId.toString(), "Estado": 'RECHAZADO'};
      String sendData2 = json.encode(data2);
      await http.put(Uri.parse('https://apichat.smtdriver.com/api/salas/$tripId'), body: sendData2, headers: {"Content-Type": "application/json"});

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
          text:
              "El motorista será notificado que usted no hará uso del transporte",
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
      int rating2, int rating3, int rating4, int rating5, int rating6, //String comment, 
      String comment1, String comment2, String comment3, String comment4, String comment5, String comment6, bool omitir) async {
    
    Map data = {
      'agentId': agentId,
      'tripId': tripId,
      'kindness': rating1.toString(),
      'focus': rating2.toString(),
      'driving': rating3.toString(),
      'punctualityA': rating4.toString(),
      'punctualityB': rating5.toString(),
      'vehicleStatus': rating6.toString(),
      'commentKindness': comment1,
      'commentFocus': comment2,
      'commentDriving': comment3,
      'commentPunctualityA': comment4,
      'commentPunctualityB': comment5,
      'commentVehicleStatus': comment6,
    };
    print(data);
    //api rating
    http.Response response =
        await http.post(Uri.parse('https://admin.smtdriver.com/registerRating'), body: data);
        
    final resp = MessageAccount.fromJson(json.decode(response.body));

    if(omitir)
      return;
    //alertas
    if (response.statusCode == 200 && resp.ok == true) {
      QuickAlert.show(
          context: context,
          title: 'Enviado',
          text: resp.message,
          type: QuickAlertType.success);
    } else if (response.statusCode == 200 && resp.ok != true) {
      QuickAlert.show(
          context: context,
          title: 'Error',
          text: resp.message,
          type: QuickAlertType.error);
    }
  
  }

    //función para skipear calificación
  Future<dynamic>fetchSkipRating2(String agentId, String tripId, int rating1, int rating2, int rating3, String comment) async {
      //<List<Map<String, dynamic>>>
      Map data = {
        'agentId' : agentId,
        'tripId'    : tripId,
        'rating1' :  rating1.toString(),
        'rating2'   : rating2.toString(),
        'rating3'   : rating3.toString(),
        'comment'   : comment,
      };
    //api rating
    http.Response response = await http.post(Uri.parse('$ip/api/ratingTrip'), body: data);
    final resp = MessageAccount.fromJson(json.decode(response.body));
      //alertas
      if (response.statusCode == 200 && resp.ok == true) {   
        QuickAlert.show(
          context: context,
          title: 'Enviado',
          text: resp.message,
          type: QuickAlertType.success);  
      } 
      else if(response.statusCode == 200 && resp.ok != true){
        QuickAlert.show(
          context: context,
          title: 'Error',
          text: resp.message,
          type: QuickAlertType.error);
      }
    return MessageAccount.fromJson(json.decode(response.body));
  }  
  


  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(238, 238, 238, 1),
             width: 2
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 0,
                color: const Color.fromRGBO(241, 239, 239, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: viajesProceso ? Color.fromRGBO(40, 93, 169, 1) : Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              viajesProceso = true;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                'Viajes programados',
                                style: TextStyle(
                                  color: viajesProceso ? Colors.white: Colors.black,
                                ),
                              ),

                                Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: viajesProceso ? Colors.white: Color.fromRGBO(40, 93, 169, 1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    totalViajes.toString(),
                                    style: TextStyle(
                                      color: !viajesProceso ? Colors.white: Color.fromRGBO(40, 93, 169, 1),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Stack(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: viajesProceso ? Colors.transparent : Color.fromRGBO(40, 93, 169, 1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              viajesProceso = false;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                'Solicitudes',
                                style: TextStyle(
                                  color: !viajesProceso ? Colors.white: Colors.black,
                                ),
                              ),

                                Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: !viajesProceso ? Colors.white: Color.fromRGBO(40, 93, 169, 1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    totalSolicitudes.toString(),
                                    style: TextStyle(
                                      color: viajesProceso ? Colors.white: Color.fromRGBO(40, 93, 169, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),             
            viajesProceso==false?
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14.0, left: 14, right: 14),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                               child: SvgPicture.asset(
                                "assets/icons/advertencia.svg",
                                color: Color.fromRGBO(40, 93, 169, 1),
                              ),
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                "Nos gustaría saber si necesitarás transporte" ,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      FutureBuilder<List<dynamic>>(
                        future: item2,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error al cargar los datos');
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Column(
                          children: [
              
                            SizedBox(height: 10),
                            Center(
                              child: Text(
                                'No hay solicitudes de viajes',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Color.fromRGBO(158, 158, 158, 1),
                            ),
                          ],
                        );
                          } else {
                            return Column(
                              children: List.generate(snapshot.data!.length, (index) {
                                Map<String, dynamic> tripData = snapshot.data![index];
                                return buildTripCard(tripData);
                              }),
                            );
                          }
                        },
                      ),
                
                    ],
                  ),
                ),
              )
              
          :Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: FutureBuilder<TripsList>(
                  future: item,
                  builder: (context, abc) {
                    if (abc.connectionState == ConnectionState.done) {
                      //validación si el arreglo viene vacío
                      if (abc.data?.trips.length == 0) {
                        return Column(
                          children: [
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Expanded(
                                child: Text('Total de viajes',
                                textAlign: TextAlign.center,
                                 style: TextStyle(
                                     color: Color.fromRGBO(40, 93, 169, 1),
                                     fontWeight: FontWeight.normal,
                                     fontSize: 20.0)),
                              ),
                            ),
          
                            SizedBox(height: 10),
                            Center(
                              child: Text(
                                'No tiene viajes asignados',
                            
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Color.fromRGBO(158, 158, 158, 1),
                            ),
                          ],
                        );
                        //validación si el arreglo contiene información
                      } else {
                        if (abc.connectionState == ConnectionState.done) {
                          //desplegar data dinámica con LisView builder
                          return Stack(
                            children: [
                              SizedBox(height: 5),
                             Positioned(
                              right: 0,
                              left: 0,
                               child: Text('Total de viajes',
                               textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(40, 93, 169, 1),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20.0)),
                             ),
                               Column(
                                children: [
                          SizedBox(height: 50),
                          abc.data?.trips.length==1?ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: abc.data?.trips.length,
                          itemBuilder: (context, index) {
                            return Column(
                          children: [
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
                                'Viaje: ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${abc.data?.trips[index].tripId}',
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
                                  "assets/icons/calendar2.svg",
                                  color: Color.fromRGBO(40, 93, 169, 1),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Fecha: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${abc.data?.trips[index].fecha}',
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
                                  "assets/icons/hora.svg",
                                  color: Color.fromRGBO(40, 93, 169, 1),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Hora: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${abc.data?.trips[index].horaEntrada}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
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
                                width: 15,
                                height: 15,
                                child: SvgPicture.asset(
                                  "assets/icons/motorista.svg",
                                  color: Color.fromRGBO(40, 93, 169, 1),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Motorista: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${abc.data?.trips[index].conductor}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
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
                                  "assets/icons/telefono_num.svg",
                                  color: Color.fromRGBO(40, 93, 169, 1),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Teléfono: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${abc.data?.trips[index].telefono}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
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
                                  "assets/icons/Casa.svg",
                                  color: Color.fromRGBO(40, 93, 169, 1),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Dirección: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${abc.data?.trips[index].direccion}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
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
                                    "assets/icons/warning.svg",
                                    color: Color.fromRGBO(40, 93, 169, 1),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Acceso autorizado: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    '${abc.data?.trips[index].neighborhoodReferencePoint}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Color.fromRGBO(196, 196, 196, 1),
                          ),
                            
                          SizedBox(height: 20),
                
                            //validación de mostrar si la condición está empty mostrar texto de necesita confirmación
                            if ('${abc.data?.trips[index].condition}' ==
                            'empty') ...{
                          Padding(
                            padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      child: SvgPicture.asset(
                                        "assets/icons/hora.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Hora de encuentro: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:16),
                                  child: Text(
                                    'Necesita confirmación para poder asignarle una hora de encuentro',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Color.fromRGBO(196, 196, 196, 1),
                          ),
                            
                          SizedBox(height: 20),
                          Row(
                            children: [   
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.black),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                     showGeneralDialog(
                                            barrierColor: Colors.black.withOpacity(0.5),
                                            transitionBuilder: (context, a1, a2, widget) {
                                              return Transform.scale(
                                                scale: a1.value,
                                                child: Opacity(
                                                  opacity: a1.value,
                                                  child: AlertDialog(
                                                    backgroundColor: Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(16.0),
                                                    ),
                                                    content: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(16.0),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: Color.fromRGBO(40, 93, 169, 1),
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(16.0),
                                                                topRight: Radius.circular(16.0),
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(20.0),
                                                              child: Text(
                                                                'Nos encantaría conocer tu razón por la cual no harás uso del transporte',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.normal,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(20.0),
                                                            child: TextField(
                                                              controller: message,
                                                              maxLines: null, // Permite que el texto se ajuste automáticamente a varias líneas
                                                              textAlignVertical: TextAlignVertical.top, // Alinea el texto al principio del TextField
                                                              decoration: InputDecoration(
                                                                labelText: 'Escriba aquí',
                                                                labelStyle: TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
                                                                border: OutlineInputBorder( // Establece un borde al TextField
                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 16),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              OutlinedButton(
                                                                style: OutlinedButton.styleFrom(
                                                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                                                  foregroundColor: Colors.white,
                                                                  side: BorderSide(color: Colors.black),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text(
                                                                  'Cancelar',
                                                                  style: TextStyle(color: Colors.black),
                                                                ),
                                                              ),
                
                                                              OutlinedButton(
                                                                style: OutlinedButton.styleFrom(
                                                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                                                  backgroundColor: Color.fromRGBO(40, 93, 169, 1),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  ChatApis().confirmOrCancel('RECHAZADO');
                                                                  fetchCancel(
                                                                    prefs.nombreUsuario,
                                                                    '${abc.data?.trips[index].tripId}',
                                                                    conditionC,
                                                                    message.text,
                                                                  );
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text(
                                                                  'Enviar',
                                                                  style: TextStyle(color: Colors.white),
                                                                ),
                                                              ),
                                                              
                                                            ],
                                                          ),
                                                          SizedBox(height: 12)
                                                        ],
                                                      ),
                                                    ),
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
                                            },
                                          );
                                  },
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    backgroundColor: Color.fromRGBO(40, 93, 169, 1),
                                  ),
                                  onPressed: () => {
                                    ChatApis().confirmOrCancel('CONFIRMADO'),
                                    fetchConfirm(
                                      prefs.nombreUsuario,
                                      '${abc.data?.trips[index].tripId}',
                                      condition,comment
                                    ),
                                  },
                                  child: Text(
                                    'Confirmar',
                                     style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          //validación de condition in canceled
                            },
                            if ('${abc.data?.trips[index].condition}' ==
                            'Canceled') ...{
                          if ('${abc.data?.trips[index].commentDriver}' ==
                              'No confirmó') ...{
                            ListTile(
                              contentPadding:
                                  EdgeInsets.fromLTRB(5, 5, 10, 0),
                              title: Text('Viaje cancelado: ',
                                  style: TextStyle(color: Colors.white)),
                              subtitle: Text('No confirmó a tiempo',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15.0)),
                              leading: Icon(Icons.timer,
                                  color: GradiantV1, size: 35),
                            ),
                          } else ...{
                            Padding(
                            padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  child: SvgPicture.asset(
                                    "assets/icons/hora.svg",
                                    color: Color.fromRGBO(40, 93, 169, 1),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    'Se ha notificado al motorista que usted no necesitará el transporte',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Color.fromRGBO(196, 196, 196, 1),
                          ),
                            
                          SizedBox(height: 20),
                          },
                          //validación de horaConductor in empty
                            },
                            if ('${abc.data?.trips[index].horaConductor}' ==
                            'empty') ...{
                          if ('${abc.data?.trips[index].condition}' ==
                              'Confirmed') ...{
                            Padding(
                            padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      child: SvgPicture.asset(
                                        "assets/icons/hora.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Hora de encuentro: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:16),
                                  child: Text(
                                    'Viaje confirmado, espere a que el motorista asigne la hora a la que pasará por usted',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Color.fromRGBO(196, 196, 196, 1),
                          ),
                            
                          SizedBox(height: 20),
                          },
                            },
                            if ('${abc.data?.trips[index].horaConductor}' !=
                            'empty') ...{
                          Padding(
                            padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  child: SvgPicture.asset(
                                    "assets/icons/hora.svg",
                                    color: Color.fromRGBO(40, 93, 169, 1),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Hora de encuentro: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                 '${abc.data?.trips[index].horaConductor}',
                                  style: TextStyle(
                                   fontSize: 14,
                                    color: Color.fromRGBO(40, 169, 83, 1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Color.fromRGBO(196, 196, 196, 1),
                          ),
                            
                          SizedBox(height: 20),
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
                                                      backgroundColor: Colors.transparent,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(16.0),
                                                      ),
                                                      content: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(16.0),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                color: Color.fromRGBO(40, 93, 169, 1),
                                                                borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(16.0),
                                                                  topRight: Radius.circular(16.0),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(20.0),
                                                                child: Text(
                                                                  'Nos encantaría conocer tu razón por la cual no harás uso del transporte',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.normal,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(20.0),
                                                              child: TextField(
                                                                controller: message,
                                                                maxLines: null, // Permite que el texto se ajuste automáticamente a varias líneas
                                                                textAlignVertical: TextAlignVertical.top, // Alinea el texto al principio del TextField
                                                                decoration: InputDecoration(
                                                                  labelText: 'Escriba aquí',
                                                                  labelStyle: TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
                                                                  border: OutlineInputBorder( // Establece un borde al TextField
                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 16),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                OutlinedButton(
                                                                  style: OutlinedButton.styleFrom(
                                                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                                                    foregroundColor: Colors.white,
                                                                    side: BorderSide(color: Colors.black),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(12.0),
                                                                    ),
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Text(
                                                                    'Cancelar',
                                                                    style: TextStyle(color: Colors.black),
                                                                  ),
                                                                ),
                            
                                                                OutlinedButton(
                                                                  style: OutlinedButton.styleFrom(
                                                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                                                    backgroundColor: Color.fromRGBO(40, 93, 169, 1),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(12.0),
                                                                    ),
                                                                  ),
                                                                  onPressed: () {
                                                                    ChatApis().confirmOrCancel('RECHAZADO');
                                                                    fetchCancel(
                                                                      prefs.nombreUsuario,
                                                                      '${abc.data?.trips[index].tripId}',
                                                                      conditionC,
                                                                      message.text,
                                                                    );
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Text(
                                                                    'Enviar',
                                                                    style: TextStyle(color: Colors.white),
                                                                  ),
                                                                ),
                                                                
                                                              ],
                                                            ),
                                                            SizedBox(height: 12)
                                                          ],
                                                        ),
                                                      ),
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
                              Padding(
                            padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                  width: 18,
                                  height: 18,
                                  child: SvgPicture.asset(
                                    "assets/icons/cronometro.svg",
                                    color: Color.fromRGBO(40, 93, 169, 1),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Viaje: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:16),
                                  child: Text(
                                    'Su tiempo para cancelar el viaje ha expirado',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                            }
                          }
                            } else
                          ...{},
                          ],
                            );
                          }):
                            ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: abc.data?.trips.length,
                          itemBuilder: (context, index) {
                            return Padding(
                          padding: const EdgeInsets.only(top:10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0), // Establece un radio de esquinas redondeadas de 8.0
                              border: Border.all(color: Color.fromRGBO(196, 196, 196, 1)), // Establece el color del borde
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 2, left: 2),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.only(right: 5, left: 10),
                                title: Column(
                                  children: [
                                    SizedBox(height: 8),
                                    Row(
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
                                          'Viaje: ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${abc.data?.trips[index].tripId}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/calendar2.svg",
                                            color: Color.fromRGBO(40, 93, 169, 1),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Fecha: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${abc.data?.trips[index].fecha}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                children: [
                              Container(
                                height: 1,
                                color: Color.fromRGBO(196, 196, 196, 1),
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
                                        "assets/icons/hora.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Hora: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${abc.data?.trips[index].horaEntrada}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Color.fromRGBO(196, 196, 196, 1),
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
                                        "assets/icons/motorista.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Motorista: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${abc.data?.trips[index].conductor}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Color.fromRGBO(196, 196, 196, 1),
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
                                        "assets/icons/telefono_num.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Teléfono: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${abc.data?.trips[index].telefono}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Color.fromRGBO(196, 196, 196, 1),
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
                                        "assets/icons/Casa.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Dirección: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${abc.data?.trips[index].direccion}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Color.fromRGBO(196, 196, 196, 1),
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
                                          "assets/icons/warning.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Acceso autorizado: ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          '${abc.data?.trips[index].neighborhoodReferencePoint}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
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
                              
                              //validación de mostrar si la condición está empty mostrar texto de necesita confirmación
                              if ('${abc.data?.trips[index].condition}' ==
                                  'empty') ...{
                                Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 18,
                                            height: 18,
                                            child: SvgPicture.asset(
                                              "assets/icons/hora.svg",
                                              color: Color.fromRGBO(40, 93, 169, 1),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'Hora de encuentro: ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:16),
                                        child: Text(
                                          'Necesita confirmación para poder asignarle una hora de encuentro',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                            fontWeight: FontWeight.normal,
                                          ),
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
                                Row(
                                  children: [   
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(color: Colors.black),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        onPressed: () {
                                           showGeneralDialog(
                                                  barrierColor: Colors.black.withOpacity(0.5),
                                                  transitionBuilder: (context, a1, a2, widget) {
                                                    return Transform.scale(
                                                      scale: a1.value,
                                                      child: Opacity(
                                                        opacity: a1.value,
                                                        child: AlertDialog(
                                                          backgroundColor: Colors.transparent,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(16.0),
                                                          ),
                                                          content: Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(16.0),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Color.fromRGBO(40, 93, 169, 1),
                                                                    borderRadius: BorderRadius.only(
                                                                      topLeft: Radius.circular(16.0),
                                                                      topRight: Radius.circular(16.0),
                                                                    ),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(20.0),
                                                                    child: Text(
                                                                      'Nos encantaría conocer tu razón por la cual no harás uso del transporte',
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(20.0),
                                                                  child: TextField(
                                                                    controller: message,
                                                                    maxLines: null, // Permite que el texto se ajuste automáticamente a varias líneas
                                                                    textAlignVertical: TextAlignVertical.top, // Alinea el texto al principio del TextField
                                                                    decoration: InputDecoration(
                                                                      labelText: 'Escriba aquí',
                                                                      labelStyle: TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
                                                                      border: OutlineInputBorder( // Establece un borde al TextField
                                                                        borderRadius: BorderRadius.circular(12.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(height: 16),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    OutlinedButton(
                                                                      style: OutlinedButton.styleFrom(
                                                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                                                        foregroundColor: Colors.white,
                                                                        side: BorderSide(color: Colors.black),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(12.0),
                                                                        ),
                                                                      ),
                                                                      onPressed: () {
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: Text(
                                                                        'Cancelar',
                                                                        style: TextStyle(color: Colors.black),
                                                                      ),
                                                                    ),
                              
                                                                    OutlinedButton(
                                                                      style: OutlinedButton.styleFrom(
                                                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                                                        backgroundColor: Color.fromRGBO(40, 93, 169, 1),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(12.0),
                                                                        ),
                                                                      ),
                                                                      onPressed: () {
                                                                        ChatApis().confirmOrCancel('RECHAZADO');
                                                                        fetchCancel(
                                                                          prefs.nombreUsuario,
                                                                          '${abc.data?.trips[index].tripId}',
                                                                          conditionC,
                                                                          message.text,
                                                                        );
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: Text(
                                                                        'Enviar',
                                                                        style: TextStyle(color: Colors.white),
                                                                      ),
                                                                    ),
                                                                    
                                                                  ],
                                                                ),
                                                                SizedBox(height: 12)
                                                              ],
                                                            ),
                                                          ),
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
                                                  },
                                                );
                                        },
                                        child: Text(
                                          'Cancelar',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                              
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          backgroundColor: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                        onPressed: () => {
                                          ChatApis().confirmOrCancel('CONFIRMADO'),
                                          fetchConfirm(
                                            prefs.nombreUsuario,
                                            '${abc.data?.trips[index].tripId}',
                                            condition,comment
                                          ),
                                        },
                                        child: Text(
                                          'Confirmar',
                                           style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                              
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                //validación de condition in canceled
                              },
                              if ('${abc.data?.trips[index].condition}' ==
                                  'Canceled') ...{
                                if ('${abc.data?.trips[index].commentDriver}' ==
                                    'No confirmó') ...{
                                  ListTile(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5, 5, 10, 0),
                                    title: Text('Viaje cancelado: ',
                                        style: TextStyle(color: Colors.white)),
                                    subtitle: Text('No confirmó a tiempo',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15.0)),
                                    leading: Icon(Icons.timer,
                                        color: GradiantV1, size: 35),
                                  ),
                                } else ...{
                                  Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/hora.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          'Se ha notificado al motorista que usted no necesitará el transporte',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500,
                                          ),
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
                                //validación de horaConductor in empty
                              },
                              if ('${abc.data?.trips[index].horaConductor}' ==
                                  'empty') ...{
                                if ('${abc.data?.trips[index].condition}' ==
                                    'Confirmed') ...{
                                  Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 18,
                                            height: 18,
                                            child: SvgPicture.asset(
                                              "assets/icons/hora.svg",
                                              color: Color.fromRGBO(40, 93, 169, 1),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'Hora de encuentro: ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:16),
                                        child: Text(
                                          'Viaje confirmado, espere a que el motorista asigne la hora a la que pasará por usted',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.green,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Color.fromRGBO(196, 196, 196, 1),
                                ),
                                  
                                SizedBox(height: 20),
                                },
                              },
                              if ('${abc.data?.trips[index].horaConductor}' !=
                                  'empty') ...{
                                Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/hora.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Hora de encuentro: ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                       '${abc.data?.trips[index].horaConductor}',
                                        style: TextStyle(
                                         fontSize: 14,
                                          color: Color.fromRGBO(40, 169, 83, 1),
                                          fontWeight: FontWeight.w500,
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
                                                          backgroundColor: Colors.transparent,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(16.0),
                                                          ),
                                                          content: Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(16.0),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Color.fromRGBO(40, 93, 169, 1),
                                                                    borderRadius: BorderRadius.only(
                                                                      topLeft: Radius.circular(16.0),
                                                                      topRight: Radius.circular(16.0),
                                                                    ),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(20.0),
                                                                    child: Text(
                                                                      'Nos encantaría conocer tu razón por la cual no harás uso del transporte',
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(20.0),
                                                                  child: TextField(
                                                                    controller: message,
                                                                    maxLines: null, // Permite que el texto se ajuste automáticamente a varias líneas
                                                                    textAlignVertical: TextAlignVertical.top, // Alinea el texto al principio del TextField
                                                                    decoration: InputDecoration(
                                                                      labelText: 'Escriba aquí',
                                                                      labelStyle: TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
                                                                      border: OutlineInputBorder( // Establece un borde al TextField
                                                                        borderRadius: BorderRadius.circular(12.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(height: 16),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    OutlinedButton(
                                                                      style: OutlinedButton.styleFrom(
                                                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                                                        foregroundColor: Colors.white,
                                                                        side: BorderSide(color: Colors.black),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(12.0),
                                                                        ),
                                                                      ),
                                                                      onPressed: () {
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: Text(
                                                                        'Cancelar',
                                                                        style: TextStyle(color: Colors.black),
                                                                      ),
                                                                    ),
                              
                                                                    OutlinedButton(
                                                                      style: OutlinedButton.styleFrom(
                                                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                                                        backgroundColor: Color.fromRGBO(40, 93, 169, 1),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(12.0),
                                                                        ),
                                                                      ),
                                                                      onPressed: () {
                                                                        ChatApis().confirmOrCancel('RECHAZADO');
                                                                        fetchCancel(
                                                                          prefs.nombreUsuario,
                                                                          '${abc.data?.trips[index].tripId}',
                                                                          conditionC,
                                                                          message.text,
                                                                        );
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: Text(
                                                                        'Enviar',
                                                                        style: TextStyle(color: Colors.white),
                                                                      ),
                                                                    ),
                                                                    
                                                                  ],
                                                                ),
                                                                SizedBox(height: 12)
                                                              ],
                                                            ),
                                                          ),
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
                                    Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/cronometro.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Viaje: ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:16),
                                        child: Text(
                                          'Su tiempo para cancelar el viaje ha expirado',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                  }
                                }
                              } else
                                ...{},
                                
                                SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                            );
                          }),
                                ],
                               )
                            ],
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }
                    } else {
                      return ColorLoader3();
                    }
                    //return SizedBox();
                  },
                ),
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTripCard(Map<String, dynamic> tripData) {
  return Padding(
    padding: const EdgeInsets.only(bottom:10),
    child: Card(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(158, 158, 158, 1),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        child: SvgPicture.asset(
                          "assets/icons/calendar-note-svgrepo-com.svg",
                          color: Color.fromRGBO(40, 93, 169, 1),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Fecha: ${tripData["dateToTravel"]}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Color.fromRGBO(158, 158, 158, 1),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        child: SvgPicture.asset(
                          "assets/icons/advertencia.svg",
                          color: Color.fromRGBO(40, 93, 169, 1),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Transporte para: ${tripData["tripType"]}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Color.fromRGBO(158, 158, 158, 1),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        child: SvgPicture.asset(
                          "assets/icons/hora.svg",
                          color: Color.fromRGBO(40, 93, 169, 1),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text.rich(
                        TextSpan(
                          text: 'Hora: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 15.0,
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: '${tripData["hour"]}',
                              style: TextStyle(
                                color: Color.fromRGBO(40, 169, 83, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Color.fromRGBO(158, 158, 158, 1),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        child: SvgPicture.asset(
                          "assets/icons/Casa.svg",
                          color: Color.fromRGBO(40, 93, 169, 1),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Dirección: ${tripData["agentAddress"]}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Color.fromRGBO(158, 158, 158, 1),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        child: SvgPicture.asset(
                          "assets/icons/warning.svg",
                          color: Color.fromRGBO(40, 93, 169, 1),
                        ),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          'Acceso autorizado: ${tripData["authorizedAccess"]}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Color.fromRGBO(158, 158, 158, 1),
              ),
              SizedBox(height: 10),
              if (tripData["confirmation"] == true)
                Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                         child: SvgPicture.asset(
                          "assets/icons/advertencia.svg",
                          color: Color.fromRGBO(40, 93, 169, 1),
                        ),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          '¡Solicitud confirmada! Te notificaremos cuando tengas el viaje programado',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.normal,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
              if (tripData["confirmation"] == false)
                Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                         child: SvgPicture.asset(
                          "assets/icons/advertencia.svg",
                          color: Color.fromRGBO(40, 93, 169, 1),
                        ),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          'Solicitud cancelada con éxito',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.normal,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
              if (tripData["confirmation"] != true && tripData["confirmation"] != false)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String comment = '';
                      
                            return AlertDialog(
                              backgroundColor: backgroundColor,
                              title: Text('Nos encantaría conocer tu razón', style: TextStyle(color: Colors.white)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    maxLines: null,
                                    onChanged: (value) {
                                      comment = value;
                                    },
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Ingresa tu comentario aquí',
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                      ),
                                      // Otros atributos de decoración
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cerrar', style: TextStyle(color: Colors.white)),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (comment.isEmpty) {
                                      Navigator.of(context).pop();
                                      QuickAlert.show(
                                        context: context,
                                        title: "Comentario Requerido",
                                        text: "Debes ingresar un comentario antes de enviar",
                                        type: QuickAlertType.error
                                      );          
                                    } else {
                                      
                                      LoadingIndicatorDialog().show(context);
                                      Map data = {
                                        "agentForTravelId": tripData["agentForTravelId"].toString(),
                                        "confirmation": "0",
                                        "agentComment": comment
                                      };
                                      print(data);
                                      http.Response response = await http.post(Uri.parse('https://admin.smtdriver.com/confirmTransportation'), body: data);
                                      print(response.body);
                      
                                      var dataR = json.decode(response.body);

                                      
                                      if (dataR["ok"] == true) {
                                          LoadingIndicatorDialog().dismiss();    
                                          Navigator.of(context).pop();   
                                          QuickAlert.show(
                                            context: context,
                                            title: "Enviado",
                                            text: dataR["message"],
                                            type: QuickAlertType.success,
                                          );
                                        setState(() {
                                          item2=getSolicitudes();
                                        });
                                      } else {
                                        LoadingIndicatorDialog().dismiss();
                                        Navigator.of(context).pop();
                                        QuickAlert.show(
                                          context: context,
                                          title: "Error",
                                          text: dataR["message"],
                                          type: QuickAlertType.error,
                                        );
                                      }
                                      
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  child: Text('Enviar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8, right: 20, left: 20),
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 30),
                    InkWell(
                      onTap: () async{

                        LoadingIndicatorDialog().show(context);
                                                
                                                Map data = {
                                                  "agentForTravelId":tripData["agentForTravelId"].toString(), 
                                                  "confirmation": "1",
                                                  "agentComment": "null"
                                                  };
                                  
                                                  http.Response response = await http.post(Uri.parse('https://admin.smtdriver.com/confirmTransportation'), body: data);
                                                  print(response.body);
                                  
                                                  var dataR = json.decode(response.body);
                                  
                                                  if(dataR["ok"]==true){
                                                    setState(() {
                                                      item2=getSolicitudes();
                                                    });
                                                    LoadingIndicatorDialog().dismiss();
                                                    QuickAlert.show(
                                                      context: context,
                                                      title: "Enviado",
                                                      text: dataR["message"],
                                                      type: QuickAlertType.success
                                                    );
                                                  }else{
                                                    LoadingIndicatorDialog().dismiss();
                                                    QuickAlert.show(
                                                      context: context,
                                                      title: "Error",
                                                      text: dataR["message"],
                                                      type: QuickAlertType.error
                                                    );
                                                  }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color.fromRGBO(40, 93, 169, 1)),
                          color: Color.fromRGBO(40, 93, 169, 1)
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8, right: 22, left: 20),
                          child: Text(
                            'Sí',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                  
                  ],
                ),
            ],
          ),
        ),
      ),
    ),
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

  void onChanged4(double value) async {
    setState(() {
      rating4 = value;
    });
  }

  void onChanged5(double value) async {
    setState(() {
      rating5 = value;
    });
  }

  void onChanged6(double value) async {
    setState(() {
      rating6 = value;
    });
  }

  //mostrar y validación rating
  void _showRatingAlert() async {
    http.Response responses = await http
        .get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final resp = DataAgent.fromJson(json.decode(responses.body));
    // Map dat = {
    //   "agentId": resp.agentId.toString()
    // };
    http.Response responsex = await http.get(Uri.parse('$ip/api/ratingTrip/${resp.agentId}'));
    //http.Response response = await http.post(Uri.parse('https://admin.smtdriver.com/searchRating'),body:  dat);
    if (responsex.body.isNotEmpty) {      
      var getData = json.decode(responsex.body);
      //print(getData['tripId']);
      if (getData['tripId'] != 0 && responsex.body.isNotEmpty) {
        showAlertDialogRatingOld();       
      }
    }
    //final resp1 = Rating.fromJson(json.decode(responsex.body));
    //print(getData[0]);
    
    // if (response.body.isNotEmpty && getData[0]['tripId'].toString()!='0') {
    //   //validación para mostrar alerta
    //   // if (mounted) {        
    //   // }
    //     //showAlertDialogRating(resp, getData[0]['tripId'].toString(), getData[0]['driverFullname'].toString());
    // }
  }


//creación de alerta
  showAlertDialogRating(dynamic data, String tripId, String nameDriver) async {
    
    showGeneralDialog(

        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          //final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform.scale(scale: a1.value, child: encuestaP1(data, context, widget, tripId, nameDriver));
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return widget;
        }
    );
  }

  //creación de alerta
  showAlertDialogRatingOld()async{
    //llamado de apis directamente
    http.Response responses = await http.get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final resp = DataAgent.fromJson(json.decode(responses.body));
    http.Response response = await http.get(Uri.parse('$ip/api/ratingTrip/${resp.agentId}'));
    final resp1 = Rating.fromJson(json.decode(response.body));
    showGeneralDialog(barrierColor: Colors.black.withOpacity(0.5),transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
      return Transform(transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
        child: Opacity(opacity: a1.value,
          child: AlertDialog(shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
            backgroundColor: backgroundColor,
            title: Center(child: Text('😄 ¿Cómo calificaría su último viaje con\n${resp1.driverFullname}? 😁 ', style: TextStyle(color: Colors.white),)), 
            content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Container(height: 300,width: 500,
              color: backgroundColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //creación reacciones para conducción
                      Divider(),
                      SizedBox(height: 10.0),
                      Text('Conducción', style: TextStyle(color: Colors.white),),
                      SizedBox(height: 5.0),
                      RatingBar.builder(initialRating: 0,itemCount: 5,
                        itemBuilder: (context, index) {
                          switch (index) {
                              case 0:
                                return Icon(Icons.sentiment_very_dissatisfied,color: Colors.red);
                              case 1:
                                return Icon(Icons.sentiment_dissatisfied,color: Colors.redAccent);
                              case 2:
                                return Icon(Icons.sentiment_neutral,color: Colors.amber);
                              case 3:
                                return Icon(Icons.sentiment_satisfied,color: Colors.lightGreen);
                              case 4:
                                return Icon(Icons.sentiment_very_satisfied,color: Colors.green);
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
                      Text('Amabilidad del motorista', style: TextStyle(color: Colors.white),),
                      SizedBox(height: 5.0),
                      RatingBar.builder(initialRating: 0,itemCount: 5,
                        itemBuilder: (context, index) {
                          switch (index) {
                              case 0:
                                return Icon(Icons.sentiment_very_dissatisfied,color: Colors.red);
                              case 1:
                                return Icon(Icons.sentiment_dissatisfied,color: Colors.redAccent);
                              case 2:
                                return Icon(Icons.sentiment_neutral,color: Colors.amber);
                              case 3:
                                return Icon(Icons.sentiment_satisfied,color: Colors.lightGreen,);
                              case 4:
                                return Icon(Icons.sentiment_very_satisfied,color: Colors.green);
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
                      Text('Condiciones del vehículo', style: TextStyle(color: Colors.white),),
                      SizedBox(height: 5.0),
                      RatingBar.builder(initialRating: 0,itemCount: 5,
                        itemBuilder: (context, index) {
                          switch (index) {
                              case 0:
                                return Icon(Icons.sentiment_very_dissatisfied,color: Colors.red);
                              case 1:
                                return Icon(Icons.sentiment_dissatisfied,color: Colors.redAccent);
                              case 2:
                                return Icon(Icons.sentiment_neutral,color: Colors.amber);
                              case 3:
                                return Icon(Icons.sentiment_satisfied,color: Colors.lightGreen);
                              case 4:
                                return Icon(Icons.sentiment_very_satisfied,color: Colors.green);
                          }
                          return SizedBox();
                        },                              
                        onRatingUpdate: (rating3) {
                          onChanged3(rating3);                          
                        },
                      ),
                    ]
                          ),
                ),
              );
            }
            ),                  
            actions:<Widget> [    
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //SizedBox(width: 15.0), 
                  ButtonTheme(minWidth: 60.0,child: TextButton(style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: secondColor),
                    onPressed: () => {
                      //fetch skip Rating
                      fetchSkipRating2(resp.agentId.toString(), resp1.tripId.toString(), rating1.toInt(), rating2.toInt(), rating3.toInt(), message.text),
                      Navigator.pop(context),                              
                    },
                    child: Text('Omitir'),                              
                  )),  
                  //SizedBox(width: 5.0),                                   
                  ButtonTheme(minWidth: 60.0,child: TextButton(style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: kgray),
                    onPressed: () => {
                      Navigator.pop(context),
                    },
                    child: Text('Ahora no'),                              
                  )),
                  //SizedBox(width: 5.0),                                   
                  ButtonTheme(minWidth: 60.0,child: TextButton(style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: GradiantV1),
                    onPressed: () => {
                      Navigator.pop(context),
                      showGeneralDialog(barrierColor: Colors.black.withOpacity(0.5),
                          transitionBuilder: (context, a1, a2, widget) {
                            return Transform.scale(scale: a1.value,
                              child: Opacity(opacity: a1.value,
                                child: AlertDialog(
                                  backgroundColor: backgroundColor,
                                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                                  title: Center(
                                    child: Text('Estamos evaluando a nuestros \nmotoristas, para esto es \nmuy importante su comentario.',textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
                                  content: TextField(controller: message,decoration: InputDecoration(labelText: 'Escriba aquí')),
                                  actions: [
                                    //SizedBox(width: 60.0),
                                    Center(
                                      child: TextButton(style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: GradiantV1),
                                        onPressed: () => {
                                          //fetch skip rating
                                          fetchSkipRating2(resp.agentId.toString(), resp1.tripId.toString(), rating1.toInt(), rating2.toInt(), rating3.toInt(), message.text),
                                          Navigator.pop(context),
                                        },
                                        child: Text('Enviar'),                                                  
                                      ),
                                    ),
                                    //SizedBox(width: 70.0),
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
                        return Text('');}),
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
      return Text('');});      
  }

  AlertDialog encuestaP3(DataAgent resp, BuildContext context, Widget widget, String tripId, String driverFullname) {
    return AlertDialog(
          //scrollable: true,
          backgroundColor: backgroundColor,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0)),
          title: Center(
              child: Text(
            '😄 ¿Cómo calificaría su último viaje con $driverFullname? 😁 ',
            style: TextStyle(color: Colors.white),
          )),
          content: SizedBox(
            height: 900,
            child: SingleChildScrollView(
              child: Column(
                children: [
                 SizedBox(height: 10.0),
                  //creación reacciones para condiciones
                  Text('4. El motorista actual de su viaje cumple puntual con la llegadas a las instalaciones de su empresa.',style: TextStyle(color: Colors.white)),
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
                    onRatingUpdate: (rating4) {
                      onChanged4(rating4);
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    controller: comentario4,
                    decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(96, 0, 0, 0),
              hintStyle: TextStyle(color: Colors.white),
              contentPadding: EdgeInsets.all(1),
              hintText: 'Escriba un comentario...',
              border: InputBorder.none,
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 10.0),
                  //creación reacciones para condiciones
                  Text('5. En caso de tener entrada, el motorista actual de su viaje, pasa a la hora acordada en la plataforma.',style: TextStyle(color: Colors.white)),
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
                    onRatingUpdate: (rating5) {
                      onChanged5(rating5);
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    controller: comentario5,
                    decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(96, 0, 0, 0),
              hintStyle: TextStyle(color: Colors.white),
              contentPadding: EdgeInsets.all(1),
              hintText: 'Escriba un comentario...',
              border: InputBorder.none,
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 10.0),
                  //creación reacciones para condiciones
                  Text('6. ¿Considera que la unidad actual de su viaje, está en buenas condiciones y limpia ?',style: TextStyle(color: Colors.white)),
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
                    onRatingUpdate: (rating6) {
                      onChanged6(rating6);
                    },
                ),
                SizedBox(height: 10.0),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: comentario6,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(96, 0, 0, 0),
                    hintStyle: TextStyle(color: Colors.white),
                    contentPadding: EdgeInsets.all(1),
                    hintText: 'Escriba un comentario...',
                    border: InputBorder.none,
                  ),
                  maxLines: 5,
                ),
                ],
              ),
            ),
          ),
          actions: <Widget>[  
            botones(resp, context, widget, tripId),
            SizedBox(width: 15.0),
          ],
        );
  }

  AlertDialog encuestaP2(DataAgent resp, BuildContext context, Widget widget, String tripId, String driverFullname) {
    
    return AlertDialog(
          //scrollable: true,
          backgroundColor: backgroundColor,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0)),
          title: Center(
              child: Text(
            '😄 ¿Cómo calificaría su último viaje con $driverFullname? 😁 ',
            style: TextStyle(color: Colors.white),
          )),
          content: SizedBox(
            height: 900,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  Text('Califica en la escala del 1 al 5 , siendo 1 muy malo y 5 excelente\n',style: TextStyle(color: Colors.white)),
                  Text('1. ¿Cual es el nivel de satisfacción con el trato recibido por el motorista que brinda tu transporte actualmente?',style: TextStyle(color: Colors.white)),
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
                  SizedBox(height: 10.0),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    controller: comentario1,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(96, 0, 0, 0),
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding: EdgeInsets.all(1),
                      hintText: 'Escriba un comentario...',
                      border: InputBorder.none,
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 10.0),
                //creación reacciones para amabilidad
                Text('2.¿El motorista que te brinda tu transporte está siempre atento y no utiliza el celular al conducir?',style: TextStyle(color: Colors.white)),
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
                SizedBox(height: 10.0),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    controller: comentario2,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(96, 0, 0, 0),
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding: EdgeInsets.all(1),
                      hintText: 'Escriba un comentario...',
                      border: InputBorder.none,
                    ),
                    maxLines: 5,
                  ),
                SizedBox(height: 10.0),
                  //creación reacciones para condiciones
                  Text('3. El motorista que brinda tu transporte, es prudente en el manejo de la unidad y cuidadoso con los tumulos y agujeros de la calles durante su recorrido.',style: TextStyle(color: Colors.white)),
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
                  SizedBox(height: 10.0),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    controller: comentario3,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(96, 0, 0, 0),
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding: EdgeInsets.all(1),
                      hintText: 'Escriba un comentario...',
                      border: InputBorder.none,
                    ),
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
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
                      QuickAlert.show(
                        context: context,
                        title: "Está seguro que desea omitir la encuesta?",          
                        type: QuickAlertType.success,
                        confirmBtnText: 'Confirmar',
                        cancelBtnText: 'Cancelar',
                        showCancelBtn: true,  
                        confirmBtnTextStyle: TextStyle(fontSize: 15, color: Colors.white),
                        cancelBtnTextStyle:TextStyle(color: Colors.red, fontSize: 15, fontWeight:FontWeight.bold ), 
                        onConfirmBtnTap:() {
                          fetchSkipRating(resp.agentId.toString(),'',0,0,0,0,0,0,'','','','','','',true);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        onCancelBtnTap: (() {
                          Navigator.pop(context);
                        })
                      ),
                        
                    },
                  child: Text('Omitir'),
                  )
                ),
                ButtonTheme(
                  minWidth: 60.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: kgray),
                    onPressed: () => {                           
                      if(rating1 != 0 && rating2 !=0 && rating3 != 0)...{
                      Navigator.pop(context),
                      showGeneralDialog(
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionBuilder: (context, a1, a2, widget) {
                          return Transform.scale(
                            scale: a1.value,
                            child: Opacity(
                              opacity: a1.value,
                              child: Transform.scale(scale: a1.value, child: encuestaP3(resp, context, widget, tripId, driverFullname)),
                            ),
                          );
                        },
                        transitionDuration: Duration(milliseconds: 220),
                        barrierDismissible: false,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation1, animation2) {
                          return widget;
                        }
                      )                      
                      }else...{
                        if(rating1== 0){
                          QuickAlert.show(
                            context: context,
                            title: 'Pendiente',
                            confirmBtnText: "Aceptar",
                            text: 'Hace falta que califique la pregunta $rating11, los comentarios son opcionales.',
                            type: QuickAlertType.info
                          ),
                        }else if(rating2== 0){
                          QuickAlert.show(
                            context: context,
                            title: 'Pendiente',
                            confirmBtnText: "Aceptar",
                            text: 'Hace falta que califique la pregunta $rating22, los comentarios son opcionales.',
                            type: QuickAlertType.info
                          ),
                        }else if(rating3== 0){
                          QuickAlert.show(
                            context: context,
                            title: 'Pendiente',
                            confirmBtnText: "Aceptar",
                            text: 'Hace falta que califique la pregunta $rating33, los comentarios son opcionales.',
                            type: QuickAlertType.info
                          ),
                        }                     
                      }

                    },
                  child: Text('Siguiente'),
                  )
                ),
              ],
            ),
            SizedBox(width: 15.0),
          ],
        );
  }

  AlertDialog encuestaP1(DataAgent resp, BuildContext context, Widget widget, String tripId, String driverFullname) {
    return AlertDialog(
      //scrollable: true,
      backgroundColor: backgroundColor,
      shape: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0)),
      title: Center(
        child: Text(
          '😄 ¡Responde y gana por calificarnos! 😁',
          style: TextStyle(color: Colors.white, fontSize: 22),
        )
      ),
      content: SizedBox(
        height: 500,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.0),
              Text(
                textAlign: TextAlign.justify,
                'Gracias por viajar con nosotros, queremos seguir mejorando y tu opinion es muy importante. Le agradeceremos unos minutos para compartirnos tu experiencia con la siguiente encuesta.\n\nSi calificas cada uno de los puntos durante todos tus viajes cuando utilizas el transporte durante 5 días seguidos, estarás participando en un sorteo por cualquiera de los regalos 🎁 que te mostraremos en el siguiente enlance: ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ) 
              ),
        
              SizedBox(height: 10.0),
              ButtonTheme(
                    minWidth: 60.0,
                    child: TextButton(
                      style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(157, 0, 247, 255)),
                      onPressed: () => launchUrl(Uri.parse('https://giveaway.smtdriver.com/')),
                    child: Text(
                      'Ver Premios 🎁', 
                      style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                      ) 
                    ),
                    )
                  ),
        
              SizedBox(height: 10.0),
        
              Text(
                textAlign: TextAlign.justify,
                'Toda información que brindes es totalmente confidencial.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ) 
              ),
            ],
          ),
        ),
      ),
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
                      QuickAlert.show(
                        context: context,
                        title: "Está seguro que desea omitir la encuesta?",          
                        type: QuickAlertType.success,
                        confirmBtnText: 'Confirmar',
                        cancelBtnText: 'Cancelar',
                        showCancelBtn: true,  
                        confirmBtnTextStyle: TextStyle(fontSize: 15, color: Colors.white),
                        cancelBtnTextStyle:TextStyle(color: Colors.red, fontSize: 15, fontWeight:FontWeight.bold ), 
                        onConfirmBtnTap:() {
                          fetchSkipRating(resp.agentId.toString(),'',0,0,0,0,0,0,'','','','','','',true);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        onCancelBtnTap: (() {
                          Navigator.pop(context);
                        })
                      ),
                    },
                  child: Text('Omitir'),
                  )
                ),
                ButtonTheme(
                  minWidth: 60.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: kgray),
                    onPressed: () => {
                      Navigator.pop(context),
                      showGeneralDialog(
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionBuilder: (context, a1, a2, widget) {
                            return Transform.scale(
                              scale: a1.value,
                              child: Opacity(
                                opacity: a1.value,
                                child: Transform.scale(scale: a1.value, child: encuestaP2(resp, context, widget, tripId, driverFullname)),
                              ),
                            );
                          },
                          transitionDuration: Duration(milliseconds: 220),
                          barrierDismissible: false,
                          barrierLabel: '',
                          context: context,
                          pageBuilder: (context, animation1, animation2) {
                            return widget;
                          })
                    },
                  child: Text('Siguiente'),
                  )
                ),
              ],
            ),
        SizedBox(width: 15.0),
      ],
    );
  }

  Row botones(DataAgent resp, BuildContext context, Widget widget, String tripId) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonTheme(
                    minWidth: 60.0,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: secondColor),
                      onPressed: () => {
                        QuickAlert.show(
                          context: context,
                          title: "Está seguro que desea omitir la encuesta?",          
                          type: QuickAlertType.success,
                          confirmBtnText: 'Confirmar',
                          cancelBtnText: 'Cancelar',
                          showCancelBtn: true,  
                          confirmBtnTextStyle: TextStyle(fontSize: 15, color: Colors.white),
                          cancelBtnTextStyle:TextStyle(color: Colors.red, fontSize: 15, fontWeight:FontWeight.bold ), 
                          onConfirmBtnTap:() {
                            fetchSkipRating(resp.agentId.toString(),'',0,0,0,0,0,0,'','','','','','',true);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          onCancelBtnTap: (() {
                            Navigator.pop(context);
                          })
                        ),
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
                      if(rating1 != 0 && rating2 !=0 && rating3 != 0 && rating4 != 0&& rating5 != 0 &&rating6 != 0)...{
                        Navigator.pop(context),
                        fetchSkipRating(resp.agentId.toString(),tripId,rating1.toInt(),rating2.toInt(),rating3.toInt(),rating4.toInt(),rating5.toInt(),rating6.toInt(),comentario1.text,comentario2.text,comentario3.text,comentario4.text,comentario5.text,comentario6.text,false),
                      }else...{
                        if(rating4== 0){
                          QuickAlert.show(
                            context: context,
                            title: 'Pendiente',
                            confirmBtnText: "Aceptar",
                            text: 'Hace falta que califique la pregunta $rating44, los comentarios son opcionales.',
                            type: QuickAlertType.info
                          ),
                        }else if(rating5== 0){
                          QuickAlert.show(
                            context: context,
                            title: 'Pendiente',
                            confirmBtnText: "Aceptar",
                            text: 'Hace falta que califique la pregunta $rating55, los comentarios son opcionales.',
                            type: QuickAlertType.info
                          ),
                        }else if(rating6== 0){
                          QuickAlert.show(
                            context: context,
                            title: 'Pendiente',
                            confirmBtnText: "Aceptar",
                            text: 'Hace falta que califique la pregunta $rating66, los comentarios son opcionales.',
                            type: QuickAlertType.info
                          ),
                        }  
                      },
                      
                    },
                    child: Text('Enviar'),
                  ),
                ),
              ],
            );
  }

}