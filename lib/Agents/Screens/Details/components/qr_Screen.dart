import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScannScreen extends StatefulWidget {
  const QrScannScreen({Key? key}) : super(key: key);

  @override
  _QrScannScreenState createState() => _QrScannScreenState();
}

class _QrScannScreenState extends State<QrScannScreen> {
  final prefs = new PreferenciasUsuario();

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
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(15),
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            //color: Colors.blueGrey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          height: 400,
          child: Column(children: [
            SizedBox(
              height: 30,
            ),
            Expanded(child: QrImage(data: prefs.nombreUsuario),)
            //llamado del QrImage para mostrar el qr del usuario actual            
          ]),
        ));
  }
}
