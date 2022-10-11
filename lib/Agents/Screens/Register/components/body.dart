// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Agents/Screens/Signup/components/background.dart';
import 'package:flutter_auth/Agents/models/register.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/components/rounded_button.dart';

import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:sweetalert/sweetalert.dart';

import '../../../../constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //variables globales para register user y code
  final prefs = new PreferenciasUsuario();
  TextEditingController user = new TextEditingController();
  TextEditingController userEmail = new TextEditingController();
  TextEditingController userCode = new TextEditingController();
  TextEditingController userPassword1 = new TextEditingController();
  TextEditingController userPassword2 = new TextEditingController();
  String ip = "https://smtdriver.com";

  @override
  void initState() {
    super.initState();
    user = new TextEditingController(text: prefs.nombreUsuarioDos);
    userEmail = new TextEditingController(text: prefs.emailUsuario);
  }

  //función fetch register user and code
  Future<dynamic> fetchUserRegisterCode(
      String agentUser,
      String agentEmail,
      String agentSecurityCode,
      String agentPassword,
      String agentPassword2) async {
    //<List<Map<String,Register>>>
    Map data = {
      'agentUser': agentUser,
      'agentEmail': agentEmail,
      'agentSecurityCode': agentSecurityCode,
      'agentPassword': agentPassword,
      'agentPassword2': agentPassword2
    };
    //api register
    http.Response responses =
        await http.post(Uri.parse('$ip/api/register'), body: data);
    final no = Register.fromJson(json.decode(responses.body));
    //redirección y alertas
    if (responses.statusCode == 200 && no.ok == true) {
      //print(responses.body);
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
            (Route<dynamic> route) => false);
      });
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
              Text(
                "REGÍSTRATE",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/driver-pana.svg",
                height: size.height * 0.35,
              ),
              Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                        'Ingresa una contraseña y el código de confirmacion enviado a tu correo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  )),
              _crearUsuario(),
              _crearEmail(),
              _crearCode(),
              _crearPassw1(),
              _crearPassw2(),
              RoundedButton(
                  text: "REGISTRARME",
                  press: () {
                    fetchUserRegisterCode(user.text, userEmail.text,
                        userCode.text, userPassword1.text, userPassword2.text);
                  }),
              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }

//Widgets de fields
  Widget _crearUsuario() {
    return TextFieldContainer(
      child: TextField(
        enabled: false,
        controller: user,
        //onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            color: kPrimaryColor,
          ),
          hintText: "Ingrese su usuario",
          border: InputBorder.none,
        ),
        onChanged: (value) {
          prefs.nombreUsuarioDos = value;
        },
      ),
    );
  }

  Widget _crearEmail() {
    return TextFieldContainer(
      child: TextField(
        enabled: false,
        controller: userEmail,
        //onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Ingresa tu email",
          icon: Icon(
            Icons.email,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          prefs.emailUsuario = value;
        },
      ),
    );
  }

  Widget _crearCode() {
    return TextFieldContainer(
      child: TextField(
        controller: userCode,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: 'Codigo de Verificación',
          icon: Icon(
            Icons.lock_outline,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _crearPassw1() {
    return TextFieldContainer(
      child: TextField(
        controller: userPassword1,
        obscureText: true,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Contraseña",
          icon: Icon(
            Icons.lock_rounded,
            color: kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _crearPassw2() {
    return TextFieldContainer(
      child: TextField(
        controller: userPassword2,
        obscureText: true,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Confirmar contraseña",
          icon: Icon(
            Icons.lock_rounded,
            color: kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
