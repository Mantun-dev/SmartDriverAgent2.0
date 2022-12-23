// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Agents/Screens/Restore/components/background.dart';
import 'package:flutter_auth/Agents/models/register.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:convert' show json;
import 'package:quickalert/quickalert.dart';
import '../../../../constants.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //variables globales para restablecer contraseña
  final prefs = new PreferenciasUsuario();
  TextEditingController user = new TextEditingController();
  String ip = "https://smtdriver.com";
  @override
  void initState() {
    super.initState();
    user = new TextEditingController(text: prefs.nombreUsuario);
  }

//función fetch para restore pass
  Future<dynamic> fetchUserResetPass(String agentUser) async {
    //<List<Map<String,Register>>>
    Map data = {'agentUser': agentUser};

    //api restore
    http.Response responses =
        await http.post(Uri.parse('$ip/api/reset'), body: data);
    final no = Register.fromJson(json.decode(responses.body));
    //alertas y redirecciones
    //print(responses.body);
    if (responses.statusCode == 200 && no.ok == true) {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
            (Route<dynamic> route) => false);
      });
      QuickAlert.show(
        context: context,
          title: no.title,
          text: no.message,
          type: QuickAlertType.success);
    } else if (no.ok != true) {
      QuickAlert.show(
        context: context,
          title: no.title,
          text: no.message,
          type: QuickAlertType.error);
    }
    return Register.fromJson(json.decode(responses.body));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              "REESTABLECER CONTRASEÑA",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 30, color: firstColor),
            ),
            Lottie.asset('assets/videos/reestablecer.json'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Escribe tu nombre de usuario, se enviará un enlace al correo para reestablecer tu contraseña',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: (15.0),
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: _crearUsuario(),
            ),
            RoundedButton(
                color: thirdColor,
                text: 'ENVIAR',
                press: () {
                  fetchUserResetPass(user.text);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return SecondRestoreScreen();
                  // }));
                }),
          ],
        ),
      ),
    );
  }

//Widgets fields
  Widget _crearUsuario() {
    return Container(
      margin: EdgeInsets.only(left: 35, right: 35),
      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 50),
      decoration: BoxDecoration(
          border: const GradientBoxBorder(
            gradient: LinearGradient(colors: [GradiantV_2, GradiantV_1]),
            width: 4,
          ),
          borderRadius: BorderRadius.circular(50)),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: user,
        //onChanged: onChanged,
        cursorColor: thirdColor,
        decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            color: thirdColor,
            size: 30,
          ),
          hintText: "Ingrese su usuario",
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
