// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/historyTicket.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/loader.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/models/dataAgentMessage.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/constants.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:sweetalert/sweetalert.dart';

import '../../../../components/rounded_button.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({Key? key, Plantilla? plantilla}) : super(key: key);

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  void initState() {
    super.initState();
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
    //declaración de variables
    final prefs = new PreferenciasUsuario();
    TextEditingController ticketIssue = new TextEditingController();
    TextEditingController ticketMessage = new TextEditingController();

    //función envío de ticket
    Future<dynamic> fetchTicket(
        String agentUser, String ticketIssue, String ticketMessage) async {
      //<List<Map<String,dynamic>>>
      String ip = "https://smtdriver.com";
      Map data = {
        'agentUser': agentUser,
        'ticketIssue': ticketIssue,
        'ticketMessage': ticketMessage
      };

      //api envio de ticket
      http.Response response =
          await http.post(Uri.parse('$ip/api/tickets'), body: data);
      final no = DataAgents.fromJson(json.decode(response.body));
      //alertas
      if (response.statusCode == 200 && no.ok == true) {
        Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeScreen()))
            .then((_) => TicketScreen());
        SweetAlert.show(context,
            title: "Ticket enviado",
            subtitle: no.message,
            style: SweetAlertStyle.success);
      } else if (no.ok != true) {
        SweetAlert.show(
          context,
          title: "Alerta",
          subtitle: no.message,
          style: SweetAlertStyle.error,
        );
      }
      return DataAgents.fromJson(json.decode(response.body));
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                blurStyle: BlurStyle.normal,
                color: Colors.white.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: -13,
                offset: Offset(-15, -5)),
            BoxShadow(
                blurStyle: BlurStyle.normal,
                color: Colors.black.withOpacity(0.6),
                blurRadius: 18,
                spreadRadius: -15,
                offset: Offset(18, 5)),
          ], borderRadius: BorderRadius.circular(15)),
          child: RoundedButton(
            text: "Tickets anteriores",
            color: backgroundColor,
            textColor: thirdColor,
            press: () => {
              Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => HistoryTicketScreen()))
                  .then((_) => HomeScreen()),
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                blurStyle: BlurStyle.normal,
                color: Colors.white.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: -13,
                offset: Offset(-15, 0)),
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
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              elevation: 10,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                height: 410,
                width: 300,
                child: Column(children: [
                  SizedBox(height: 20),
                  Text('Envie su solicitud cambio:',
                      style: TextStyle(
                          color: fourthColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0)),
                  SizedBox(height: 25),
                  Container(
                    decoration: BoxDecoration(
                        border: const GradientBoxBorder(
                          gradient:
                              LinearGradient(colors: [GradiantV2, GradiantV1]),
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(45)),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: ticketIssue,
                      autofocus: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Asunto',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.title,
                          color: thirdColor,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        border: const GradientBoxBorder(
                          gradient:
                              LinearGradient(colors: [GradiantV2, GradiantV1]),
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(25)),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: ticketMessage,
                      minLines: 6,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Mensaje',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.message,
                          color: thirdColor,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          blurStyle: BlurStyle.normal,
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: -13,
                          offset: Offset(-15, -5)),
                      BoxShadow(
                          blurStyle: BlurStyle.normal,
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 18,
                          spreadRadius: -15,
                          offset: Offset(18, 5)),
                    ], borderRadius: BorderRadius.circular(15)),
                    child: RoundedButton(
                      text: "ENVIAR",
                      color: backgroundColor,
                      textColor: thirdColor,
                      press: () async {
                        //función envío de ticket
                        showGeneralDialog(
                            context: context,
                            transitionBuilder: (context, a1, a2, widget) {
                              return Center(child: ColorLoader3());
                            },
                            transitionDuration: Duration(milliseconds: 200),
                            barrierDismissible: false,
                            barrierLabel: '',
                            pageBuilder: (context, animation1, animation2) {
                              return widget;
                            });
                        await fetchTicket(prefs.nombreUsuario, ticketIssue.text,
                            ticketMessage.text);
                      },
                    ),
                  ),
                ]),
              )),
        ),
      ],
    );
  }
}
