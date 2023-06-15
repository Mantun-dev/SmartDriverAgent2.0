import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:lottie/lottie.dart';
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

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Muestra este código QR para poder abordar',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 21.0)
            ),
        
        Padding(
          padding: const EdgeInsets.only(top:20.0, bottom: 2),
          child: Container(
              constraints: BoxConstraints(
                maxWidth: 50,
                maxHeight: 50,
              ),
              child: Lottie.asset('assets/videos/check.json')
            ),
        ),
        
          Padding(
            padding: const EdgeInsets.only(bottom:20.0),
            child: Text(
              'Este es un código único.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 20.0
              )
            ),
          ),
            
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: QrImage(data: prefs.nombreUsuario),
          ),
        ],
      ),
    );
  }
}
