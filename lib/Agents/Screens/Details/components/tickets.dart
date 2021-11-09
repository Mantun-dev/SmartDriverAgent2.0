
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/historyTicket.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/loader.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/models/dataAgentMessage.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:sweetalert/sweetalert.dart';

class TicketScreen extends StatefulWidget {

  const TicketScreen({Key key, Plantilla plantilla}) : super(key: key);

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
    print("BACK BUTTON!"); // Do some stuff.    
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>
    HomeScreen()), (Route<dynamic> route) => false);
    return true;
  }

  @override
  Widget build(BuildContext context) {

    //declaración de variables
    final prefs = new PreferenciasUsuario();
    TextEditingController ticketIssue = new TextEditingController();
    TextEditingController ticketMessage = new TextEditingController();

  //función envío de ticket
  Future<dynamic>fetchTicket(String agentUser, String ticketIssue, String ticketMessage) async {
    //<List<Map<String,dynamic>>>
    String ip = "https://smtdriver.com";
    Map data = {
      'agentUser' : agentUser,
      'ticketIssue' : ticketIssue,
      'ticketMessage' : ticketMessage
    };

    //api envio de ticket
    http.Response response = await http.post(Uri.encodeFull('$ip/api/tickets'), body: data);
    final no = DataAgents.fromJson(json.decode(response.body));
    //alertas
    if (response.statusCode == 200 && no.ok == true) {  
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => HomeScreen()))
      .then((_) => TicketScreen()); 
      SweetAlert.show(context,
        title: "Ticket enviado",
        subtitle: no.message,
        style: SweetAlertStyle.success
      );
    }else if (no.ok != true) {
      SweetAlert.show(context,
          title: "Alerta",
          subtitle: no.message,
          style: SweetAlertStyle.error,
        );
    }
    return DataAgents.fromJson(json.decode(response.body));
  }


    return SingleChildScrollView(
      child: Column(
        children: [
          TextButton(style: TextButton.styleFrom(primary: Colors.white,backgroundColor: Colors.grey),
            onPressed: () => {            
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => HistoryTicketScreen()))
              .then((_) => HomeScreen()),
            },
            child: Text('Historial tickets'),            
          ),
          Card(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),margin: EdgeInsets.symmetric(horizontal: 0, vertical: 15),elevation: 10,
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.rectangle,borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.symmetric(horizontal: 15.0),width: 500,height: 420,
                child: Column(children: [
                  SizedBox(height: 20),
                  Text('Envie su solicitud cambio:',style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold,fontSize: 25.0)),
                  SizedBox(height: 40),
                  SizedBox(height: 10),
                  TextFormField(controller: ticketIssue,autofocus: false,
                    decoration: InputDecoration(labelText: 'Asunto',enabledBorder: OutlineInputBorder(borderSide:BorderSide(color: Colors.blueGrey[200], width: 1.0),),
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(controller: ticketMessage,minLines: 6,keyboardType: TextInputType.multiline,maxLines: null,
                    decoration: InputDecoration(labelText: 'Mensaje',enabledBorder: OutlineInputBorder(borderSide:BorderSide(color: Colors.blueGrey[200], width: 1.0)),
                      prefixIcon: Icon(Icons.message),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(style: TextButton.styleFrom(primary: Colors.white,backgroundColor: kCardColor2),
                    onPressed: () async {
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
                        return null;
                        }
                      );
                      await fetchTicket(prefs.nombreUsuario, ticketIssue.text, ticketMessage.text);                      
                    },
                    child: Text('Enviar'),                    
                  ),
                  
                ]),
              )),
        ],
      ),
    );
  }
}
