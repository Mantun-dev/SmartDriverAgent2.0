// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/historyTicket.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/models/dataAgentMessage.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
//import 'package:sweetalert/sweetalert.dart';
import 'package:quickalert/quickalert.dart';
import '../../../../components/progress_indicator.dart';
import 'package:dotted_line/dotted_line.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({Key? key, Plantilla? plantilla}) : super(key: key);

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  TextEditingController ticketIssue = new TextEditingController();
  TextEditingController ticketMessage = new TextEditingController();

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

    //función envío de ticket
    Future<dynamic> fetchTicket(String agentUser, String ticketIssue, String ticketMessage) async {
      LoadingIndicatorDialog().show(context);
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
      // if (ticketIssue == "" || ticketMessage == "") {
      //   SweetAlert.show(context,
      //       title: "Campos vacios",
      //       subtitle: "Favor completar los campos requeridos",
      //       style: SweetAlertStyle.error);
      //   Navigator.pop(context);
      // }

      LoadingIndicatorDialog().dismiss();
      if (response.statusCode == 200 && no.ok == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return HomeScreen();
          })
        );

        QuickAlert.show(
          context: context,
          title: "Ticket enviado",
          text: no.message,
          type: QuickAlertType.success
        );
      }  
      if (no.ok != true) {
        QuickAlert.show(
        context: context,
          title: "Alerta",
          text: no.message,
          type: QuickAlertType.error);
        new Future.delayed(new Duration(seconds: 2), () {
          Navigator.pop(context);
        });
        new Future.delayed(new Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      }
      return DataAgents.fromJson(json.decode(response.body));
    }
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10, bottom: 12, top: 12),
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20)
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                
                Padding(
                  padding: const EdgeInsets.only(right:52, left: 52, top: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: TextField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          controller: ticketIssue,
                          autofocus: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Asunto',
                            labelStyle: TextStyle(
                              color: Theme.of(context).hintColor, fontSize: 15, fontFamily: 'Roboto'
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: SvgPicture.asset(  
                              "assets/icons/mensaje.svg",
                              color: Color.fromRGBO(40, 93, 169, 1),
                              width: 20,
                              height: 20,
                            ),
                            
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                    ],
                  ),
                ), 
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRect(
                          child: Align(
                            alignment: Alignment.centerRight,
                            widthFactor: 0.5,
                            child: Container(
                              width: 60,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                                  
                        Expanded(child: DottedLine(dashLength:12, dashGapLength:10, dashColor: Theme.of(context).primaryColorDark,)),
                                  
                        ClipRect(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.5,
                            child: Container(
                              width: 60,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0, left: 52, right: 52),
                  child: TextField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: ticketMessage,
                    minLines: 6,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Mensaje',
                      labelStyle: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 15, fontFamily: 'Roboto'
                          ),
                      prefixIcon: Icon(
                        Icons.message,
                        color: Colors.transparent,
                        size: 30,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 80.0), // Ajusta el padding vertical
                    ),
                  ),
                ),
                
                
                 
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    border: Border.all(color: Theme.of(context).primaryColorDark),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: TextButton(
                      onPressed: () async {
                
                        if(ticketMessage.text.isEmpty || ticketIssue.text.isEmpty){
                          QuickAlert.show(
                            context: context,
                            title: "Alerta",
                            text: 'El mensaje o asunto no puede estar vacio',
                            type: QuickAlertType.error
                          );
                          return;
                        }
                        
                        //función envío de ticket
                        await fetchTicket(prefs.nombreUsuario, ticketIssue.text,ticketMessage.text);
                      },
                      child: Text(
                        "Enviar",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, color: Theme.of(context).primaryColorLight),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: size.height*0.09),
                
                Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColorDark),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HistoryTicketScreen())).then((_) => HomeScreen());
                          },
                          child: Text(
                            "Solicitudes Enviadas",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
