import 'package:back_button_interceptor/back_button_interceptor.dart';
//import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_auth/Agents/Screens/Chat/chatapis.dart';
import 'package:flutter_auth/Agents/Screens/Chat/socketChat.dart';
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
import 'package:flutter_auth/main.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:quickalert/quickalert.dart';
//import 'package:sweetalert/sweetalert.dart';

import '../../../../components/ConfirmationDialog.dart';
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
  var mensajeAlerta;
  final prefs = new PreferenciasUsuario();
  //variable para comentario
  String comment = '';

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

  String razonCancelar = "";

  bool razon1 = false;
  bool razon2 = false;
  bool razon3 = false;
  bool razon4 = false;

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

  
  int indexWithIsChosenTrue = 0;
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
    getMensajeAlerta();
    //función callback para mostrar automáticamente el mensaje de alerta de rating
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // if (mounted) {
      //   setState(() {
      //   });
      // }
          this._showRatingAlert();
    });    
    // setState(() {              
    //     viajesProceso = false;      
    // });
    WidgetsBinding.instance.addObserver(this);
    message = new TextEditingController();

    //variable rating inicializadas
    rating1 = 0;
    rating2 = 0;
    rating3 = 0;
    rating4 = 0;
    rating5 = 0;
    rating6 = 0;

    //print(prefs.usuarioId.toString());
    //inicializador del botón de android para manejarlo manual
    BackButtonInterceptor.add(myInterceptor);
  }

  Future<List<dynamic>> getSolicitudes() async {
    totalSolicitudes=0;
    Map data = {
      "agentId": prefs.usuarioId.toString()
    };

    http.Response response = await http.post(Uri.parse('https://smtdriver.com/api/transportation/requests'), body: data);

    var dataR = json.decode(response.body);

    if (dataR["ok"] == true) {
      for(var i = 0; i<dataR["requests"].length;i++){
        if(dataR["requests"][i]["confirmation"]==null){
          totalSolicitudes++;
        }
      }
      //print(dataR["requests"]);
      setState(() {});
      return dataR["requests"]; // Retornar la lista de la propiedad "data"
    } else {
      return []; // Retorna una lista vacía
    }
  }

  void getMensajeAlerta() async {

    Map data = {
      "agentId": prefs.usuarioId.toString()
    };

    http.Response response = await http.post(Uri.parse('https://smtdriver.com/api/transportation/alerts/confirmation'), body: data);

    var dataR = json.decode(response.body);

    if (dataR["ok"] == true) {

      mensajeAlerta=dataR['message'];

    } else {
      mensajeAlerta='';
    }
    setState(() {});
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
    //print('khe;');
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
  Future<dynamic> fetchConfirm(String agentUser, String tripId, String condition, String comment) async {
    LoadingIndicatorDialog().show(context);
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

    if(mounted){
      LoadingIndicatorDialog().dismiss();
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => DetailScreen(plantilla: plantilla[0])))
            .then((_) => DetailScreen(plantilla: plantilla[0]));
        QuickAlert.show(
            context: context,
            title: "Enviado",
            text: 'Tu viaje ha sido confirmado',
            type: QuickAlertType.success,
            confirmBtnText: "Ok"
          );

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
          type: QuickAlertType.error,
          confirmBtnText: "Ok"
        );
      }
    }
    return Message.fromJson(json.decode(response.body));
  }

  //función para cancel trip
  Future<dynamic> fetchCancel(String agentUser, String tripId,
      String conditionC, String message) async {
    LoadingIndicatorDialog().show(context);
    //<List<Map<String, dynamic>>>
    Map data = {
      'agentUser': agentUser,
      'tripId': tripId,
      'condition': conditionC,
      'comment': message
    };
    //print(data);
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
    razonCancelar="";
    
    if(mounted){
      LoadingIndicatorDialog().dismiss();
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
              "Le hemos notificado al conductor",
          type: QuickAlertType.success);
    } else if (response.statusCode == 500) {
      QuickAlert.show(
          context: context,
          title: "Alerta",
          text: resp.message,
          type: QuickAlertType.error,
          confirmBtnText: "Ok");
    }
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
    //print(data);
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
          type: QuickAlertType.success,
          confirmBtnText: "Ok");
    } else if (response.statusCode == 200 && resp.ok != true) {
      QuickAlert.show(
          context: context,
          title: 'Error',
          text: resp.message,
          type: QuickAlertType.error,
          confirmBtnText: "Ok");
    }
  
  }

    //función para skipear calificación
  Future<dynamic>fetchSkipRating2(String agentId, String tripId, int rating1, int rating2, int rating3, String comment) async {
      //<List<Map<String, dynamic>>>
      LoadingIndicatorDialog().show(context);
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
      LoadingIndicatorDialog().dismiss();
      if(mounted){
        if (response.statusCode == 200 && resp.ok == true) {   
          QuickAlert.show(
            context: context,
            title: 'Enviado',
            text: resp.message,
            type: QuickAlertType.success,
            confirmBtnText: "Ok");  
        } 
        else if(response.statusCode == 200 && resp.ok != true){
          QuickAlert.show(
            context: context,
            title: 'Error',
            text: resp.message,
            type: QuickAlertType.error,
            confirmBtnText: "Ok");
        }
      }
    return MessageAccount.fromJson(json.decode(response.body));
  }  
  


  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: viajesProceso ? Theme.of(context).primaryColor: Colors.transparent,
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
                            color: viajesProceso ? Colors.white : Theme.of(context).primaryColorDark,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: viajesProceso ? Colors.white : Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            totalViajes.toString(),
                            style: TextStyle(
                              color: !viajesProceso ? Colors.white : Theme.of(context).primaryColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: viajesProceso ? Colors.transparent : Theme.of(context).primaryColor,
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
                          'Confirmaciones',
                          style: TextStyle(
                            color: !viajesProceso ? Colors.white : Theme.of(context).primaryColorDark,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: !viajesProceso ? Colors.white : Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            totalSolicitudes.toString(),
                            style: TextStyle(
                              color: viajesProceso ? Colors.white : Theme.of(context).primaryColor,
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
            ),
          ),
        ),             
      viajesProceso==false?
        Column(
          children: [

            FutureBuilder<List<dynamic>>(
              future: item2,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: SimpleDialog(
                       elevation: 20,
                      backgroundColor: Theme.of(context).cardColor,
                      children: [
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                child: CircularProgressIndicator(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Cargando..', 
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                  ),
                              )
                            ],
                          ),
                        )
                      ] ,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error al cargar los datos', style: Theme.of(context).textTheme.bodyMedium,);
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Column(
                    children: [
            
                      SizedBox(height: 15),
                      Center(
                        child: Text(
                          'No hay solicitudes de viajes',
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 15),
                          Container(
                            width: 40,
                            height: 40,
                            child: SvgPicture.asset(
                              "assets/icons/advertencia.svg",
                              color: Theme.of(context).primaryIconTheme.color,
                            ),
                          ),
                          SizedBox(height: 5),

                          Text(
                            mensajeAlerta,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18),
                          ),

                          SizedBox(height: 5),
                          Text(
                            "Nos gustaría saber si necesitarás transporte" ,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                      Column(
                        children: List.generate(snapshot.data!.length, (index) {
                          Map<String, dynamic> tripData = snapshot.data![index];
                          return buildTripCard(tripData);
                        }),
                      ),
                    ],
                  );
                }
              },
            ),
        
          ],
        )
        
    :FutureBuilder<TripsList>(
          future: item,
          builder: (context, abc) {
            if (abc.connectionState == ConnectionState.done) {
              //validación si el arreglo viene vacío
              if (abc.data?.trips.length == 0) {
                return Column(
                  children: [
                    SizedBox(height: 15),
                    Center(
                      child: Text(
                        'No tiene viajes asignados',
                    
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                  ],
                );
                //validación si el arreglo contiene información
              } else {
                if (abc.connectionState == ConnectionState.done) {
                  //desplegar data dinámica con LisView builder
                  return Column(
                    children: [

                      SizedBox(height: 15),

                      Text('Total de viajes',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                  
                  SizedBox(height: 15),
                  
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
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text: 'Viaje: ',
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        TextSpan(
                                          text: '${abc.data?.trips[index].tripId}',
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                )

                    ],
                  ),
                    ),
                    Container(
                      height: 1,
                      color: Theme.of(context).dividerColor,
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
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text: 'Fecha: ',
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        TextSpan(
                                          text: '${abc.data?.trips[index].fecha}',
                                          style: TextStyle(fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                    ],
                  ),
                    ),
                    Container(
                      height: 1,
                      color: Theme.of(context).dividerColor,
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
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text: 'Hora: ',
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        TextSpan(
                                          text: '${abc.data?.trips[index].horaEntrada}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromRGBO(40, 169, 83, 1),
                                              fontWeight: FontWeight.normal,
                                            ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                    ],
                  ),
                    ),
                    Container(
                      height: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                  
                     SizedBox(height: 20),
                    Padding(
                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(
                          "assets/icons/motorista.svg",
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text: 'Conductor: ',
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        TextSpan(
                                          text: '${abc.data?.trips[index].conductor}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal
                                            ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                    ],
                  ),
                    ),
                    Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                    ),

                    SizedBox(height: 20),
                    Padding(
                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                  child: Row(
                    children: [
                      Container(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset(
                                "assets/icons/vehiculo.svg",
                                color: Theme.of(context).primaryIconTheme.color,
                              ),
                            ),
                      SizedBox(width: 5),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Vehiculo: ',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: '${abc.data?.trips[index].tripVehicle != null ? abc.data?.trips[index].tripVehicle : '---'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                    ),
                    Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
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
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Teléfono: ',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: '${abc.data?.trips[index].telefono}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                    ),
                    Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
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
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Dirección: ',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: '${abc.data?.trips[index].direccion}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                    ),
                    Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
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
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                        ),
                        SizedBox(width: 5),
                        Flexible(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Acceso autorizado: ',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: '${abc.data?.trips[index].neighborhoodReferencePoint}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
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
                                color: Theme.of(context).primaryIconTheme.color,
                              ),
                            ),
                            SizedBox(width: 5),
                            RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                              children: [
                                TextSpan(
                                  text: 'Hora de encuentro: ',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:16),
                          child: Text(
                            'Necesitas confirmar para que te asignen una hora de encuentro',
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
                    color: Theme.of(context).dividerColor,
                  ),
                    
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                      child: Row(
                      children: [   
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Theme.of(navigatorKey.currentContext!).primaryColorDark),
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
                                              content: StatefulBuilder(
                                                builder:(context, setState) {
                                                  return  Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(navigatorKey.currentContext!).cardColor,
                                                      borderRadius: BorderRadius.circular(16.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            color: Theme.of(navigatorKey.currentContext!).primaryColor,
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
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Checkbox(
                                                                        value: razon1,
                                                                        onChanged: (value) {
                                                                          if(razon1==true)
                                                                            return;
                                                            
                                                                          setState(() {
                                                                            razonCancelar = "Trabajo desde casa";
                                                                            razon1 = !razon1;
                                                                            razon2 = false;
                                                                            razon3 = false;
                                                                            razon4 = false;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                        " Trabajo desde casa",
                                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                      ),
                                                                    ]
                                                                  ),
                                                            
                                                                  Row(
                                                                    children: [
                                                                      Checkbox(
                                                                        value: razon2,
                                                                        onChanged: (value) {
                                                                          if(razon2==true)
                                                                            return;
                                                            
                                                                          setState(() {
                                                                            razonCancelar = "Incapacidad";
                                                                            razon1 = false;
                                                                            razon2 = !razon2;
                                                                            razon3 = false;
                                                                            razon4 = false;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                        " Incapacidad",
                                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                      ),
                                                                    ],
                                                                  ),
                                                            
                                                                  Row(
                                                                    children: [
                                                                      Checkbox(
                                                                        value: razon3,
                                                                        onChanged: (value) {
                                                                          if(razon3==true)
                                                                            return;
                                                            
                                                                          setState(() {
                                                                            razonCancelar = "Vacaciones";
                                                                            razon1 = false;
                                                                            razon2 = false;
                                                                            razon3 = !razon3;
                                                                            razon4 = false;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                        " Vacaciones",
                                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                      ),
                                                                    ],
                                                                  ),
                                                            
                                                                  Row(
                                                                    children: [
                                                                      Checkbox(
                                                                        value: razon4,
                                                                        onChanged: (value) {
                                                                          if(razon4==true)
                                                                            return;
                                                            
                                                                          setState(() {
                                                                            razonCancelar = "Motivo personal";
                                                                            razon1 = false;
                                                                            razon2 = false;
                                                                            razon3 = false;
                                                                            razon4 = !razon4;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                        " Motivo personal",
                                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ),
                                                        SizedBox(height: 16),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: [
                                                            OutlinedButton(
                                                              style: OutlinedButton.styleFrom(
                                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                                foregroundColor: Colors.white,
                                                                side: BorderSide(color: Theme.of(navigatorKey.currentContext!).primaryColorDark),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              child: Text(
                                                                'Cancelar',
                                                                style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
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

                                                                if(razonCancelar.isEmpty){
                                                                  QuickAlert.show(
                                                                    context: context,
                                                                    title: "Alerta",
                                                                    text: 'Debe de seleccionar un motivo.',
                                                                    type: QuickAlertType.error,
                                                                    confirmBtnText: "Ok"
                                                                  );

                                                                  return;
                                                                }

                                                                Navigator.pop(context);
                                                                
                                                                if(mounted){
                                                                  ChatApis().confirmOrCancel('RECHAZADO');
                                                                  fetchCancel(
                                                                    prefs.nombreUsuario,
                                                                    '${abc.data?.trips[index].tripId}',
                                                                    conditionC,
                                                                    razonCancelar,
                                                                  );
                                                                }

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
                                                  );
                                                },
                                              )
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
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
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
                                              content: StatefulBuilder(
                                                builder:(context, setState) {
                                                  return  SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(10.0),
                                                              topRight: Radius.circular(10.0),
                                                            ),
                                                            color: Color.fromRGBO(40, 169, 83, 1),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(right: 100.0, left: 100, bottom: 30, top: 30),
                                                            child: CircleAvatar(
                                                              backgroundColor: Color.fromRGBO(0, 191, 95, 1),
                                                              radius: 30.0 + 10.0, 
                                                              child: Padding(
                                                                padding: EdgeInsets.all(15.0), 
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/check.svg",
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  
                                                  
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                              bottomLeft: Radius.circular(10.0),
                                                              bottomRight: Radius.circular(10.0),
                                                            ),
                                                            color: Colors.white, 
                                                          ),
                                                          child: Column(children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 20),
                                                              child: Text(
                                                                '¿Deseas confirmar el viaje?',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 20, bottom: 20),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  TextButton(
                                                                    style: ButtonStyle(
                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                        RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(10.0),
                                                                          side: BorderSide(color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                                                    ),
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Text(
                                                                      'No',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 20),
                                                                  TextButton(
                                                                    style: ButtonStyle(
                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                        RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(10.0),
                                                                          side: BorderSide(color: Color.fromRGBO(40, 93, 169, 1)),
                                                                        ),
                                                                      ),
                                                                      backgroundColor: MaterialStateProperty.all(Color.fromRGBO(40, 93, 169, 1)),
                                                                    ),
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                  
                                                                      if(mounted){
                                                                        ChatApis().confirmOrCancel('CONFIRMADO');
                                                                        fetchConfirm(
                                                                          prefs.nombreUsuario,
                                                                          '${abc.data?.trips[index].tripId}',
                                                                          condition,comment
                                                                        );
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      'Sí',
                                                                      style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ]),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
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
                  ),
                  //validación de condition in canceled
                    },
                    if ('${abc.data?.trips[index].condition}' ==
                    'Canceled') ...{
                  if ('${abc.data?.trips[index].commentDriver}' ==
                      'No confirmó') ...{
                    Padding(
                      padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            child: SvgPicture.asset(
                              "assets/icons/hora.svg",
                              color: Theme.of(context).primaryIconTheme.color,
                            ),
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'No confirmó a tiempo',
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
                    color: Theme.of(context).dividerColor,
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
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Se ha notificado al conductor que no necesitarás el transporte',
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
                    color: Theme.of(context).dividerColor,
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
                                color: Theme.of(context).primaryIconTheme.color,
                              ),
                            ),
                            SizedBox(width: 5),
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: 'Hora de encuentro: ',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:16),
                          child: Text(
                            '¡Viaje confirmado! Te notificaremos cuando el conductor asigne la hora en la que pasará por ti',
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
                    color: Theme.of(context).dividerColor,
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
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          abc.data?.trips[index].tripType==1? 'Hora de encuentro: ': 'Hora de salida: ',
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w500)
                        ),
                        Text(
                         '${abc.data?.trips[index].horaConductor}',
                          style: TextStyle(
                           fontSize: 14,
                            color: Color.fromRGBO(40, 169, 83, 1),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                    
                  SizedBox(height: 20),
                    },
                    if ('${abc.data?.trips[index].condition}' ==
                    'Confirmed') ...{
                  // if (abc.data?.trips[index].companyId == 1 ||
                  //   abc.data?.trips[index].companyId == 2 ||
                  //   abc.data?.trips[index].companyId == 3 ||
                  //   abc.data?.trips[index].companyId == 5 ||
                  //   abc.data?.trips[index].companyId == 6 ||
                  //   abc.data?.trips[index].companyId == 7 ||
                  //   abc.data?.trips[index].companyId == 9 ||
                  //   abc.data?.trips[index].companyId == 10 ||
                  //   abc.data?.trips[index].companyId == 11 ||
                  //   abc.data?.trips[index].companyId == 12 ||
                  //   abc.data?.trips[index].companyId == 13) ...{
                      if (abc.data?.trips[index].btnCancelTrip == true) ...{
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
                                                content: StatefulBuilder(
                                                  builder:(context, setState) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(navigatorKey.currentContext!).cardColor,
                                                        borderRadius: BorderRadius.circular(16.0),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: Theme.of(navigatorKey.currentContext!).primaryColor,
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
                                                                  child: SingleChildScrollView(
                                                                    child: Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Checkbox(
                                                                              value: razon1,
                                                                              onChanged: (value) {
                                                                                if(razon1==true)
                                                                                  return;
                                                                  
                                                                                setState(() {
                                                                                  razonCancelar = "Trabajo desde casa";
                                                                                  razon1 = !razon1;
                                                                                  razon2 = false;
                                                                                  razon3 = false;
                                                                                  razon4 = false;
                                                                                });
                                                                              },
                                                                            ),
                                                                            Text(
                                                                              " Trabajo desde casa",
                                                                              style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                            ),
                                                                          ]
                                                                        ),
                                                                  
                                                                        Row(
                                                                          children: [
                                                                            Checkbox(
                                                                              value: razon2,
                                                                              onChanged: (value) {
                                                                                if(razon2==true)
                                                                                  return;
                                                                  
                                                                                setState(() {
                                                                                  razonCancelar = "Incapacidad";
                                                                                  razon1 = false;
                                                                                  razon2 = !razon2;
                                                                                  razon3 = false;
                                                                                  razon4 = false;
                                                                                });
                                                                              },
                                                                            ),
                                                                            Text(
                                                                              " Incapacidad",
                                                                              style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                  
                                                                        Row(
                                                                          children: [
                                                                            Checkbox(
                                                                              value: razon3,
                                                                              onChanged: (value) {
                                                                                if(razon3==true)
                                                                                  return;
                                                                  
                                                                                setState(() {
                                                                                  razonCancelar = "Vacaciones";
                                                                                  razon1 = false;
                                                                                  razon2 = false;
                                                                                  razon3 = !razon3;
                                                                                  razon4 = false;
                                                                                });
                                                                              },
                                                                            ),
                                                                            Text(
                                                                              " Vacaciones",
                                                                              style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                  
                                                                        Row(
                                                                          children: [
                                                                            Checkbox(
                                                                              value: razon4,
                                                                              onChanged: (value) {
                                                                                if(razon4==true)
                                                                                  return;
                                                                  
                                                                                setState(() {
                                                                                  razonCancelar = "Motivo personal";
                                                                                  razon1 = false;
                                                                                  razon2 = false;
                                                                                  razon3 = false;
                                                                                  razon4 = !razon4;
                                                                                });
                                                                              },
                                                                            ),
                                                                            Text(
                                                                              " Motivo personal",
                                                                              style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ),
                                                          SizedBox(height: 16),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              OutlinedButton(
                                                                style: OutlinedButton.styleFrom(
                                                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                                                  foregroundColor: Colors.white,
                                                                  side: BorderSide(color: Theme.of(navigatorKey.currentContext!).primaryColorDark),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text(
                                                                  'Cancelar',
                                                                  style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
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
                                                                  if(razonCancelar.isEmpty){
                                                                    QuickAlert.show(
                                                                      context: context,
                                                                      title: "Alerta",
                                                                      text: 'Debe de seleccionar un motivo.',
                                                                      type: QuickAlertType.error,
                                                                      confirmBtnText: "Ok"
                                                                    );

                                                                    return;
                                                                  }

                                                                  Navigator.pop(context);
                                                                  
                                                                  if(mounted){
                                                                    ChatApis().confirmOrCancel('RECHAZADO');
                                                                    fetchCancel(
                                                                      prefs.nombreUsuario,
                                                                      '${abc.data?.trips[index].tripId}',
                                                                      conditionC,
                                                                      razonCancelar,
                                                                    );
                                                                  }
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
                                                    );
                                                  },
                                                )
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
                              color: Theme.of(context).primaryIconTheme.color,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Viaje: ',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w500)
                          ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:16),
                            child: Row(
                              children: [
                                Flexible(
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
                        ],
                      ),
                    ),
                      }
                  // }
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
                      border: Border.all(color: Theme.of(context).dividerColor), // Establece el color del borde
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2, left: 2),
                      child: ExpansionTile(
                        collapsedIconColor: Theme.of(context).primaryColorDark,
                        tilePadding: const EdgeInsets.only(right: 0, left: 0),
                        title: Column(
                          children: [
                            SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(right: 5, left: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    child: SvgPicture.asset(
                                      "assets/icons/Numeral.svg",
                                      color: Theme.of(context).primaryIconTheme.color,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: RichText(
                                      text: TextSpan(
                                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                                        children: [
                                          TextSpan(
                                            text: 'Viaje: ',
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                          TextSpan(
                                            text: '${abc.data?.trips[index].tripId}',
                                            style: TextStyle(fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(right: 5, left: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    child: SvgPicture.asset(
                                      "assets/icons/proximo_viaje.svg",
                                      color: Theme.of(context).primaryIconTheme.color,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: RichText(
                                      text: TextSpan(
                                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                                        children: [
                                          TextSpan(
                                            text: 'Fecha: ',
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                          TextSpan(
                                            text: '${abc.data?.trips[index].fecha}',
                                            style: TextStyle(fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        children: [
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
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
                                color: Theme.of(context).primaryIconTheme.color,
                              ),
                            ),
                            SizedBox(width: 5),
                            Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text: 'Hora: ',
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        TextSpan(
                                          text: '${abc.data?.trips[index].horaEntrada}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromRGBO(40, 169, 83, 1),
                                              fontWeight: FontWeight.normal,
                                            ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                        
                       SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset(
                                "assets/icons/motorista.svg",
                                color: Theme.of(context).primaryIconTheme.color,
                              ),
                            ),
                            SizedBox(width: 5),
                           Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text: 'Conductor: ',
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        TextSpan(
                                          text: '${abc.data?.trips[index].conductor}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal
                                            ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                        
                    SizedBox(height: 20),
                    Padding(
                  padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                  child: Row(
                    children: [
                      Container(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset(
                                "assets/icons/vehiculo.svg",
                                color: Theme.of(context).primaryIconTheme.color,
                              ),
                            ),
                      SizedBox(width: 5),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Vehículo: ',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              
                              TextSpan(
                                text: 
                                abc.data?.trips[index].tripVehicle != "" ?'${abc.data?.trips[index].tripVehicle}':
                                "Sin asignar" ,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                    ),
                    Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
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
                                color: Theme.of(context).primaryIconTheme.color,
                              ),
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                                  children: [
                                    TextSpan(
                                      text: 'Teléfono: ',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: '${abc.data?.trips[index].telefono}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
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
                                color: Theme.of(context).primaryIconTheme.color,
                              ),
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                                  children: [
                                    TextSpan(
                                      text: 'Dirección: ',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: '${abc.data?.trips[index].direccion}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
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
                                  color: Theme.of(context).primaryIconTheme.color,
                                ),
                              ),
                              SizedBox(width: 5),
                              Flexible(
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                                  children: [
                                    TextSpan(
                                      text: 'Acceso autorizado: ',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: '${abc.data?.trips[index].neighborhoodReferencePoint}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Theme.of(context).dividerColor,
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
                                      color: Theme.of(context).primaryIconTheme.color,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Hora de encuentro: ',
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w500)
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:16),
                                child: Text(
                                  'Necesitas confirmar para que te asignen una hora de encuentro',
                                  style: TextStyle(
                                    fontSize: 15,
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
                          color: Theme.of(context).dividerColor,
                        ),
                          
                        SizedBox(height: 20),
                        Padding(
                           padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                          child: Row(
                            children: [   
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Theme.of(navigatorKey.currentContext!).primaryColorDark),
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
                                                    content: StatefulBuilder(
                                                      builder:(context, setState) {
                                                        return Container(
                                                          decoration: BoxDecoration(
                                                            color: Theme.of(navigatorKey.currentContext!).cardColor,
                                                            borderRadius: BorderRadius.circular(16.0),
                                                          ),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                  color: Theme.of(navigatorKey.currentContext!).primaryColor,
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
                                                                child: SingleChildScrollView(
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Checkbox(
                                                                            value: razon1,
                                                                            onChanged: (value) {
                                                                              if(razon1==true)
                                                                                return;
                                                                
                                                                              setState(() {
                                                                                razonCancelar = "Trabajo desde casa";
                                                                                razon1 = !razon1;
                                                                                razon2 = false;
                                                                                razon3 = false;
                                                                                razon4 = false;
                                                                              });
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            " Trabajo desde casa",
                                                                            style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                          ),
                                                                        ]
                                                                      ),
                                                                
                                                                      Row(
                                                                        children: [
                                                                          Checkbox(
                                                                            value: razon2,
                                                                            onChanged: (value) {
                                                                              if(razon2==true)
                                                                                return;
                                                                
                                                                              setState(() {
                                                                                razonCancelar = "Incapacidad";
                                                                                razon1 = false;
                                                                                razon2 = !razon2;
                                                                                razon3 = false;
                                                                                razon4 = false;
                                                                              });
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            " Incapacidad",
                                                                            style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                
                                                                      Row(
                                                                        children: [
                                                                          Checkbox(
                                                                            value: razon3,
                                                                            onChanged: (value) {
                                                                              if(razon3==true)
                                                                                return;
                                                                
                                                                              setState(() {
                                                                                razonCancelar = "Vacaciones";
                                                                                razon1 = false;
                                                                                razon2 = false;
                                                                                razon3 = !razon3;
                                                                                razon4 = false;
                                                                              });
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            " Vacaciones",
                                                                            style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                
                                                                      Row(
                                                                        children: [
                                                                          Checkbox(
                                                                            value: razon4,
                                                                            onChanged: (value) {
                                                                              if(razon4==true)
                                                                                return;
                                                                
                                                                              setState(() {
                                                                                razonCancelar = "Motivo personal";
                                                                                razon1 = false;
                                                                                razon2 = false;
                                                                                razon3 = false;
                                                                                razon4 = !razon4;
                                                                              });
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            " Motivo personal",
                                                                            style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ),
                                                              SizedBox(height: 16),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: [
                                                                  OutlinedButton(
                                                                    style: OutlinedButton.styleFrom(
                                                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                                                      foregroundColor: Colors.white,
                                                                      side: BorderSide(color: Theme.of(navigatorKey.currentContext!).primaryColorDark),
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(12.0),
                                                                      ),
                                                                    ),
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Text(
                                                                      'Cancelar',
                                                                      style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
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
                                                                      if(razonCancelar.isEmpty){
                                                                        QuickAlert.show(
                                                                          context: context,
                                                                          title: "Alerta",
                                                                          text: 'Debe de seleccionar un motivo.',
                                                                          type: QuickAlertType.error,
                                                                          confirmBtnText: "Ok"
                                                                        );

                                                                        return;
                                                                      }
                                                                      
                                                                      Navigator.pop(context);
                                                                
                                                                      if(mounted){
                                                                        ChatApis().confirmOrCancel('RECHAZADO');
                                                                        fetchCancel(
                                                                          prefs.nombreUsuario,
                                                                          '${abc.data?.trips[index].tripId}',
                                                                          conditionC,
                                                                          razonCancelar,
                                                                        );
                                                                      }
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
                                                        );
                                                      },
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
                                    style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium!.copyWith(fontSize: 15),
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
                                              content: StatefulBuilder(
                                                builder:(context, setState) {
                                                  return  SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(10.0),
                                                              topRight: Radius.circular(10.0),
                                                            ),
                                                            color: Color.fromRGBO(40, 169, 83, 1),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(right: 100.0, left: 100, bottom: 30, top: 30),
                                                            child: CircleAvatar(
                                                              backgroundColor: Color.fromRGBO(0, 191, 95, 1),
                                                              radius: 30.0 + 10.0, 
                                                              child: Padding(
                                                                padding: EdgeInsets.all(15.0), 
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/check.svg",
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  
                                                  
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                              bottomLeft: Radius.circular(10.0),
                                                              bottomRight: Radius.circular(10.0),
                                                            ),
                                                            color: Colors.white, 
                                                          ),
                                                          child: Column(children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 20),
                                                              child: Text(
                                                                '¿Deseas confirmar el viaje?',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 20, bottom: 20),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  TextButton(
                                                                    style: ButtonStyle(
                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                        RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(10.0),
                                                                          side: BorderSide(color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                                                    ),
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Text(
                                                                      'No',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 20),
                                                                  TextButton(
                                                                    style: ButtonStyle(
                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                        RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(10.0),
                                                                          side: BorderSide(color: Color.fromRGBO(40, 93, 169, 1)),
                                                                        ),
                                                                      ),
                                                                      backgroundColor: MaterialStateProperty.all(Color.fromRGBO(40, 93, 169, 1)),
                                                                    ),
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                  
                                                                      if(mounted){
                                                                        ChatApis().confirmOrCancel('CONFIRMADO');
                                                                        fetchConfirm(
                                                                          prefs.nombreUsuario,
                                                                          '${abc.data?.trips[index].tripId}',
                                                                          condition,comment
                                                                        );
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      'Sí',
                                                                      style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ]),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
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
                                    'Confirmar',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                        
                              ),
                            ],
                          ),
                        ),
                        //validación de condition in canceled
                      },
                      if ('${abc.data?.trips[index].condition}' ==
                          'Canceled') ...{
                        if ('${abc.data?.trips[index].commentDriver}' ==
                            'No confirmó') ...{
                          Padding(
                            padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  child: SvgPicture.asset(
                                    "assets/icons/hora.svg",
                                    color: Theme.of(context).primaryIconTheme.color
                                  ),
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    'No confirmó a tiempo',
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
                                  color: Theme.of(context).primaryIconTheme.color,
                                ),
                              ),
                              SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  'Se ha notificado al conductor que no necesitarás el transporte',
                                  style: TextStyle(
                                    fontSize: 15,
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
                          color: Theme.of(context).dividerColor,
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
                                      color: Theme.of(context).primaryIconTheme.color,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Hora de encuentro: ',
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w600)
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:16),
                                child: Text(
                                  '¡Viaje confirmado! Te notificaremos cuando el conductor asigne la hora en la que pasará por ti',
                                  style: TextStyle(
                                    fontSize: 15,
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
                          color: Theme.of(context).dividerColor
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
                                  color: Theme.of(context).primaryIconTheme.color
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                abc.data?.trips[index].tripType==1? 'Hora de encuentro: ': 'Hora de salida: ',
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w500)
                              ),
                              Text(
                               '${abc.data?.trips[index].horaConductor}',
                                style: TextStyle(
                                 fontSize: 15,
                                  color: Color.fromRGBO(40, 169, 83, 1),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Theme.of(context).dividerColor
                        ),
                          
                        SizedBox(height: 20),
                      },
                      if ('${abc.data?.trips[index].condition}' ==
                          'Confirmed') ...{
                        // if (abc.data?.trips[index].companyId == 1 ||
                        //     abc.data?.trips[index].companyId == 2 ||
                        //     abc.data?.trips[index].companyId == 3 ||
                        //     abc.data?.trips[index].companyId == 5 ||
                        //     abc.data?.trips[index].companyId == 6 ||
                        //     abc.data?.trips[index].companyId == 7 ||
                        //     abc.data?.trips[index].companyId == 9 ||
                        //     abc.data?.trips[index].companyId == 10 ||
                        //     abc.data?.trips[index].companyId == 11 ||
                        //     abc.data?.trips[index].companyId == 12 ||
                        //     abc.data?.trips[index].companyId == 13) ...{
                          if (abc.data?.trips[index].btnCancelTrip == true) ...{
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
                                                  content: StatefulBuilder(
                                                    builder:(context, setState) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          color: Theme.of(navigatorKey.currentContext!).cardColor,
                                                          borderRadius: BorderRadius.circular(16.0),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                color: Theme.of(navigatorKey.currentContext!).primaryColor,
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
                                                                child: SingleChildScrollView(
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Checkbox(
                                                                            value: razon1,
                                                                            onChanged: (value) {
                                                                              if(razon1==true)
                                                                                return;
                                                                
                                                                              setState(() {
                                                                                razonCancelar = "Trabajo desde casa";
                                                                                razon1 = !razon1;
                                                                                razon2 = false;
                                                                                razon3 = false;
                                                                                razon4 = false;
                                                                              });
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            " Trabajo desde casa",
                                                                            style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                          ),
                                                                        ]
                                                                      ),
                                                                
                                                                      Row(
                                                                        children: [
                                                                          Checkbox(
                                                                            value: razon2,
                                                                            onChanged: (value) {
                                                                              if(razon2==true)
                                                                                return;
                                                                
                                                                              setState(() {
                                                                                razonCancelar = "Incapacidad";
                                                                                razon1 = false;
                                                                                razon2 = !razon2;
                                                                                razon3 = false;
                                                                                razon4 = false;
                                                                              });
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            " Incapacidad",
                                                                            style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                
                                                                      Row(
                                                                        children: [
                                                                          Checkbox(
                                                                            value: razon3,
                                                                            onChanged: (value) {
                                                                              if(razon3==true)
                                                                                return;
                                                                
                                                                              setState(() {
                                                                                razonCancelar = "Vacaciones";
                                                                                razon1 = false;
                                                                                razon2 = false;
                                                                                razon3 = !razon3;
                                                                                razon4 = false;
                                                                              });
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            " Vacaciones",
                                                                            style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                
                                                                      Row(
                                                                        children: [
                                                                          Checkbox(
                                                                            value: razon4,
                                                                            onChanged: (value) {
                                                                              if(razon4==true)
                                                                                return;
                                                                
                                                                              setState(() {
                                                                                razonCancelar = "Motivo personal";
                                                                                razon1 = false;
                                                                                razon2 = false;
                                                                                razon3 = false;
                                                                                razon4 = !razon4;
                                                                              });
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            " Motivo personal",
                                                                            style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ),
                                                            SizedBox(height: 16),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                OutlinedButton(
                                                                  style: OutlinedButton.styleFrom(
                                                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                                                    foregroundColor: Colors.white,
                                                                    side: BorderSide(color: Theme.of(navigatorKey.currentContext!).primaryColorDark),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(12.0),
                                                                    ),
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Text(
                                                                    'Cancelar',
                                                                    style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
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
                                                                    if(razonCancelar.isEmpty){
                                                                      QuickAlert.show(
                                                                        context: context,
                                                                        title: "Alerta",
                                                                        text: 'Debe de seleccionar un motivo.',
                                                                        type: QuickAlertType.error,
                                                                        confirmBtnText: "Ok"
                                                                      );

                                                                      return;
                                                                    }

                                                                    Navigator.pop(context);
                                                                
                                                                    if(mounted){
                                                                      ChatApis().confirmOrCancel('RECHAZADO');
                                                                      fetchCancel(
                                                                        prefs.nombreUsuario,
                                                                        '${abc.data?.trips[index].tripId}',
                                                                        conditionC,
                                                                        razonCancelar,
                                                                      );
                                                                    }
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
                                                      );
                                                    },
                                                  )
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
                                  color: Theme.of(context).primaryIconTheme.color
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Viaje: ',
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w500)
                              ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:16),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Su tiempo para cancelar el viaje ha expirado',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.red,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                          }
                        //}
                      } else
                        ...{},
                        
                        SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                    );
                  })
                    ],
                  );
                } else {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: SimpleDialog(
                       elevation: 20,
                      backgroundColor: Theme.of(context).cardColor,
                      children: [
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                child: CircularProgressIndicator(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Cargando..', 
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                  ),
                              )
                            ],
                          ),
                        )
                      ] ,
                    ),
                  );
                }
              }
            } else {
              return WillPopScope(
                    onWillPop: () async => false,
                    child: SimpleDialog(
                       elevation: 20,
                      backgroundColor: Theme.of(context).cardColor,
                      children: [
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                child: CircularProgressIndicator(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Cargando..', 
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                  ),
                              )
                            ],
                          ),
                        )
                      ] ,
                    ),
                  );
            }
            //return SizedBox();
          },
        ),
      ],
    );
  }

  Widget buildTripCard(Map<String, dynamic> tripData) {
    Size size = MediaQuery.of(context).size;
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
            color: Theme.of(context).dividerColor,
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
                          "assets/icons/proximo_viaje.svg",
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: RichText(
                          text: TextSpan( 
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Fecha: ',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: '${tripData["dateToTravel"]}',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Theme.of(context).dividerColor,
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
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: RichText(
                          text: TextSpan( 
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Transporte para: ',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: '${tripData["tripType"]}',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: ()async{                    
                    if(tripData["confirmation"] == null){
                      if(tripData["hasToSelectHour"] == 1){
                        LoadingIndicatorDialog().show(context);
                        var data = {
                          'agentForTravelId': tripData["agentForTravelId"].toString()
                        };
                        //print(data);                      
                        http.Response responses = await http.post(Uri.parse('https://smtdriver.com/api/getHourToConfirm'), body: data);
                        final resp = json.decode(responses.body);
                        //print(resp);
                        if(resp['ok']==true){
                          LoadingIndicatorDialog().dismiss();                          
                          horas(size, context, resp, tripData["agentForTravelId"].toString(), tripData["hour"]);
                        }else{
                          LoadingIndicatorDialog().dismiss();
                          QuickAlert.show(
                            context: context,
                            title: "Alerta",
                            text: '${resp['message']}',
                            type: QuickAlertType.error,
                            confirmBtnText: "Ok"
                          );
                        }
                      }
                    }
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          child: SvgPicture.asset(
                            "assets/icons/hora.svg",
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: RichText(
                            text: TextSpan( 
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                              children: [
                                TextSpan(
                                  text: 'Hora: ',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: tripData["hour"] == null?"Seleccione una hora":'${tripData["hour"]}',
                                  style: TextStyle(fontWeight: FontWeight.normal, color:tripData["hour"] == null? Colors.red:Color.fromRGBO(40, 169, 83, 1)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if(tripData["confirmation"] == null)...{
                          if(tripData["hasToSelectHour"] == 1)...{
                            SizedBox(width: 15),
                            Container(
                              width: 18,
                              height: 18,
                              child: SvgPicture.asset(
                                "assets/icons/flechahaciaabajo.svg",
                                color: Theme.of(context).primaryIconTheme.color,
                              ),
                            ), 
                          },
                        },
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async{
                        if(tripData["confirmation"] == null){
                          LoadingIndicatorDialog().show(context);
                          http.Response responses = await http.get(Uri.parse('https://admin.smtdriver.com/multipleAgentLocations/${prefs.usuarioId}'));
                          final resp = json.decode(responses.body);
                          http.Response responses2 = await http.get(Uri.parse('https://smtdriver.com/api/getLocationStartek/${prefs.usuarioId}'));
                          final resp2 = json.decode(responses2.body);

                          if(resp['ok']==true){
                            LoadingIndicatorDialog().dismiss();
                            if (tripData["tripType"]=="Entrada") {                                            
                              //direcciones(size, context, resp);
                              tripData["hasToSelectPoint"]==1?direcciones2(size, context, resp2['locations'], tripData["agentForTravelId"], tripData["agentAddress"], "Tus direcciones", 0):direcciones(size, context, resp);
                            }else{
                              //print(resp2);
                              tripData["hasToSelectPoint"]==1?direcciones2(size, context, resp2['locations'], tripData["agentForTravelId"], tripData["agentAddress"], "Tus direcciones", 0):direcciones(size, context, resp);
                            }
                          }else{
                            LoadingIndicatorDialog().dismiss();
                            QuickAlert.show(
                              context: context,
                              title: "Alerta",
                              text: '${resp['message']}',
                              type: QuickAlertType.error,
                              confirmBtnText: "Ok"
                            );
                          }
                        }
                        },
                                        
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          child: SvgPicture.asset(
                            "assets/icons/Casa.svg",
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: RichText(
                            text: TextSpan( 
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                              children: [
                                TextSpan(
                                  text: 'Dirección: ',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: tripData["agentAddress"]==null?'Seleccione una dirección':'${tripData["agentAddress"]}',
                                  style: prefs.tema ? TextStyle(fontWeight: FontWeight.normal, color:tripData["agentAddress"]==null? Colors.red:Colors.white):TextStyle(fontWeight: FontWeight.normal, color:tripData["agentAddress"]==null? Colors.red:Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if(tripData["confirmation"] == null)...{
                          SizedBox(width: 5),
                          Container(
                            width: 18,
                            height: 18,
                            child: SvgPicture.asset(
                              "assets/icons/flechahaciaabajo.svg",
                              color: Theme.of(context).primaryIconTheme.color,
                            ),
                          ), 
                        }
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Theme.of(context).dividerColor,
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
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: RichText(
                          text: TextSpan( 
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Acceso autorizado: ',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: '${tripData["authorizedAccess"]}',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
              SizedBox(height: 10),
              if (tripData["confirmation"] == true)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                               child: SvgPicture.asset(
                                "assets/icons/advertencia.svg",
                                color: Theme.of(context).primaryIconTheme.color,
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
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),

                      if(tripData["hideCancelButton"]!=true)
                        SizedBox(height: 10),
                      
                      if(tripData["hideCancelButton"]!=true)
                      TextButton(
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
                                                    content: StatefulBuilder(
                                                      builder:(context, setState) {
                                                        return  Container(
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(navigatorKey.currentContext!).cardColor,
                                                        borderRadius: BorderRadius.circular(16.0),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: Theme.of(navigatorKey.currentContext!).primaryColor,
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(16.0),
                                                                topRight: Radius.circular(16.0),
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(20.0),
                                                              child: Text(
                                                                'Nos encantaría conocer tu razón',
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
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Checkbox(
                                                                        value: razon1,
                                                                        onChanged: (value) {
                                                                          if(razon1==true)
                                                                            return;
                                                            
                                                                          setState(() {
                                                                            razonCancelar = "Trabajo desde casa";
                                                                            razon1 = !razon1;
                                                                            razon2 = false;
                                                                            razon3 = false;
                                                                            razon4 = false;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                        " Trabajo desde casa",
                                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                      ),
                                                                    ]
                                                                  ),
                                                            
                                                                  Row(
                                                                    children: [
                                                                      Checkbox(
                                                                        value: razon2,
                                                                        onChanged: (value) {
                                                                          if(razon2==true)
                                                                            return;
                                                            
                                                                          setState(() {
                                                                            razonCancelar = "Incapacidad";
                                                                            razon1 = false;
                                                                            razon2 = !razon2;
                                                                            razon3 = false;
                                                                            razon4 = false;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                        " Incapacidad",
                                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                      ),
                                                                    ],
                                                                  ),
                                                            
                                                                  Row(
                                                                    children: [
                                                                      Checkbox(
                                                                        value: razon3,
                                                                        onChanged: (value) {
                                                                          if(razon3==true)
                                                                            return;
                                                            
                                                                          setState(() {
                                                                            razonCancelar = "Vacaciones";
                                                                            razon1 = false;
                                                                            razon2 = false;
                                                                            razon3 = !razon3;
                                                                            razon4 = false;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                        " Vacaciones",
                                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                      ),
                                                                    ],
                                                                  ),
                                                            
                                                                  Row(
                                                                    children: [
                                                                      Checkbox(
                                                                        
                                                                        value: razon4,
                                                                        onChanged: (value) {
                                                                          if(razon4==true)
                                                                            return;
                                                            
                                                                          setState(() {
                                                                            razonCancelar = "Motivo personal";
                                                                            razon1 = false;
                                                                            razon2 = false;
                                                                            razon3 = false;
                                                                            razon4 = !razon4;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                        " Motivo personal",
                                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ),
                                                          SizedBox(height: 16),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              OutlinedButton(
                                                                style: OutlinedButton.styleFrom(
                                                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                                                  foregroundColor: Theme.of(navigatorKey.currentContext!).cardColor,
                                                                  side: BorderSide(color: Theme.of(navigatorKey.currentContext!).primaryColorDark),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text(
                                                                  'Cancelar',
                                                                  style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium
                                                                ),
                                                              ),
                
                                                              OutlinedButton(
                                                                style: OutlinedButton.styleFrom(
                                                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                                                  backgroundColor: const Color.fromRGBO(40, 93, 169, 1),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                  ),
                                                                ),
                                                                onPressed: () async{
                                                                  if (razonCancelar.isEmpty) {
                                                                    QuickAlert.show(
                                                                      context: context,
                                                                      title: "Comentario Requerido",
                                                                      text: "Debes elegir una opcion antes de enviar",
                                                                      type: QuickAlertType.error,
                                                                      confirmBtnText: "Ok"
                                                                    );  
                                                                    return;        
                                                                  } else {
                                                                    
                                                                    LoadingIndicatorDialog().show(context);
                                                                    Map data = {
                                                                      "agentForTravelId": tripData["agentForTravelId"].toString(),
                                                                      "confirmation": "0",
                                                                      "agentComment": razonCancelar
                                                                    };
                                                                   // print(data);
                                                                    http.Response response = await http.post(Uri.parse('https://smtdriver.com/api/transportation/confirm'), body: data);
                                                                    //print(response.body);
                                                    
                                                                    var dataR = json.decode(response.body);

                                                                    
                                                                    if (dataR["ok"] == true) {
                                                                        LoadingIndicatorDialog().dismiss();    
                                                                        Navigator.of(context).pop();   
                                                                        QuickAlert.show(
                                                                          context: context,
                                                                          title: "Enviado",
                                                                          text: dataR["message"],
                                                                          type: QuickAlertType.success,
                                                                          confirmBtnText: "Ok"
                                                                        );
                                                                      setState(() {
                                                                        razonCancelar="";
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
                                                                        confirmBtnText: "Ok"
                                                                      );
                                                                    }
                                                                    
                                                                  }
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
                                                    );
                                                      }
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              if (tripData["confirmation"] == false)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                           child: SvgPicture.asset(
                            "assets/icons/advertencia.svg",
                            color: Theme.of(context).primaryIconTheme.color,
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
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
              if (tripData["confirmation"] != true && tripData["confirmation"] != false)
                tripData["systemComment"]==null?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
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
                                                    content: StatefulBuilder(
                                                      builder:(context, setState) {
                                                        return  Container(
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(navigatorKey.currentContext!).cardColor,
                                                        borderRadius: BorderRadius.circular(16.0),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: Theme.of(navigatorKey.currentContext!).primaryColor,
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(16.0),
                                                                topRight: Radius.circular(16.0),
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(20.0),
                                                              child: Text(
                                                                'Nos encantaría conocer tu razón',
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
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Checkbox(
                                                                        value: razon1,
                                                                        onChanged: (value) {
                                                                          if(razon1==true)
                                                                            return;
                                                            
                                                                          setState(() {
                                                                            razonCancelar = "Trabajo desde casa";
                                                                            razon1 = !razon1;
                                                                            razon2 = false;
                                                                            razon3 = false;
                                                                            razon4 = false;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                        " Trabajo desde casa",
                                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                      ),
                                                                    ]
                                                                  ),
                                                            
                                                                  Row(
                                                                    children: [
                                                                      Checkbox(
                                                                        value: razon2,
                                                                        onChanged: (value) {
                                                                          if(razon2==true)
                                                                            return;
                                                            
                                                                          setState(() {
                                                                            razonCancelar = "Incapacidad";
                                                                            razon1 = false;
                                                                            razon2 = !razon2;
                                                                            razon3 = false;
                                                                            razon4 = false;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                        " Incapacidad",
                                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                      ),
                                                                    ],
                                                                  ),
                                                            
                                                                  Row(
                                                                    children: [
                                                                      Checkbox(
                                                                        value: razon3,
                                                                        onChanged: (value) {
                                                                          if(razon3==true)
                                                                            return;
                                                            
                                                                          setState(() {
                                                                            razonCancelar = "Vacaciones";
                                                                            razon1 = false;
                                                                            razon2 = false;
                                                                            razon3 = !razon3;
                                                                            razon4 = false;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                        " Vacaciones",
                                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                      ),
                                                                    ],
                                                                  ),
                                                            
                                                                  Row(
                                                                    children: [
                                                                      Checkbox(
                                                                        value: razon4,
                                                                        onChanged: (value) {
                                                                          if(razon4==true)
                                                                            return;
                                                            
                                                                          setState(() {
                                                                            razonCancelar = "Motivo personal";
                                                                            razon1 = false;
                                                                            razon2 = false;
                                                                            razon3 = false;
                                                                            razon4 = !razon4;
                                                                          });
                                                                        },
                                                                      ),
                                                                      Text(
                                                                        " Motivo personal",
                                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ),
                                                          SizedBox(height: 16),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              OutlinedButton(
                                                                style: OutlinedButton.styleFrom(
                                                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                                                  foregroundColor: Theme.of(navigatorKey.currentContext!).cardColor,
                                                                  side: BorderSide(color: Theme.of(navigatorKey.currentContext!).primaryColorDark),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text(
                                                                  'Cancelar',
                                                                  style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium
                                                                ),
                                                              ),
                
                                                              OutlinedButton(
                                                                style: OutlinedButton.styleFrom(
                                                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                                                  backgroundColor: const Color.fromRGBO(40, 93, 169, 1),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                  ),
                                                                ),
                                                                onPressed: () async{
                                                                  if (razonCancelar.isEmpty) {
                                                                    QuickAlert.show(
                                                                      context: context,
                                                                      title: "Comentario Requerido",
                                                                      text: "Debes elegir una opcion antes de enviar",
                                                                      type: QuickAlertType.error,
                                                                      confirmBtnText: "Ok"
                                                                    );  
                                                                    return;        
                                                                  } else {
                                                                    
                                                                    LoadingIndicatorDialog().show(context);
                                                                    Map data = {
                                                                      "agentForTravelId": tripData["agentForTravelId"].toString(),
                                                                      "confirmation": "0",
                                                                      "agentComment": razonCancelar
                                                                    };
                                                                   // print(data);
                                                                    http.Response response = await http.post(Uri.parse('https://smtdriver.com/api/transportation/confirm'), body: data);
                                                                    //print(response.body);
                                                    
                                                                    var dataR = json.decode(response.body);

                                                                    
                                                                    if (dataR["ok"] == true) {
                                                                        LoadingIndicatorDialog().dismiss();    
                                                                        Navigator.of(context).pop();   
                                                                        QuickAlert.show(
                                                                          context: context,
                                                                          title: "Enviado",
                                                                          text: dataR["message"],
                                                                          type: QuickAlertType.success,
                                                                          confirmBtnText: "Ok"
                                                                        );
                                                                      setState(() {
                                                                        razonCancelar="";
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
                                                                        confirmBtnText: "Ok"
                                                                      );
                                                                    }
                                                                    
                                                                  }
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
                                                    );
                                                      }
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
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColorDark),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8, right: 20, left: 20),
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 30),
                    InkWell(
                      onTap: () async{
                        if (tripData["hour"] == null) {
                          if(tripData["hasToSelectHour"] == 1){
                            LoadingIndicatorDialog().show(context);
                            var data = {
                              'agentForTravelId': tripData["agentForTravelId"].toString()
                            };
                            //print(data);                      
                            http.Response responses = await http.post(Uri.parse('https://smtdriver.com/api/getHourToConfirm'), body: data);
                            final resp = json.decode(responses.body);
                            //print(resp);
                            if(resp['ok']==true){
                              LoadingIndicatorDialog().dismiss();                          
                              horas(size, context, resp, tripData["agentForTravelId"].toString(), tripData["hour"]);
                            }else{
                              LoadingIndicatorDialog().dismiss();
                              QuickAlert.show(
                                context: context,
                                title: "Alerta",
                                text: '${resp['message']}',
                                type: QuickAlertType.error,
                                confirmBtnText: "Ok"
                              );
                            }
                          }
                          return;
                        }

                        if (tripData["agentAddress"] != null) {                          
                          final ConfirmationLoadingDialog loadingDialog = ConfirmationLoadingDialog();
                          ConfirmationDialog confirmationDialog = ConfirmationDialog();
                          confirmationDialog.show(
                            context,
                            title: '¿Deseas confirmar la solicitud?',
                            type: "0",
                            onConfirm: () async {                              
                              loadingDialog.show(context);

                              Map data = {
                                "agentForTravelId": tripData["agentForTravelId"].toString(),
                                "confirmation": "1",
                                "agentComment": "null",
                              };

                              http.Response response = await http.post(Uri.parse('https://smtdriver.com/api/transportation/confirm'), body: data);
                             // print(response.body);

                              var dataR = json.decode(response.body);

                              if (dataR["ok"] == true) {
                                setState(() {
                                  item2 = getSolicitudes();
                                });
                                loadingDialog.dismiss();
                                confirmationDialog.dismiss();
                                QuickAlert.show(
                                  context: context,
                                  title: "Enviado",
                                  text: dataR["message"],
                                  type: QuickAlertType.success,
                                  confirmBtnText: "Ok"
                                );
                              } else {
                                loadingDialog.dismiss();
                                confirmationDialog.dismiss();
                                QuickAlert.show(
                                  context: context,
                                  title: "Error",
                                  text: dataR["message"],
                                  type: QuickAlertType.error,
                                  confirmBtnText: "Ok"
                                );
                              }
                              
                            },
                            onCancel: () {

                            },
                          );
                        }else{                          
                          LoadingIndicatorDialog().show(context);
                          http.Response responses = await http.get(Uri.parse('https://admin.smtdriver.com/multipleAgentLocations/${prefs.usuarioId}'));
                          final resp = json.decode(responses.body);
                          http.Response responses2 = await http.get(Uri.parse('https://smtdriver.com/api/getLocationStartek/${prefs.usuarioId}'));
                          final resp2 = json.decode(responses2.body);

                          LoadingIndicatorDialog().dismiss();
                          tripData["hasToSelectPoint"]==1?direcciones2(size, context, resp2['locations'], tripData["agentForTravelId"], tripData["agentAddress"], "Debes seleccionar una dirección", 1):direcciones(size, context, resp);
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
                ) :
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                           child: SvgPicture.asset(
                            "assets/icons/advertencia.svg",
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'El tiempo de confirmación ha expirado',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
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
    // http.Response responses = await http
    //     .get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    // final resp = DataAgent.fromJson(json.decode(responses.body));
    // http.Response response =
    //     await http.get(Uri.parse('$ip/api/getMaskReminder/${resp.agentId}'));
    // final resp1 = Mask.fromJson(json.decode(response.body));
    // //validacion si fué visto la alerta
    // //print(resp1.viewed);
    // if (resp1.viewed != null) {
    //   await http
    //       .get(Uri.parse('$ip/api/markAsViewedMaskReminder/${resp.agentId}'));
    // }
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
      if (getData['tripId'] != 0 && responsex.body.isNotEmpty) {
        showAlertDialogRatingOld();       
      }  
    }   

  }

  //creación de alerta
  showAlertDialogRatingOld()async{
    //llamado de apis directamente
    http.Response responses = await http.get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final resp = DataAgent.fromJson(json.decode(responses.body));
    http.Response response = await http.get(Uri.parse('$ip/api/ratingTrip/${resp.agentId}'));
    final resp1 = Rating.fromJson(json.decode(response.body));
    
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
      
      return Transform(transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
        child: Opacity(opacity: a1.value,
          child: AlertDialog(shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
            backgroundColor: Theme.of(navigatorKey.currentContext!).cardColor,
            title: Text(
              '¿Cómo calificarías tu último viaje con\n${resp1.driverFullname}?',
              textAlign: TextAlign.center, 
              style: Theme.of(navigatorKey.currentContext!).textTheme.titleMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
            ), 
            content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return SingleChildScrollView(
                child: Container(height: 300,width: 500,
                color: Colors.transparent,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //creación reacciones para conducción
                        resp1.tripType == 1?
                        Text(
                          'Tipo de viaje: Entrada',
                          textAlign: TextAlign.center, 
                          style: Theme.of(navigatorKey.currentContext!).textTheme.titleMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                        ):Text(
                          'Tipo de viaje: Salida',
                          textAlign: TextAlign.center, 
                          style: Theme.of(navigatorKey.currentContext!).textTheme.titleMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10.0),
                        Text('Conducción', style:Theme.of(navigatorKey.currentContext!).textTheme.labelMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.normal)),
                        SizedBox(height: 5.0),
                        RatingBar.builder(
                          initialRating: 0,
                          itemCount: 5,
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
               
                        SizedBox(height: 40.0),
                        //creación reacciones para amabilidad
                        Text('Amabilidad del motorista', style: Theme.of(navigatorKey.currentContext!).textTheme.labelMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.normal)),
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
                 
                        SizedBox(height: 40.0),
                        //creación reacciones para condiciones
                        Text('Condiciones del vehículo', style: Theme.of(navigatorKey.currentContext!).textTheme.labelMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.normal)),
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
                ),
              );
            }
            ),                  
            actions:<Widget> [    
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //SizedBox(width: 15.0), 
                  ButtonTheme(
                    minWidth: 60.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0), // Ajusta el radio según tus preferencias
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor : Colors.orange,
                        foregroundColor : Colors.white,
                      ),
                      onPressed: () {
                        // Acción al presionar el botón
                        Navigator.pop(context);
                        fetchSkipRating2(
                          resp.agentId.toString(),
                          resp1.tripId.toString(),
                          rating1.toInt(),
                          rating2.toInt(),
                          rating3.toInt(),
                          message.text,
                        );
                        
                      },
                      child: Text(
                        'Omitir',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
 
                  //SizedBox(width: 5.0),                                   
                  ButtonTheme(
                    minWidth: 60.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0), // Ajusta el radio según tus preferencias
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor : Colors.grey,
                        foregroundColor : Colors.white,
                      ),
                      onPressed: () {
                        // Acción al presionar el botón
                         Navigator.pop(context);
                      },
                      child: Text(
                        'Ahora no',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  //SizedBox(width: 5.0),                                   
                  ButtonTheme(
                    minWidth: 60.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0), // Ajusta el radio según tus preferencias
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor : Color.fromRGBO(40, 93, 169, 1),
                        foregroundColor : Colors.white,
                      ),
                      onPressed: () => {
                        Navigator.pop(context),
                        showGeneralDialog(
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionBuilder: (context, a1, a2, widget) {
                            return Transform.scale(scale: a1.value,
                              child: Opacity(opacity: a1.value,
                                child: AlertDialog(
                                  backgroundColor: Theme.of(navigatorKey.currentContext!).cardColor,
                                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                                  title: Center(
                                    child: Text('Estamos evaluando a nuestros \nmotoristas, para esto es \nmuy importante tu comentario.',textAlign: TextAlign.center, style:Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium)),
                                  content: TextField(
                                    style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
                                    controller: message,
                                    decoration: InputDecoration(   
                                      hintText: 'Comentario', 
                                      hintStyle: Theme.of(navigatorKey.currentContext!).textTheme.bodySmall!.copyWith(fontSize: 15),
                                    )
                                  ),
                                  actions: [
                                    //SizedBox(width: 60.0),
                                    Center(
                                      child: TextButton(style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Color.fromRGBO(40, 93, 169, 1)),
                                        onPressed: () => {
                                          //fetch skip rating
                                          Navigator.pop(context),
                                          fetchSkipRating2(resp.agentId.toString(), resp1.tripId.toString(), rating1.toInt(), rating2.toInt(), rating3.toInt(), message.text),
                                          
                                        },
                                        child: Text('Enviar', style: TextStyle(fontWeight: FontWeight.bold)),                                                    
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
                          return Text('');}
                        ),
                      },
                      child: Text(
                        'Enviar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                          title: "Estás seguro que deseas omitir la encuesta?",          
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
                        backgroundColor: const Color.fromRGBO(40, 93, 169, 1)),
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
                            type: QuickAlertType.info,
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

  Future<Object?> horas(Size size, BuildContext context, var resp, agentForTravelId, hour) {

    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.6),
        transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOut.transform(a1.value);
        return StatefulBuilder(
          builder: (context, setState){
            return Transform.translate(
              offset: Offset(0.0, (1 - curvedValue) * size.height / 2),
                child: Opacity(
                  opacity: a1.value,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(navigatorKey.currentContext!).cardColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),),),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                          right: 120, left: 120, top: 15, bottom: 20),
                                          child: GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Container(
                                            decoration: BoxDecoration(color: Theme.of(navigatorKey.currentContext!).dividerColor,borderRadius:BorderRadius.circular(80)),height: 6,),
                                ),),
                                SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    'Horas autorizadas',
                                    style: Theme.of(navigatorKey.currentContext!).textTheme.labelMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(height: 30),
                                resp['hours'].length>0?
                                  Column(
                                    children: List.generate(
                                      resp['hours'].length,
                                        (index) {
                                          return Padding(padding: const EdgeInsets.only(bottom: 10),
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async{   
                                                    //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>DetailScreen(plantilla: plantilla[0])),(Route<dynamic> route) => false);           
                                                    
                                                      LoadingIndicatorDialog().show(context);
                                                      var data = {
                                                        'hourToTravelSelected': "${resp['hours'][index]['hourAuthorized']}", 
                                                        'agentForTravelId' : agentForTravelId.toString(), 
                                                        'userAgent': 'mobile'
                                                      };
                                                      print(data);    
                                                      
                                                      http.Response response = await http.post(Uri.parse('https://smtdriver.com/api/postChooseHourToConfirm'), body: data);
                                                      print(response.body);    
                                                      var dataR = json.decode(response.body);
                                                                            
                                                      if(dataR['ok']==true){
                                                        LoadingIndicatorDialog().dismiss();
                                                        Navigator.pop(context);
                                                        Navigator.push(navigatorKey.currentContext!,MaterialPageRoute(builder: (context) => DetailScreen(plantilla: plantilla[0]),));                                                         
                                                      }else{
                                                        LoadingIndicatorDialog().dismiss();
                                                        QuickAlert.show(
                                                          context: navigatorKey.currentContext!,
                                                          title: 'Error al registrar hora',
                                                          text: 'Error',
                                                          type: QuickAlertType.error,
                                                          confirmBtnText: "Ok"
                                                        );
                                                      }
                                                                                                                     
                                                  },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 24,
                                                      height: 24,
                                                      child: SvgPicture.asset(
                                                        "assets/icons/hora.svg",
                                                        color: Theme.of(navigatorKey.currentContext!).primaryIconTheme.color,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Flexible(
                                                      child: 
                                                      
                                                      Text(
                                                        '${resp['hours'][index]['hourAuthorized']}',
                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                                      )
                                                    ),  

                                                    if(hour.toString() == resp['hours'][index]['hourAuthorized'].toString() && hour != null)...{
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 20),
                                                        child: Container(
                                                          width: 24,
                                                          height: 24,
                                                          child: SvgPicture.asset(
                                                            "assets/icons/check.svg",
                                                            color: Color.fromRGBO(40, 169, 83, 1),
                                                          ),
                                                        ),
                                                      ),                                            
                                                    },
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                height: 1,
                                                color: Theme.of(navigatorKey.currentContext!).dividerColor,
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    ),
                                    )
                                    : 
                                    Center(
                                      child: Text(
                                        'No tiene direcciones disponibles.',
                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                      ),
                                    ),
                                                              
                                    SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                    }
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
  }

  Future<Object?> direcciones(Size size, BuildContext context, var resp) {
  
    if( resp['res'].length>0){
      for (int i = 0; i < resp['res'].length; i++) {
        if (resp['res'][i]['isChosen'] == true) {
          indexWithIsChosenTrue = i;
          break; // Termina el bucle una vez que se encuentra el elemento deseado
        }
      }
    }

    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.6),
        transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOut.transform(a1.value);
        return StatefulBuilder(
          builder: (context, setState){
            return Transform.translate(
              offset: Offset(0.0, (1 - curvedValue) * size.height / 2),
                child: Opacity(
                  opacity: a1.value,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(navigatorKey.currentContext!).cardColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),),),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                          right: 120, left: 120, top: 15, bottom: 20),
                                          child: GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Container(
                                            decoration: BoxDecoration(color: Theme.of(navigatorKey.currentContext!).dividerColor,borderRadius:BorderRadius.circular(80)),height: 6,),
                                ),),
                                SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    'Tus direcciones',
                                    style: Theme.of(navigatorKey.currentContext!).textTheme.labelMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(height: 30),
                                resp['res'].length>0?
                                  Column(
                                    children: List.generate(
                                      resp['res'].length,
                                        (index) {
                                          return Padding(padding: const EdgeInsets.only(bottom: 10),
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async{              
                                                    if(index!=indexWithIsChosenTrue){
                                                      LoadingIndicatorDialog().show(context);
                                                      var data = {
                                                        'agentLocationId': resp['res'][index]['agentLocationId'].toString(), 
                                                        'userId' : resp['res'][index]['agentId'].toString(), 
                                                        'userAgent': 'mobile'
                                                      };
                                                                
                                                      http.Response response = await http.post(Uri.parse('https://admin.smtdriver.com/chooseLocationAgent'), body: data);
                                                                
                                                      var dataR = json.decode(response.body);
                                                                            
                                                      if(dataR['ok']==true){
                                                        LoadingIndicatorDialog().dismiss();
                                                          setState(() {
                                                            resp['res'][indexWithIsChosenTrue]['isChosen']=false;
                                                            resp['res'][index]['isChosen']=true;
                                            
                                                            indexWithIsChosenTrue = index;                                                                                                                                         
                                                          });
                                                                
                                                          QuickAlert.show(
                                                            context: navigatorKey.currentContext!,
                                                            title: dataR['message'].toString(),
                                                            text: dataR['db'][0]['msg'].toString(),
                                                            type: QuickAlertType.success,
                                                            confirmBtnText: "Ok"
                                                          );
                                                      }else{
                                                        LoadingIndicatorDialog().dismiss();
                                                        QuickAlert.show(
                                                          context: navigatorKey.currentContext!,
                                                          title: dataR['message'].toString(),
                                                          text: dataR['db'][0]['msg'].toString(),
                                                          type: QuickAlertType.error,
                                                          confirmBtnText: "Ok"
                                                        );
                                                      }
                                                    }                                                                    
                                                  },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 24,
                                                      height: 24,
                                                      child: SvgPicture.asset(
                                                        "assets/icons/accesoautorizado.svg",
                                                        color: Theme.of(navigatorKey.currentContext!).primaryIconTheme.color,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Flexible(
                                                      child: 
                                                      resp['res'][index]['neighborhoodReferencePoint']!=null?
                                                      Text(
                                                        '${resp['res'][index]['neighborhoodName']}, ${resp['res'][index]['neighborhoodReferencePoint']}, ${resp['res'][index]['townName']}',
                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                                      ):Text(
                                                        '${resp['res'][index]['neighborhoodName']}, ${resp['res'][index]['townName']}',
                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 20),
                                                      child: Container(
                                                        width: 24,
                                                        height: 24,
                                                        child: SvgPicture.asset(
                                                          "assets/icons/check.svg",
                                                          color: resp['res'][index]['isChosen']==true? Color.fromRGBO(40, 169, 83, 1): Colors.transparent,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                height: 1,
                                                color: Theme.of(navigatorKey.currentContext!).dividerColor,
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    ),
                                    )
                                    : 
                                    Center(
                                      child: Text(
                                        'No tiene direcciones disponibles.',
                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                      ),
                                    ),
                                                              
                                    SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                    }
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
  }

  Future<Object?> direcciones2(Size size, BuildContext context, resp2, agentForTravelId, direccionChosen, text, flag) {
    //print(direccionChosen);

    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.6),
        transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOut.transform(a1.value);
        return StatefulBuilder(
          builder: (context, setState){
            return Transform.translate(
              offset: Offset(0.0, (1 - curvedValue) * size.height / 2),
                child: Opacity(
                  opacity: a1.value,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(navigatorKey.currentContext!).cardColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),),),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                          right: 120, left: 120, top: 15, bottom: 20),
                                          child: GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Container(
                                            decoration: BoxDecoration(color: Theme.of(navigatorKey.currentContext!).dividerColor,borderRadius:BorderRadius.circular(80)),height: 6,),
                                ),),
                                SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    text,
                                    style: Theme.of(navigatorKey.currentContext!).textTheme.labelMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(height: 30),
                                resp2.length>0?
                                  Column(
                                    children: List.generate(
                                      resp2.length,
                                        (index) {
                                          return Padding(padding: const EdgeInsets.only(bottom: 10),
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async{              
                                                   
                                                      if (flag==1) {
                                                        var data = {
                                                          'neighborhoodId': resp2[index]['neighborhoodId'].toString(), 
                                                          'agentForTravelId' : agentForTravelId.toString(), 
                                                          'userAgent': 'mobile'
                                                        };
                                                       // print(data);
                                                        http.Response response = await http.post(Uri.parse('https://smtdriver.com/api/chooseLocationStartek'), body: data);
                                                                  
                                                        var dataR = json.decode(response.body);
                                                                              
                                                        if(dataR['ok']==true){ 
                                                                                                                                                                             
                                                        }else{
                                                          //LoadingIndicatorDialog().dismiss();                                                        
                                                          QuickAlert.show(
                                                            context: navigatorKey.currentContext!,
                                                            title: dataR['message'].toString(),
                                                            text: dataR['db'][0]['msg'].toString(),
                                                            type: QuickAlertType.error,
                                                            confirmBtnText: "Ok"
                                                          );
                                                        }   
                                                        final ConfirmationLoadingDialog loadingDialog = ConfirmationLoadingDialog();
                                                        ConfirmationDialog confirmationDialog = ConfirmationDialog();
                                                        confirmationDialog.show(
                                                          context,
                                                          title: '¿Deseas confirmar la solicitud?',
                                                          type: "0",
                                                          onConfirm: () async {                              
                                                            loadingDialog.show(navigatorKey.currentContext!,);

                                                            Map data = {
                                                              "agentForTravelId": agentForTravelId.toString(),
                                                              "confirmation": "1",
                                                              "agentComment": "null",
                                                            };

                                                            http.Response response = await http.post(Uri.parse('https://smtdriver.com/api/transportation/confirm'), body: data);
                                                            //print(response.body);

                                                            var dataR = json.decode(response.body);
                                                              if (mounted) {                                                                
                                                                if (dataR["ok"] == true) {                                                              
                                                                  loadingDialog.dismiss();
                                                                  confirmationDialog.dismiss();
                                                                  setState(() {
                                                                    item2 = getSolicitudes();
                                                                  });
                                                                  Navigator.pop(context);                                                            
                                                                  Future.delayed(const Duration(seconds: 2), () async {                                                                      
                                                                    QuickAlert.show(
                                                                      context: navigatorKey.currentContext!,
                                                                      title: "Enviado",
                                                                      text: dataR["message"],
                                                                      type: QuickAlertType.success,
                                                                      confirmBtnText: "Ok"
                                                                    );
                                                                  });
                                                                } else {
                                                                  loadingDialog.dismiss();
                                                                  confirmationDialog.dismiss();
                                                                  QuickAlert.show(
                                                                    context: navigatorKey.currentContext!,
                                                                    title: "Error",
                                                                    text: dataR["message"],
                                                                    type: QuickAlertType.error,
                                                                    confirmBtnText: "Ok"
                                                                  );
                                                                }
                                                              }
                                                            
                                                          },
                                                          onCancel: () {

                                                          },
                                                        );
                                                      }else{
                                                        var data = {
                                                          'neighborhoodId': resp2[index]['neighborhoodId'].toString(), 
                                                          'agentForTravelId' : agentForTravelId.toString(), 
                                                          'userAgent': 'mobile'
                                                        };
                                                        //print(data);
                                                        http.Response response = await http.post(Uri.parse('https://smtdriver.com/api/chooseLocationStartek'), body: data);
                                                                  
                                                        var dataR = json.decode(response.body);
                                                                              
                                                        if(dataR['ok']==true){
                                                            //LoadingIndicatorDialog().dismiss();
                                                            
                                                                  
                                                            setState(() {
                                                              item2 = getSolicitudes();
                                                            });
                                                            Navigator.pop(context);
                                                            QuickAlert.show(
                                                              context: navigatorKey.currentContext!,
                                                              title: 'Guardado',
                                                              text: 'Se guardó correctamente',
                                                              type: QuickAlertType.success,
                                                              confirmBtnText: "Ok",                                                                                                                       
                                                            );                                                                                                 
                                                            
                                                        }else{
                                                          //LoadingIndicatorDialog().dismiss();                                                        
                                                          QuickAlert.show(
                                                            context: navigatorKey.currentContext!,
                                                            title: dataR['message'].toString(),
                                                            text: dataR['db'][0]['msg'].toString(),
                                                            type: QuickAlertType.error,
                                                            confirmBtnText: "Ok"
                                                          );
                                                        }                                                                                                                       
                                                      }
                                                  },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 24,
                                                      height: 24,
                                                      child: SvgPicture.asset(
                                                        "assets/icons/accesoautorizado.svg",
                                                        color: Theme.of(navigatorKey.currentContext!).primaryIconTheme.color,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Flexible(
                                                      child:                                 
                                                      Text(
                                                        '${resp2[index]['direction']}',
                                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 20),
                                                      child: Container(
                                                        width: 24,
                                                        height: 24,
                                                        child: SvgPicture.asset(
                                                          "assets/icons/check.svg",
                                                          color: direccionChosen == resp2[index]['direction']? Color.fromRGBO(40, 169, 83, 1): Colors.transparent,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                height: 1,
                                                color: Theme.of(navigatorKey.currentContext!).dividerColor,
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    ),
                                    )
                                    : 
                                    Center(
                                      child: Text(
                                        'No tiene direcciones disponibles.',
                                        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                      ),
                                    ),
                                                              
                                    SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                    }
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
}
}
