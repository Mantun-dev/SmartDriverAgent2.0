// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/loader.dart';
import 'package:flutter_auth/Agents/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Agents/Screens/Register/register_screen.dart';
import 'package:flutter_auth/Agents/Screens/Signup/components/background.dart';
import 'package:flutter_auth/Agents/models/register.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:convert' show json;
import 'package:sweetalert/sweetalert.dart';

import '../../../../constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //declaración de variables globales para sign up
  final prefs = new PreferenciasUsuario();
  TextEditingController user = new TextEditingController();
  TextEditingController userEmail = new TextEditingController();
  String ip = "https://smtdriver.com";

  //variables que necesitan incialización que son preferencias de usuarios
  @override
  void initState() {
    super.initState();
    user = new TextEditingController(text: prefs.nombreUsuario);
    userEmail = new TextEditingController(text: prefs.emailUsuario);
  }

  //función fetch para registrar usuarios
  Future<dynamic> fetchUserRegister(String agentUser, String agentEmail) async {
    //<List<Map<String,Register>>>
    Map data = {'agentUser': agentUser, 'agentEmail': agentEmail};
    //manejo de api register
    http.Response responses =
        await http.post(Uri.parse('$ip/api/code'), body: data);
    final no = Register.fromJson(json.decode(responses.body));
    //redirección y alertas
    if (responses.statusCode == 200 && no.ok == true) {
      prefs.nombreUsuarioDos = agentUser;
      prefs.emailUsuario = agentEmail;

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => RegisterScreen()),
          (Route<dynamic> route) => false);
      SweetAlert.show(context,
          title: no.title,
          subtitle: no.message,
          style: SweetAlertStyle.success);
    } else if (no.ok != true) {
      SweetAlert.show(
        context,
        title: no.title,
        subtitle: no.message,
        style: SweetAlertStyle.error,
      );
    }
    return Register.fromJson(json.decode(responses.body));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: backgroundColor,
      child: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                "REGÍSTRATE",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: firstColor),
              ),
              Lottie.asset('assets/videos/registro.json'),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "Escribe tu usuario designado y un correo válido, se enviará un código de confirmación para que puedas registrarte.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.white),
                ),
              ),
              _crearUsuario(),
              SizedBox(height: 10),
              _crearEmail(),
              RoundedButton(
                color: thirdColor,
                text: "SOLICITAR CÓDIGO",
                press: () async {
                  //función fetch
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
                  await fetchUserRegister(user.text, userEmail.text);
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

//Widgets usuario y password
  Widget _crearUsuario() {
    return Container(
      margin: EdgeInsets.only(left: 35, right: 35),
      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 50),
      decoration: BoxDecoration(
          border: const GradientBoxBorder(
            gradient: LinearGradient(colors: [GradiantV1, GradiantV2]),
            width: 4,
          ),
          borderRadius: BorderRadius.circular(50)),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: user,
        //onChanged: onChanged,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            color: thirdColor,
            size: 30,
          ),
          hintText: "Ingresa tu usuario",
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          //prefs.nombreUsuario = value;
        },
      ),
    );
  }

  Widget _crearEmail() {
    return Container(
      margin: EdgeInsets.only(left: 35, right: 35),
      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 50),
      decoration: BoxDecoration(
          border: const GradientBoxBorder(
            gradient: LinearGradient(colors: [GradiantV1, GradiantV2]),
            width: 4,
          ),
          borderRadius: BorderRadius.circular(50)),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: userEmail,
        //onChanged: onChanged,
        cursorColor: thirdColor,
        decoration: InputDecoration(
          hintText: "Ingresa tu email",
          icon: Icon(
            Icons.email,
            color: thirdColor,
            size: 30,
          ),
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white),
        ),
        onChanged: (value) {
          //prefs.emailUsuario = value;
        },
      ),
    );
  }
}
