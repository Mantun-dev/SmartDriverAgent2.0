// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen_history.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/components/item_card.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/components/rateMyDriver.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/mask.dart';
import 'package:flutter_auth/Agents/models/messageCount.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/helpers/loggers.dart';
import 'package:flutter_auth/helpers/res_apis.dart';
import 'package:flutter_auth/providers/device_info.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quickalert/quickalert.dart';
// import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import 'package:url_launcher/url_launcher.dart';

import '../../../../helpers/base_client.dart';
import '../../Chat/listchats.dart';
import '../../Details/details_screen_changes.dart';
import '../../Details/details_screen_qr.dart';
import '../../Notifications/notification.dart';
import '../../Profile/profile_screen.dart';

class Body extends StatefulWidget {
  //declaración de la clase data agen y su variable item
  final DataAgent? item;

  const Body({Key? key, this.item}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //variables globales para HomeAgents
  int? _value;
  Future<DataAgent>? item;
  final prefs = new PreferenciasUsuario();
  String ip = "https://smtdriver.com";
  String ip2 = "https://admin.smtdriver.com";
  String? msgtoShow;
  int? display;
  Future<List<dynamic>>? historial;
  bool isMenuOpen = false;
  TextEditingController buscarText = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool cargarM = false;
  List<dynamic>? ventanas;

BuildContext? contextP;

  List<dynamic>? ventanas2;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  //variables y funciones que necesitan inialización
  @override
  void initState() {
    super.initState();
    _value = 0;
    _focusNode.addListener(_onFocusChange);
    contextP=context;
    //realización callback para mostrar cuentas en agentes
    saveDeviceId();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          this._showErrorAlert();
        });
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          this._showAlert();
        });
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          this._showAlertToMessage();
        });
      }
    });

    
    //callback
    _initPackageInfo();
    getMessage();

    item = fetchRefres();
    historial = getLast5();

    if(prefs.companyId!='7'){
      ventanas=[
        {
          'nombre': 'Próximos viajes',
          'icono': 'assets/icons/proximo_viaje.svg',
          'ruta': 0,
        },
        {
          'nombre': 'Historial de viajes',
          'icono': 'assets/icons/historial_de_viaje.svg',
          'ruta': 1,
        },
        {
          'nombre': 'Generar código QR',
          'icono': 'assets/icons/QR.svg',
          'ruta': 2,
        },
        {
          'nombre': 'Solicitud de cambios',
          'icono': 'assets/icons/solicitud_de_cambio.svg',
          'ruta': 3,
        },
        {
          'nombre': 'Notificaciones',
          'icono': 'assets/icons/notificacion.svg',
          'ruta': 4,
        },
        {
          'nombre': 'Chats',
          'icono': 'assets/icons/chats.svg',
          'ruta': 5,
        },
        {
          'nombre': 'Perfil',
          'icono': 'assets/icons/usuario2.svg',
          'ruta': 6,
        },
      ];
    }else{
      ventanas=[
        {
          'nombre': 'Próximos viajes',
          'icono': 'assets/icons/proximo_viaje.svg',
          'ruta': 0,
        },
        {
          'nombre': 'Historial de viajes',
          'icono': 'assets/icons/historial_de_viaje.svg',
          'ruta': 1,
        },
        {
          'nombre': 'Generar código QR',
          'icono': 'assets/icons/QR.svg',
          'ruta': 2,
        },
        {
          'nombre': 'Notificaciones',
          'icono': 'assets/icons/notificacion.svg',
          'ruta': 4,
        },
        {
          'nombre': 'Chats',
          'icono': 'assets/icons/chats.svg',
          'ruta': 5,
        },
        {
          'nombre': 'Perfil',
          'icono': 'assets/icons/usuario2.svg',
          'ruta': 6,
        },
      ];
    }
    ventanas2=ventanas;
  }


  void saveDeviceId()async{
    String ip = "https://smtdriver.com";
    http.Response responses = await http.get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final data = DataAgent.fromJson(json.decode(responses.body));
    String? deviceId = await getDeviceId();
    Map<String, dynamic> body = {'agentId': data.agentId.toString(), 'deviceId': deviceId.toString() , 'deviceOS': 'Android'};
    logger.d(body);
    var res = await BaseClient().post(RestApis.registerDevice, body, {"Content-Type": "application/json"});  
    print(res);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // TextField está en foco
      isMenuOpen=true;
    } else {
      // TextField ya no está en foco
      isMenuOpen=false;
    }
    setState(() { });
  }

  Container menu(size, contextP) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: ventanas2!.asMap().entries.map((entry) {
              dynamic ventana = entry.value;
              String nombre = ventana['nombre'];
              String icono = ventana['icono'];
              int index = ventana['ruta'];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: GestureDetector(
                  onTap: () {
                    rutas(index);
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 25,
                            height: 25,
                            child: SvgPicture.asset(
                              icono,
                              color: Theme.of(context).primaryIconTheme.color,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            nombre,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 15, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      SizedBox(height: 12)
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void rutas(int i){
    switch (i) {
      case 0:
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
            pageBuilder: (_, __, ___) => DetailScreen(plantilla: plantilla[0]),
            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );                                    
        break;
      case 1:
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
            pageBuilder: (_, __, ___) => DetailScreenHistoryTrip(plantilla: plantilla[1]),
            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );  
        break;
      case 2:
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
            pageBuilder: (_, __, ___) => DetailScreen(plantilla: plantilla[2]),
            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ); 
        break;
      case 3:
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
            pageBuilder: (_, __, ___) => DetailScreen(plantilla: plantilla[3]),
            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ); 
        break;
      case 4:
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
            pageBuilder: (_, __, ___) => NotificationPage(),
            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ); 
        break;
      case 5:
        fetchProfile().then((value) {
          Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
            pageBuilder: (_, __, ___) => ChatsList(id: '${value.agentId}',rol: 'agente',nombre: '${value.agentFullname}'),
            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ); 
        });
        break;
      case 6:
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
            pageBuilder: (_, __, ___) => ProfilePage(),
            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ); 
        break;
    }
  }

  Future<List<dynamic>> getLast5() async {
    Map data = {
        "agentUser": prefs.nombreUsuario,
        "getTopFive": 1.toString() 
    };
    http.Response response =
        await http.post(Uri.parse('$ip/api/history'), body: data);

    if (response.statusCode == 200) {
      final trip = json.decode(response.body);

      return trip;
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
      prefs.versionOld = _packageInfo.version;
    });
  }

  _launchURL() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.smartdriver.devs';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  showAlertVersion() async {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
              transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
              child: Opacity(
                  opacity: a1.value,
                  child: AlertDialog(
                    content: Container(
                      width: 400,
                      height: 140,
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.warning,
                              color: Colors.orangeAccent, size: 35.0),
                          SizedBox(height: 10),
                          Text(
                            'Actualización disponible',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.orange),
                                onPressed: () => {
                                  Navigator.pop(context),
                                },
                                child: Text('Después'),
                              ),
                              Column(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.green),
                                    onPressed: () => {
                                      Navigator.pop(context),
                                      _launchURL(),
                                    },
                                    child: Text('Descargar'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )));
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return widget;
        });
  }

//función fetch para enviar la cuenta seleccionada
  Future<dynamic> fetchCountSend(String agentId, String countId) async {
    Map data = {'agentId': agentId, 'countId': countId};
    //apis para send Count
    http.Response responses = await http
        .get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final si = DataAgent.fromJson(json.decode(responses.body));
    http.Response response =
        await http.get(Uri.parse('$ip/api/getCounts/${si.companyId}'));
    Map<String, dynamic>.from(json.decode(response.body));
    http.Response respons =
        await http.post(Uri.parse('$ip/api/registerCount'), body: data);
    //alertas
    final yep = MessageAccount.fromJson(json.decode(respons.body));
    if (yep.ok == true && respons.statusCode == 200 && countId == '0') {
      QuickAlert.show(
        context: context,
          title: 'Cuentas',
          text: ' No has seleccionado una cuenta valida\n si no deseas hacerlo presione cancelar.',
          type: QuickAlertType.error,
          confirmBtnText: "Ok");
    } else if (yep.ok == true && respons.statusCode == 200) {
      QuickAlert.show(
        context: context,
          title: yep.title,
          text: yep.message,
          type: QuickAlertType.success,
          confirmBtnText: "Ok");
    }
    return Map<String, dynamic>.from(json.decode(response.body));
  }


  getMessage()async{
    http.Response responses = await http.get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final si = DataAgent.fromJson(json.decode(responses.body));
    Map data = {'agentId': si.agentId.toString()};
    http.Response responses2 = await http.post(Uri.parse('$ip2/agents/warning/transportation'), body: data);    
    var msg = json.decode(responses2.body);
    if (mounted) {      
      setState(() { 
        cargarM = true;           
        msgtoShow = msg['msg'];
        display = msg['display'];    
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    RateMyApp();
    return GestureDetector(
      onTap: () {
        setState(() {
          _focusNode.unfocus();
        });
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 700.0, // Aquí defines el ancho máximo deseado
        ),
        child: Container(
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Text(
                    'Hola, ${prefs.nombreUsuarioFull}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
          
                SizedBox(height: 25),      
          
                ventanas2!=null?
                Padding(
                  padding: const EdgeInsets.only(right: 12, left: 12),
                  child: Stack(
                    children: [
                      if(isMenuOpen==true && ventanas2!.length>0)
                        Padding(
                          padding: const EdgeInsets.only(top:40.0),
                          child: menu(size, context),
                        ),
    
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            width: 2,
                            color: Theme.of(context).disabledColor
                          )
                        ),
                        child: TextField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          controller: buscarText,
                          onChanged: (value) {

                            if(value.isEmpty)
                              ventanas2=ventanas;
                            else
                              ventanas2=ventanas!.where((ventana) {
                                String nombre = ventana['nombre'].toString().toLowerCase();
                                return nombre.contains(value.toLowerCase());
                              }).toList();

                            setState(() {});
                          },
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryIconTheme.color),
                            hintText: 'Buscar',
                            hintStyle: TextStyle(
                              color: Theme.of(context).hintColor, fontSize: 15, fontFamily: 'Roboto'
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ):Text(''),
                
          
                SizedBox(height: 15),            
                if (display == 1)... {                        
                  Padding(
                    padding: const EdgeInsets.fromLTRB(27, 0, 27, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Theme.of(context).disabledColor,
                          width: 2
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.warning,
                              color: Colors.orangeAccent,
                            ),
                            SizedBox(width: 10), // Espacio entre el icono y el texto
                            Expanded( // Usar Expanded para que el texto tome el espacio disponible
                              child: Text(
                                '$msgtoShow',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15)
                },
                if(cargarM == false)...{

                  WillPopScope(
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
                                    'Cargando ...', 
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                    ),
                                )
                              ],
                            ),
                          )
                        ] ,
                      ),
                    ),

                  SizedBox(height: 15)
                },                                    
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(27, 0, 27, 0),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: backgroundColor2,
                //       borderRadius: BorderRadius.circular(15)
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.all(10.0),
                //       child: Text('Tiene viaje(s) donde confirmó y no salió a tomar el transporte. Si esto ocurre por 3ra vez, el sistema le dará de baja y no será agendado para el servicio de transporte. Deberá justificar el caso enviando un ticket solicitando el uso de transporte.',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                //     ),
                //   ),
                // ),
                
                //future builder para hacer la validación que aparezcan 3 o las 4 cards
                // las que necesarias a mostrar
                FutureBuilder<DataAgent>(
                future: item,
                builder: (BuildContext context, abc) {
                  if (abc.connectionState == ConnectionState.done) {
                    //validación
                    if (abc.data!.companyId != 7) {
                      return GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        //todas las cards
                        children: List.generate(plantilla.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0, left: 8, bottom: 8),
                            child: ItemCard(
                              plantilla: plantilla[index],
                              press: () {
                                setState(() {
                                  if (plantilla[index] == plantilla[0]) {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
                                        pageBuilder: (_, __, ___) => DetailScreen(plantilla: plantilla[index]),
                                        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: Offset(1.0, 0.0),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  } else if (plantilla[index] == plantilla[1]) {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
                                        pageBuilder: (_, __, ___) => DetailScreenHistoryTrip(plantilla: plantilla[index]),
                                        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: Offset(1.0, 0.0),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  } else if (plantilla[index] == plantilla[2]) {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
                                        pageBuilder: (_, __, ___) => DetailScreenQr(plantilla: plantilla[index]),
                                        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: Offset(1.0, 0.0),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  } else if (plantilla[index] == plantilla[3]) {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
                                        pageBuilder: (_, __, ___) => DetailScreenChanges(plantilla: plantilla[index]),
                                        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: Offset(1.0, 0.0),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  }
                                });
                              },
                            ),
                          );
                        }),
                      );
                    } else {
                      return Column(
                        children: [
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            //todas las cards
                            physics: NeverScrollableScrollPhysics(),
                            children: List.generate(2, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0, left: 8, bottom: 8),
                                child: ItemCard(
                                  plantilla: plantilla[index],
                                  press: () {
                                    setState(() {
                                      if (plantilla[index] == plantilla[0]) {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
                                            pageBuilder: (_, __, ___) => DetailScreen(plantilla: plantilla[index]),
                                            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                              return SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: Offset(1.0, 0.0),
                                                  end: Offset.zero,
                                                ).animate(animation),
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      } else if (plantilla[index] == plantilla[1]) {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
                                            pageBuilder: (_, __, ___) => DetailScreenHistoryTrip(plantilla: plantilla[index]),
                                            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                              return SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: Offset(1.0, 0.0),
                                                  end: Offset.zero,
                                                ).animate(animation),
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    });
                                  },
                                ),
                              );
                            }),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0, left: 8, bottom: 8),
                              child: ItemCard(
                                plantilla: plantilla[2],
                                press: () {
                                  Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
                                            pageBuilder: (_, __, ___) => DetailScreenQr(plantilla: plantilla[2]),
                                            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                              return SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: Offset(1.0, 0.0),
                                                  end: Offset.zero,
                                                ).animate(animation),
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
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
                                    'Cargando menú...', 
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
                },
              ),
        
                FutureBuilder(
                  future: historial,
                  builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.hasData) {
                      List<dynamic> plantilla2 = snapshot.data!;
                        return Column(
                          children: [
                            if(snapshot.data!.length>0)
                              SizedBox(height: 50),
        
                            if(snapshot.data!.length>0)
                            Padding(
                              padding: const EdgeInsets.only(right: 25.0, left: 25, bottom: 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Últimos viajes',
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                     Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
                                        pageBuilder: (_, __, ___) => DetailScreenHistoryTrip(plantilla: plantilla[1]),
                                        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: Offset(1.0, 0.0),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                    },
                                    child: Text(
                                      'Ver historial',
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
        
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(plantilla2.length, (index) {
                                var trip = plantilla2[index];
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                width: 2,
                                                color: Theme.of(context).disabledColor
                                              )
                                            ),
                                    child: Container(
                                      width: 240,
                                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 5),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 15,
                                                  height: 15,
                                                  child: SvgPicture.asset(
                                                    "assets/icons/Numeral.svg",
                                                    color: Theme.of(context).primaryIconTheme.color,
                                                  ),
                                                ),
                                                Text(
                                                  ' Viaje: ${trip["tripId"]}',
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 1,
                                            color: Theme.of(context).dividerColor,
                                          ),
                                          SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  child: SvgPicture.asset(
                                                    "assets/icons/calendar-note-svgrepo-com.svg",
                                                    color: Theme.of(context).primaryIconTheme.color,
                                                  ),
                                                ),
                                                Text(
                                                  ' Fecha: ${trip["tripDate"]}',
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 1,
                                            color: Theme.of(context).dividerColor,
                                          ),
                                          SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  child: SvgPicture.asset(
                                                    "assets/icons/warning-circle-svgrepo-com.svg",
                                                    color: Theme.of(context).primaryIconTheme.color,
                                                  ),
                                                ),
                                                Text(
                                                  ' Tipo: ${trip["tripType"]}',
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 1,
                                            color: Theme.of(context).dividerColor,
                                          ),
                                          SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 15,
                                                  height: 15,
                                                  child: SvgPicture.asset(
                                                    "assets/icons/hora.svg",
                                                    color: Theme.of(context).primaryIconTheme.color,
                                                  ),
                                                ),
                                                Text(
                                                  ' Abordó: ${trip["traveled"]}',
                                                  style:  Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 1,
                                            color: Theme.of(context).dividerColor,
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('');
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
                                    'Cargando últimos viajes...', 
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
                  },
                ),
        
          
              ],
            ),
          ),
        ),
      ),
    );
  }

//función onChanged para el valor de la cuenta
  void onChanged(dynamic value) async {
    setState(() {
      _value = value;
    });
  }

// función hace la validación de mostrar alerta
  void _showErrorAlert() async {
    http.Response responses = await http
        .get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final si = DataAgent.fromJson(json.decode(responses.body));
    http.Response response =
        await http.get(Uri.parse('$ip/api/getCounts/${si.companyId}'));
    Map<String, dynamic> no =
        new Map<String, dynamic>.from(json.decode(response.body));
    //print(no['counts'].length);
    //aquí se hace la validación de mostra cuando sea null el countId
    if (no['counts'].length == 0 || no['counts'].length == null) {
    } else {
      if (si.countId == null) {
        
      }
    }
  }

//función de creación de alerta para mostrar cuentas de agente
  showAlertDialog() async {
    //apis de manera directa para obtener la data
    http.Response responses = await http
        .get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final si = DataAgent.fromJson(json.decode(responses.body));
    http.Response response =
        await http.get(Uri.parse('$ip/api/getCounts/${si.companyId}'));
    Map<String, dynamic> no =
        new Map<String, dynamic>.from(json.decode(response.body));
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                backgroundColor: Theme.of(contextP!).cardColor,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Center(child: Text('¿A qué cuenta pertenece?', style: Theme.of(contextP!).textTheme.titleMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.bold),)),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: 200,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        //iteración de cuentas, muestra cada una de ellas con su valor
                        for (int i = 0; i < no['counts'].length; i++) ...{
                          ListTile(
                            title: Text(
                              '${no['counts'][i]['countName']}',
                              style: Theme.of(contextP!).textTheme.bodyMedium!.copyWith(fontSize: 18),
                            ),
                            leading: Radio<dynamic>(
                              value: no['counts'][i]['countId'],
                              groupValue: _value,
                              activeColor: Theme.of(contextP!).focusColor,
                              onChanged: i == no['counts'].length
                                  ? null
                                  : (value) {
                                      setState(() {
                                        onChanged(value);
                                        //print(value);
                                      });
                                    },
                            ),
                          ),
                        },
                      ]),
                    ),
                  );
                }),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 63, 148, 66),
                    ),
                    onPressed: () => {
                      setState(() {
                        //función fetch send count
                        fetchCountSend(
                            si.agentId.toString(), _value.toString());
                        Navigator.pop(context);
                      }),
                    },
                    child: Text('Enviar'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromRGBO(40, 93, 169, 1)),
                    onPressed: () => {
                      Navigator.pop(context),
                    },
                    child: Text('Cerrar'),
                  ),
                  SizedBox(width: 55.0),
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

  //mostra y validaciones de para alert mask
  _showAlertToMessage() async {
    http.Response responses = await http.get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final resp = DataAgent.fromJson(json.decode(responses.body));
    http.Response response = await http.get(Uri.parse('$ip/api/getMaskReminder/${resp.agentId}'));
  
    dynamic parsedJson = json.decode(response.body);
    var resp1 = (parsedJson as List<dynamic>).map((job) => Mask.fromJson(job)).toList();   

    // if (resp1[0].showMsg == 1) {
    //   showAlertDialogToMessage(resp1[0].title, resp1[0].msgText, resp1[0].agentId, resp1[0].msgTypeId);
    // }
  }

  showAlertDialogToMessage(title, msgText, agentId, msgTypeId) async {
    showDialog(      
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(            
              content: Container(
                width: 400,
                height: 300,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15),
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Text(
                        msgText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromRGBO(40, 93, 169, 1)),
                      onPressed: () async => {
                        await http.get(Uri.parse('$ip/api/markAsViewedMaskReminder/$agentId/$msgTypeId')),
                        Navigator.pop(context),
                        
                      },
                      child: Text('Entendido'),
                    ),
                  ],
                ),
              ),
            ));
  }

  void _showAlert() async {
    http.Response responses = await http
        .get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final si = DataAgent.fromJson(json.decode(responses.body));

    if (si.agentStatus == false) {
      showAlertDialogMessage();
    }
  }

  //función de creación de alerta para mostrar cuentas de agente
  showAlertDialogMessage() {
    //apis de manera directa para obtener la data
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                backgroundColor: Theme.of(contextP!).cardColor,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Center(
                  child: Text("🔺¡Usuario no agendado!🔺" ,
                      style: Theme.of(contextP!).textTheme.titleMedium!.copyWith(fontSize: 18)
                    ),
                ),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: 120,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        SizedBox(height: 5),
                        Text('No estás siendo agendado para el servicio de transporte, debes comunicarte con tu supervisor.',style: Theme.of(contextP!).textTheme.bodyMedium!.copyWith(fontSize: 15)),
                      ]),
                    ),
                  );
                }),
                actions: <Widget>[
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 63, 148, 66),
                      ),
                      onPressed: () => {
                        setState(() {
                          Navigator.pop(context);
                        }),
                      },
                      child: Text('Entendido'),
                    ),
                  ),
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
}
