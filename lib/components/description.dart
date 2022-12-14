import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/historyTrip.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/next_trip.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/qr_Screen.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/tickets.dart';
import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/constants.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          _processCards(context),
        ],
      ),
    );
  }

  Widget _processCards(BuildContext context) {
    return Column(
      children: [
        if (widget.plantilla.id == 1) ...[
          if (prefs.companyId == "2") ...{
            if (radioShowAndHide == true) ...{
              showAndHide("2"),
            },
          },
          if (prefs.companyId == "3") ...{
            if (radioShowAndHide == true) ...{
              showAndHide("3"),
            },
          },
          _mostrarPrimerventana(),
          SizedBox(height: 50),
        ] else if (widget.plantilla.id == 2) ...[
          _mostrarSegundaVentana(),
          SizedBox(height: 50.0),
        ] else if (widget.plantilla.id == 3) ...[
          _mostrarCuartaVentana(),
          SizedBox(height: 100.0),
        ] else if (widget.plantilla.id == 4) ...[
          _mostrarTerceraVentana(),
          SizedBox(height: 20.0),
        ]
      ],
    );
  }

  Widget showAndHide(String id) {
    return Container(
      child: Column(
        children: [
          Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: radioShowAndHide,
              child: message(id)),
        ],
      ),
    );
  }

  Widget message(String id) {
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
                color: backgroundColor2,
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
                TextButton(onPressed: () => id=='2'?launchUrl(Uri.parse('tel://3317-4537')):launchUrl(Uri.parse('tel://8871-6819')),child: RichText(textAlign: TextAlign.center,text: TextSpan(children: <TextSpan>[
                    TextSpan(text: id=='2'?"Si tiene alg??n inconveniente con su programaci??n, puede escribir al n??mero: ":"Para consultas o sugerencias de 9:00am a 5:00pm puede escribirnos al n??mero: ",style: TextStyle(color: Colors.white)),
                    TextSpan(text: id=='2'?"3317-4537":'8871-6819' ,style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold)),]),
                    )),

                SizedBox(height: 24.0),
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                if (radioShowAndHide) {
                  setState(() {
                    radioShowAndHide = false;
                  });
                } else {
                  setState(() {
                    radioShowAndHide = true;
                  });
                }
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
