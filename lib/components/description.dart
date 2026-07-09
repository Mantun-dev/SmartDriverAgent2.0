import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/historyTrip.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/next_trip.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/qr_Screen.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/tickets.dart';
import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:url_launcher/url_launcher.dart';

class Description extends StatefulWidget { 
  const Description({
    Key? key,
    required this.plantilla,    
  }) : super(key: key);

  final Plantilla plantilla;

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  bool radioShowAndHide = true;
  String? contactNumber;
  String? contactDesc;

  @override
  void initState() {
    print("🚀 Entrando al initState de esta pantalla...");
    super.initState();
    fetchTestContactByAgent().then((response) {
      print("📞 Respuesta de contacto: ${response.ok}, Tipo: ${response.type}, Mensaje: ${response.message?.length ?? 0} contactos"); // Esto te ayudará a ver qué está devolviendo la API
      // 1. Validamos que la petición fue exitosa y que la lista no esté vacía
      if (response.ok == true && response.message != null && response.message!.isNotEmpty) {
        setState(() {
          // 2. Accedemos al primer elemento de la lista [0] y sacamos sus propiedades
          contactNumber = response.message![0].phoneNumber;
          contactDesc = response.message![0].contactDesc; 
        });
      }
    }).catchError((error) {
      // Es buena práctica manejar el error por si la API falla o el token expira
      print("Error obteniendo el contacto: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return _processCards(context);
  }

  bool get hasValidContactData {
    return contactDesc != null && contactDesc!.trim().isNotEmpty &&
           contactNumber != null && contactNumber!.trim().isNotEmpty;
  }

  Widget _processCards(BuildContext context) {
    debugPrint("🚀 Entrando al initState de esta pantalla...");
    return Column(
      children: [
        if (widget.plantilla.id == 1) ...[
          // 2. Evaluamos si hay datos válidos. Si no los hay, el widget ni siquiera se dibuja en el árbol.
          if (hasValidContactData) ...[
            showAndHide()
          ],
          _mostrarPrimerventana(),
        ] else if (widget.plantilla.id == 2) ...[
          _mostrarSegundaVentana(),
        ] else if (widget.plantilla.id == 3) ...[
          _mostrarCuartaVentana(),
        ] else if (widget.plantilla.id == 4) ...[
          _mostrarTerceraVentana(),
        ]
      ],
    );
  }

  Widget showAndHide() {
    return Container(
      child: Column(
        children: [
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: radioShowAndHide,
            child: message(), // Quitamos el parámetro aquí también
          ),
        ],
      ),
    );
  }

  Widget message() {
    return Container(
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 18.0,
            ),
            margin: EdgeInsets.only(top: 13.0, right: 8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                TextButton(
                  // Usamos la variable contactNumber para armar la URL del teléfono
                  onPressed: () => launchUrl(Uri.parse('tel://$contactNumber')),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          // Asignamos la descripción dinámica (le agregué un espacio al final para que no quede pegado al número)
                          text: "$contactDesc ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          // Asignamos el número dinámico
                          text: contactNumber ?? "",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                // Simplifiqué un poco el toggle de la variable booleana
                setState(() {
                  radioShowAndHide = !radioShowAndHide;
                });
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mostrarPrimerventana() {
    return NextTripScreen();
  }

  Widget _mostrarSegundaVentana() {
    return HistoryTripScreen();
  }

  Widget _mostrarTerceraVentana() {
    return TicketScreen();
  }

  Widget _mostrarCuartaVentana() {
    return QrScannScreen();
  }
}
