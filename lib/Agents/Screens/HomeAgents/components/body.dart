// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen_history.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/components/item_card.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/components/rateMyDriver.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/messageCount.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/constants.dart';
import 'package:quickalert/quickalert.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import 'package:url_launcher/url_launcher.dart';

import '../../Details/details_screen_changes.dart';
import '../../Details/details_screen_qr.dart';

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
    //realización callback para mostrar cuentas en agentes

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
    //callback
    _initPackageInfo();
    getMessage();

    item = fetchRefres();
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
          text: ' No ha seleccionado una cuenta valida\n si no desea hacerlo presione cancelar.',
          type: QuickAlertType.error);
    } else if (yep.ok == true && respons.statusCode == 200) {
      QuickAlert.show(
        context: context,
          title: yep.title,
          text: yep.message,
          type: QuickAlertType.success);
    }
    return Map<String, dynamic>.from(json.decode(response.body));
  }


  getMessage()async{
    http.Response responses = await http.get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final si = DataAgent.fromJson(json.decode(responses.body));
    Map data = {'agentId': si.agentId.toString()};
    http.Response responses2 = await http.post(Uri.parse('$ip2/agents/warning/transportation'), body: data);    
    var msg = json.decode(responses2.body);
    setState(() {            
      msgtoShow = msg['msg'];
      display = msg['display'];    
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    RateMyApp();
    return Center(
      child: Container(
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'SMART DRIVER',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.w400, color: firstColor),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<DataAgent>(
              future: item,
              builder: (BuildContext context, abc) {
                  if (abc.connectionState == ConnectionState.done) {
                    if (abc.data!.companyId == 2 || abc.data!.companyId == 3 || abc.data!.companyId == 1) {
                      if (display == 1) {                        
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(27, 0, 27, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: backgroundColor2,
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('🔺$msgtoShow 🔺',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                            ),
                          ),
                        );
                      }else{
                        return Text("");
                      }
                    }else{
                      return Text("");
                    }
                  }else{
                    return CircularProgressIndicator();
                  }
                }
              ),
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
                    return Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        //todas las cards
                        itemCount: plantilla.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: 180,
                        ),
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: ItemCard(
                              plantilla: plantilla[index],
                              press: () {
                                setState(() {
                                  if (plantilla[index] == plantilla[0]) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return DetailScreen(
                                          plantilla: plantilla[index]);
                                    }));
                                  } else if (plantilla[index] == plantilla[1]) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return DetailScreenHistoryTrip(
                                            plantilla: plantilla[index]);
                                      }),
                                    );
                                  } else if (plantilla[index] == plantilla[2]) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return DetailScreenQr(
                                            plantilla: plantilla[index]);
                                      }),
                                    );
                                  } else if (plantilla[index] == plantilla[3]) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return DetailScreenChanges(
                                            plantilla: plantilla[index]);
                                      }),
                                    );
                                  }
                                });
                              }),
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        //todas las cards
                        itemCount: 3,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: 180,                          
                        ),
                        itemBuilder: (context, index) => ItemCard(
                            plantilla: plantilla[index],
                            press: () {
                              setState(() {
                                if (plantilla[index] == plantilla[0]) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return DetailScreen(
                                        plantilla: plantilla[0]);
                                  }));
                                } else if (plantilla[index] == plantilla[1]) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return DetailScreenHistoryTrip(
                                        plantilla: plantilla[1]);
                                  }));
                                }else if (plantilla[index] == plantilla[2]) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return DetailScreenQr(
                                        plantilla: plantilla[2]);
                                  }));
                                }
                              });
                            }),
                      ),
                    );
                  }
                } else {
                  return Text('');
                }
              },
            ),
          ],
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
        showAlertDialog();
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
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Center(child: Text('¿A qué cuenta pertenece?')),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      color: i == no['counts'].length
                                          ? Colors.black38
                                          : Colors.black),
                            ),
                            leading: Radio<dynamic>(
                              value: no['counts'][i]['countId'],
                              groupValue: _value,
                              activeColor: Colors.blue,
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
                      backgroundColor: Colors.green,
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
                        backgroundColor: Colors.blueAccent),
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
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Center(
                  child: Text("🔺¡Usuario no agendado!🔺",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kCardColor2,
                      )),
                ),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: 120,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        SizedBox(height: 5),
                        Text('Usted no está siendo agendado para el servicio de transporte, debe comunicarse con su supervisor.',style: TextStyle(color: kgray)),
                      ]),
                    ),
                  );
                }),
                actions: <Widget>[
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
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
